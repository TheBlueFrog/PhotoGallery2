package com.mike.website3;

import com.mike.util.Log;
import com.mike.util.Util;
import com.mike.website3.db.*;
import com.mike.website3.milkrun.MilkRun;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;

/**
 * Created by mike on 7/23/2017.
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class TestCartOffer {

    private static final String TAG = TestCartOffer.class.getSimpleName();
    private CartOffer cartOffer;

    @Test
    public void test_a () {
        List<CartOffer> x = CartOffer.findAll();
        assertThat("get a list", x != null);

        String earliestData = "2017-01-01 00:00:00";
        Timestamp ealiest = Timestamp.valueOf(earliestData);
        Timestamp latest = new Timestamp(MySystemState.getInstance().now());

        final int[] count = {1};

        Map<String, User> userCache = new HashMap<>();
        Map<String, MilkRun> milkRunCache = new HashMap<>();

        x.forEach(cartOffer -> {
            Timestamp cartOfferTimestamp = cartOffer.getTime();
            assertThat("should be after earliest", cartOfferTimestamp.after(ealiest));
            assertThat("should be before now", latest.after(cartOfferTimestamp));

            String userId = cartOffer.getUserId();
            if ( ! userCache.containsKey(userId))
                userCache.put (userId, User.findByUserId(userId));

            User user = userCache.get(userId);
            assertThat("should be a valid user", user != null);

            Timestamp offerTimestamp = cartOffer.getOfferTimestamp();
            assertThat("should be after 2017-01-01", offerTimestamp.after(ealiest));
            assertThat("should be before now", latest.after(offerTimestamp));

            int quantity = cartOffer.getQuantity();
            assertThat("non-zero", quantity > 0);
            assertThat("something reasonable", quantity < 100);

            Timestamp stoppedSupportingRecurringOffers = Timestamp.valueOf("2017-08-12 00:00:00");
            String frequency = cartOffer.getFrequency();
            if (cartOfferTimestamp.after(stoppedSupportingRecurringOffers)) {
                assertThat(
                        String.format("only support ones after 2017-08-01 00:00:00, found %s with date %s",
                                frequency,
                                Util.formatTimestamp(cartOfferTimestamp, "YYYY-MM-dd")),
                        frequency.equals("once") || frequency.equals(""));
            }
            else {
                assertThat("once of three",
                        (frequency.equals("once") || frequency.equals("weekly") || frequency.equals("bi-weekly")));
            }

            String milkRunId = cartOffer.getMilkRunId();
            if (milkRunId.equals("LostAndFound")) {
                Log.d(TAG, "Cart Offer in LostAndFound");
            }
            else {
                MilkRunDB milkRunDB = MilkRunDB.findById(milkRunId);
                assertThat("must be there", milkRunDB != null);
                assertThat("not too early", milkRunDB.getTimestamp().after(ealiest));
                assertThat("not too late", milkRunDB.getTimestamp().before(latest));

                if ( ! milkRunCache.containsKey(milkRunId))
                    milkRunCache.put(milkRunId, MilkRun.load(milkRunId));

                MilkRun milkRun = milkRunCache.get(milkRunId);
                assertThat("make sure the MilkRun has this CartOffer", milkRun.getCartOffers().contains(cartOffer));

//                if (milkRunDB.getState().equals(MilkRunMem.State.Open)) {
//                    assertThat("if the run is open this should be false", !cartOffer.getClosed());
//                } else {
//                    assertThat("else should be true", cartOffer.getClosed());
//                }
            }
            if((count[0]++ % 100) == 0)
                Log.d(TAG, String.format("Checked %d of %d CartOffers", count[0], x.size()));
        });
    }


    @Test
    public void test_b () {
        // look for cart offers that don't link to offers
        // look for offers that don't link to items

        List<CartOffer> x = CartOffer.findAll();
        assertThat("get a list", x != null);

        x.forEach(cartOffer -> {
            Offer offer = cartOffer.getOffer();
            assertThat("Have an offer", offer != null);

            Item item = offer.getItem();
            assertThat("Have an item", item != null);
        });

        List<Offer> y = Offer.findAll();
        y.forEach(offer -> {
            Item item = offer.getItem();
            assertThat("Have an item", item != null);
        });
    }

    @Test
    public void test_c () {
        // look for offers that don't link to items

        List<Offer> y = Offer.findAll();
        y.forEach(offer -> {
            Item item = offer.getItem();
            assertThat("Have an item", item != null);
        });
    }

    @Test
    public void test_d () {
        // look for items with broken or weird categories

        List<Item> y = Item.findAll();
        y.forEach(item -> {
            ItemCategoryBinding.findByItemId(item.getId()).forEach(itemCategoryBinding -> {
                String z = itemCategoryBinding.getCategoryId();
                assertThat("Have a valid categoryId", z != null);
                ItemCategory itemCategory = ItemCategory.findById(z);
                assertThat("Have a valid category", itemCategory.getCategory() != null);
                assertThat("Have a valid binding level", itemCategoryBinding.getLevel() != null);
            });

            ItemCategoryBinding icb = ItemCategoryBinding.findByItemIdAndBindingLevel(
                    item.getId(),
                    ItemCategoryBinding.BindingLevel.Primary);

            assertThat("Have a primary category", icb != null);
            assertThat("Have a valid primary category", ItemCategory.findById(icb.getCategoryId()) != null);
        });
    }
}
