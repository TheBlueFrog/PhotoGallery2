package com.mike.website3;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static org.hamcrest.MatcherAssert.assertThat;

/**
 * Created by mike on 7/23/2017.
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class TestOffer {

    private static final String TAG = TestOffer.class.getSimpleName();

    @Test
    public void test_a () {
        List<ItemAvailability> x = ItemAvailability.findAll();
        assertThat("get list", x != null);
    }

    @Test
    public void test_b () {
        List<Offer> targets = getLimited();

        if (targets.size() == 0) {
            assertThat("skip modifying an existing limited offer", true);
            return;
        }

        Offer target = targets.get(0);
        ItemAvailability limited = target.getAvailability();
        assertThat("has limited availability", limited != null);

        int available = limited.getAvailableQuantity();
        assertThat(">= 0", available >= 0);

        int decresedBy = limited.decreaseAvailable(available);
        assertThat("decreased to 0", decresedBy == available);

        int newNewAvaliable = limited.increaseAvailable(available);
        assertThat("increased back to original", newNewAvaliable == available);
    }

    @Test
    public void test_ba () {
        List<Offer> targets = getLimited();

        if (targets.size() == 0) {
            assertThat("skip modifying an existing limited offer", true);
            return;
        }

        Offer target = targets.get(0);
        ItemAvailability limited = target.getAvailability();
        assertThat("has limited availability", limited != null);

        int available = limited.getAvailableQuantity();
        assertThat(">= 0", available >= 0);

        int decresedBy = limited.decreaseAvailable(available + 5);
        assertThat("decreased to 0", decresedBy == available);

        int newNewAvaliable = limited.increaseAvailable(available);
        assertThat("increased back to original", newNewAvaliable == available);
    }

    @Test
    public void test_c () {
        List<Offer> targets = getUnlimited();

        if (targets.size() == 0) {
            assertThat("skip creating new limited offer, all offers are limited", true);
            return;
        }

        Offer target = targets.get(0);
        ItemAvailability limited = target.getAvailability();
        assertThat("doesn't have limited availability", limited == null);

        new ItemAvailability(target.getItemId(), 14).save();
        limited = target.getAvailability();
        assertThat("now has limited quantity", target.hasLimitedQuantity());
        assertThat("now has OfferAvailable record", limited != null);

        assertThat("has right quantity", target.getAvailability().getAvailableQuantity() == 14);
        assertThat("has right quantity", limited.getAvailableQuantity() == 14);

        limited.delete();
        assertThat("now unlimited", ! target.hasLimitedQuantity());
        assertThat("no OfferAvailable record", target.getAvailability() == null);
    }

    @Test
    public void test_d () {
        List<Offer> targets = getLimited();

        if (targets.size() == 0) {
            assertThat("skip updating existing limited offer, no limited offer", true);
            return;
        }

        Offer target = targets.get(0);
        ItemAvailability limited = target.getAvailability();
        assertThat("has limited availability", limited != null);

        double originalBuyPrice = target.getOurBuyPrice();
        double originalSellPrice = target.getOurSellPrice();
        int originalQuantity = limited.getAvailableQuantity();
        List<Timestamp> errors = new ArrayList<>();

        Offer.update(target,
                originalBuyPrice,
                originalSellPrice,
                "Unlimited",
                errors);

        assertThat("no errors", errors.size() == 0);
        assertThat("now unlimited", target.hasLimitedQuantity() == false);

        Offer.update(target,
                originalBuyPrice,
                originalSellPrice,
                "6",
                errors);

        assertThat("no errors", errors.size() == 0);
        assertThat("now limited", target.hasLimitedQuantity() == true);
        assertThat("right quantity", target.getAvailability().getAvailableQuantity() == 6);

        Offer.update(target,
                originalBuyPrice,
                originalSellPrice,
                Integer.toString(originalQuantity),
                errors);

        assertThat("no errors", errors.size() == 0);
        assertThat("right quantity", target.getAvailability().getAvailableQuantity() == originalQuantity);
        assertThat("right buy price", target.getOurBuyPrice() == originalBuyPrice);
        boolean b = target.getOurSellPrice() == originalSellPrice;
        assertThat("right sell price", b);
    }

    interface filter {
        boolean func (Offer offer);
    }

    private List<Offer> getLimitedOffers(filter f) {
        List<ItemAvailability> x = ItemAvailability.findAll();
        return Offer.getEnabledOffers().stream()
                .filter(offer -> f.func(offer))
                .collect(Collectors.toList());
    }

    private List<Offer> getLimited() {
        return getLimitedOffers(new filter() {
            @Override
            public boolean func(Offer offer) {
                return offer.hasLimitedQuantity();
            }
        });
    }
    private List<Offer> getUnlimited() {
        return getLimitedOffers(new filter() {
            @Override
            public boolean func(Offer offer) {
                return ! offer.hasLimitedQuantity();
            }
        });
    }
}

