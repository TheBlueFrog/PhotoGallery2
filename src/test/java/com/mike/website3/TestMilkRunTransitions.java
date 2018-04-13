package com.mike.website3;

import com.mike.website3.db.*;
import com.mike.website3.milkrun.MilkRun;
import com.mike.website3.milkrun.MilkRunMem;
import com.mike.website3.milkrun.routing.annealing.AnnealData;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;

/**
 * Created by mike on 7/23/2017.
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class TestMilkRunTransitions {

    private static final String TAG = TestMilkRunTransitions.class.getSimpleName();

    /*
        step a MilkRun from Open to Delivered
     */

    @Test
    public void test_a () {

        List<MilkRunDB> milkRunDBs = MilkRunDB.findByStatusOrderByTimestampDesc(MilkRunMem.State.Open);
        assertThat ("should have exactly one", milkRunDBs.size() == 1);

        MilkRun run = MilkRun.load(milkRunDBs.get(0).getId());
        User mike = User.findByUsername("mike");

        if ( ! mike.doesRole2(UserRole.Role.OpenPhaseAdmin)) {
            mike.addRole(UserRole.Role.OpenPhaseAdmin);
        }
        assertThat("we have the privilege", mike.doesRole2(UserRole.Role.OpenPhaseAdmin));
        if ( ! mike.doesRole2(UserRole.Role.ClosedPhaseAdmin)) {
            mike.addRole(UserRole.Role.ClosedPhaseAdmin);
        }
        assertThat("we have the privilege", mike.doesRole2(UserRole.Role.ClosedPhaseAdmin));

        List<Offer> offers = Offer.findEnabled();
        assertThat("must have at least two offers", offers.size() > 1);

        List<Timestamp> addedOfferIds = new ArrayList<>();
        while (run.getCartOffers().size() < 2) {
            Offer offer = offers.get(MySystemState.getInstance().getRandom().nextInt(offers.size()));
            if ( ! mike.cartContains(run.getId(), offer.getTime())) {
                addedOfferIds.add(offer.getTime());
                mike.addToCart(offer.getTime(), 1);

                run = MilkRun.load(run.getId());
            }
        }

        assertThat("have enough CartOffers", run.getCartOffers().size() > 1);

        mike.addRole(UserRole.Role.OpenPhaseAdmin);
        run.setClosing(mike);
        assertThat("run is Closing", run.getState() == MilkRunMem.State.Closing);

        run.moveBadAddressesToOpen();

        run.setUnrouted(mike);
        run = MilkRun.load(run.getId());
        assertThat("run in db is Unrouted", run.getState() == MilkRunMem.State.Unrouted);

        mike.addRole(UserRole.Role.RoutingAdmin);

        AnnealData routeData = run.getRouteData();
        run.computeRoute(routeData);
        assertThat("we can compute a route", routeData.getStops().size() > 0);

        run.setRouted();
        run = MilkRun.load(run.getId());
        assertThat("run in db is Routed", run.getState() == MilkRunMem.State.Routed);

        run.setDelivering();
        assertThat("run is Delivering", run.getState() == MilkRunMem.State.Delivering);

        run = MilkRun.load(run.getId());
        assertThat("run in db is Delivering", run.getState() == MilkRunMem.State.Delivering);

        run.setDelivered();
        assertThat("run is Delivered", run.getState() == MilkRunMem.State.Delivered);

        run = MilkRun.load(run.getId());
        assertThat("run in db is Delivered", run.getState() == MilkRunMem.State.Delivered);

        List<MilkRunDB> delivered = MilkRunDB.findByStatusAndParentMilkRunId(MilkRunMem.State.Delivered, "");
        for (MilkRunDB db : delivered) {
            if (db.getId().equals(run.getId())) {
                assertThat("run found in the db's Delivered runs", db.getState().equals(MilkRunMem.State.Delivered));

                MilkRun milkRun = new MilkRun(db);
                final int[] found = {0};
                List<CartOffer> cartOffers = milkRun.getCartOffers();
                cartOffers.forEach(cartOffer -> {
                    if (addedOfferIds.contains(cartOffer.getOfferTimestamp()))
                        found[0]++;
                });

                assertThat("found all the Offers we added", found[0] == addedOfferIds.size());
            }
        }
    }

}

