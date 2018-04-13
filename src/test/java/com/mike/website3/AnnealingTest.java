package com.mike.website3;

import com.mike.util.Log;
import com.mike.website3.dataAnalysis.MilkRunCollection;
import com.mike.website3.db.Address;
import com.mike.website3.milkrun.MilkRun;
import com.mike.website3.milkrun.routing.Route;
import com.mike.website3.milkrun.routing.annealing.AnnealData;
import com.mike.website3.milkrun.routing.annealing.Annealer;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Created by mike on 7/23/2017.
 *
 *
 *
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class AnnealingTest {

    private static final String TAG = AnnealingTest.class.getSimpleName();

    @Test
    public void analysis1 () {
        runAnnealer("18-12-a");
    }

    private void runAnnealer(String milkRunName) {
        MilkRunDB milkRunDB = MilkRunDB.findByName(milkRunName);
        MilkRun milkRun = MilkRun.load(milkRunDB.getId());
        List<CartOffer> cartOffers = assembleCartOffers(milkRun);

        Random random = new Random(12793L);

        for(int j = 9; j < 10; ++j) {
            List<CartOffer> co = cartOffers.subList(0, (j + 1) * (cartOffers.size() / 10));

            // given the set of cart offers in a run setup and run the Annealer

            AnnealData annealData = new AnnealData(
                    milkRun.getStart().getAddress(Address.Usage.Pickup),
                    milkRun.getEnd().getAddress(Address.Usage.Delivery),
                    co,
                    random);

            Annealer annealer = new Annealer(annealData);

            for (int i = 0; i < 10; ++i) {
                Route route = annealer.anneal();
                Log.d(TAG, String.format("%5d, %5d, %.1f", co.size(), i, route.getMetrics().getLengthMeters() / 1000.0));

                annealData.setStops(route.getStops());
                annealData.setMetrics(route.getMetrics());
            }
        }

//        final double[] dist = {0};
//        cartOffers.forEach(cartOffer -> {
//            Address supplier = cartOffer.getSeller().getAddress(Address.Usage.Default);
//            Address consumer = cartOffer.getBuyer().getAddress(Address.Usage.Delivery);
//            double d = supplier.getLocation().distance(consumer.getLocation()) / 1000.0;
//            dist[0] += d;
//        });
//
//        Log.d(TAG, String.format("%s gross supplier-consumer distance %.0f km", ((MilkRun) milkRun).getName(), dist[0]));
//
//        Map<User, List<CartOffer>> bySeller = cartOffers.stream()
//                .collect(Collectors.groupingBy(cartOffer -> cartOffer.getSeller()));
//
//        Map<User, Map<User, List<CartOffer>>> bySellerByBuyer = new HashMap<>();
//        for (User seller : bySeller.keySet()) {
//            bySellerByBuyer.put(seller, bySeller.get(seller).stream()
//                    .collect(Collectors.groupingBy(cartOffer -> cartOffer.getBuyer())));
//        }
//
//        for (User seller : bySellerByBuyer.keySet()) {
//            StringBuilder sb = new StringBuilder();
//            String coName = seller.getCompanyName();
//            sb.append(String.format("%-20.20s, %d, ", coName, bySellerByBuyer.get(seller).keySet().size()));
//            Centroid centroid = new Centroid(seller, bySellerByBuyer.get(seller).keySet());
//
//            double cd = centroid.distance(seller.getAddress(Address.Usage.Default).getLocation()) / 1000.0;
//            sb.append(String.format("%.1f, ", cd));
//
//            sb.append(String.format("%.1f", centroid.radius() / 1000.0));
//            Log.d(TAG, sb.toString());
//        }

//        Log.d(TAG, String.format("", ))
    }

    protected List<CartOffer> assembleCartOffers(MilkRun milkRun) {
        MilkRunCollection collection = new MilkRunCollection(((MilkRun) milkRun).getMilkRunDB().getName());
        List<CartOffer> list = new ArrayList<>();
        collection.walk(new MilkRunCollection.walkFunc() {
            @Override
            public void visit(MilkRunDB milkRunDB, Object context) {
                ((List<CartOffer>) context).addAll(CartOffer.findByMilkRunId(milkRunDB.getId()));
            }
        }, list);

        return list;
    }

}

/*
 43,     9, 92.1
 86,     9, 110.5
129,     9, 108.8
172,     9, 109.6
215,     9, 114.4
258,     9, 114.6
301,     9, 173.1
344,     9, 178.1
387,     9, 219.2
430,     9, 213.0
*/