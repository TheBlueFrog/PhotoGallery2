package com.mike.website3;

import com.mike.exceptions.InvalidAddressException;
import com.mike.exceptions.InvalidMilkRunUnsplitOperationException;
import com.mike.website3.db.User;
import com.mike.website3.milkrun.MilkRun;
import com.mike.website3.milkrun.MilkRunMem;
import com.mike.website3.milkrun.routing.UndeliverableRouteException;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;

/**
 * Created by mike on 7/23/2017.
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class TestMilkRunUnsplit {

    private static final String TAG = TestMilkRunUnsplit.class.getSimpleName();

    @Test
    public void test_a () {
        String milkRunId = MilkRunDB.findOpen().getId();

        MilkRun milkRun = MilkRun.load(milkRunId);
        assertThat("must be loadable", milkRun != null);

        milkRun.setClosing(User.findById("mike"));
        milkRun.setUnrouted(User.findById("mike"));
        assertThat("must be unrouted", milkRun.getState().equals(MilkRunMem.State.Unrouted));

        List<CartOffer> cartOffers = milkRun.getCartOffers();
        ArrayList<CartOffer> aCartOffers = new ArrayList<>();
        ArrayList<CartOffer> bCartOffers = new ArrayList<>();
        for (int i = 0; i < cartOffers.size(); ) {
            aCartOffers.add(cartOffers.get(i++));
            if (i < cartOffers.size())
                bCartOffers.add(cartOffers.get((i++)));
        }

        User mike = User.findByUserId("mike");
        int numRuns = MilkRunDB.findAll().size();

        // this is what the manual splitter does, mark the
        // parent split, create the kids, they will be set to Closed
        // automatically since that constructor is only used by
        // the splitter
        try {
            milkRun.setState(MilkRunMem.State.Split);
            new MilkRun(milkRun, mike, mike, aCartOffers, new ArrayList<>(), MilkRunMem.State.Unrouted);
            new MilkRun(milkRun, mike, mike, bCartOffers, new ArrayList<>(), MilkRunMem.State.Unrouted);
        } catch (InvalidMilkRunUnsplitOperationException e) {
            assertThat(e.getMessage(), false);
        } catch (UndeliverableRouteException e) {
            assertThat(e.getMessage(), false);
        } catch (InvalidAddressException e) {
            assertThat(e.getMessage(), false);
        }

        assertThat("we added 2 MilkRuns", MilkRunDB.findAll().size() == (2 + numRuns));

        // reload parent from db
        milkRun = MilkRun.load(milkRunId);
        assertThat("parent is Split", milkRun.getState().equals(MilkRunMem.State.Split));
        assertThat("parent is Split", milkRun.isSplit());

        // load kids from db
        List<MilkRunDB> kids = MilkRunDB.findByParentMilkRunIdOrderByTimestampDesc(milkRun.getId());
        assertThat("we added 2 children to original run", kids.size() == 2);
        assertThat("child has correct parent", kids.get(0).getParentMilkRunId().equals(milkRun.getId()));
        assertThat("child has correct parent", kids.get(1).getParentMilkRunId().equals(milkRun.getId()));

        assertThat("child is Unrouted", kids.get(0).getState().equals(MilkRunMem.State.Unrouted));
        assertThat("child is Unrouted", kids.get(1).getState().equals(MilkRunMem.State.Unrouted));

        assertThat("parent can be unsplit", milkRun.canBeUnsplit());

        try {
            milkRun.unsplit();
        } catch (InvalidMilkRunUnsplitOperationException e) {
            assertThat(e.getMessage(), false);
        }

        // reload parent from db
        milkRun = MilkRun.load(milkRunId);
        assertThat("Unsplit run is Unrouted", milkRun.getState().equals(MilkRunMem.State.Unrouted));
        assertThat("Have correct number ofMilkRuns", MilkRunDB.findAll().size() == numRuns);
        assertThat("Have correct number of CartOffers", milkRun.getCartOffers().size() == cartOffers.size());
    }


}

