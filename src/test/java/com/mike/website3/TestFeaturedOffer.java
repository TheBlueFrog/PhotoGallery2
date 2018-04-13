package com.mike.website3;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.sql.Timestamp;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;

/**
 * Created by mike on 7/23/2017.
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class TestFeaturedOffer {

    private static final String TAG = TestFeaturedOffer.class.getSimpleName();

    @Test
    public void test_a () {
        List<FeaturedOffer> x = FeaturedOffer.findAll();
        assertThat("table is available", x != null);

        if (x.size() == 0) {
            List<Offer> offers = Offer.findEnabled();
            if (offers.size() > 0) {
                Offer offer = offers.get(0);

                Timestamp now = MySystemState.getInstance().nowTimestamp();
                Timestamp beforeNow = new Timestamp(now.getTime() - (60 * 1000L));
                Timestamp afterNow = new Timestamp(beforeNow.getTime() + (60 * 1000L));

                List<FeaturedOffer> originalFeaturedOffers = FeaturedOffer.findByOfferId(offer.getTime());

                FeaturedOffer featuredOffer = new FeaturedOffer(offer, beforeNow, afterNow);
                featuredOffer.save();
                featuredOffer = FeaturedOffer.findById(featuredOffer.getId());
                assertThat("should be active", featuredOffer.isActive());

                FeaturedOffer featuredOffer2 = new FeaturedOffer(offer, afterNow, new Timestamp(afterNow.getTime() + (60 * 1000L)));
                featuredOffer2.save();
                featuredOffer2 = FeaturedOffer.findById(featuredOffer2.getId());
                assertThat("should not be active", featuredOffer2.isActive());

                FeaturedOffer featuredOffer3 = new FeaturedOffer(offer, beforeNow, new Timestamp(afterNow.getTime() + (30 * 1000L)));
                featuredOffer3.save();
                featuredOffer3 = FeaturedOffer.findById(featuredOffer3.getId());
                assertThat("should not be active", featuredOffer3.isActive());

                List<FeaturedOffer> currentFeaturedOffers = FeaturedOffer.findByOfferId(offer.getTime());
                assertThat("featured offers count increased", currentFeaturedOffers.size() == (originalFeaturedOffers.size() + 3));

                featuredOffer.delete();
                featuredOffer2.delete();
                featuredOffer3.delete();

                currentFeaturedOffers = FeaturedOffer.findByOfferId(offer.getTime());
                assertThat("featured offers count decreased", currentFeaturedOffers.size() == originalFeaturedOffers.size());
            }
        }
    }
}

