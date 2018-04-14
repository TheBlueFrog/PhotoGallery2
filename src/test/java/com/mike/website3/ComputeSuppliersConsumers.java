package com.mike.website3;

import com.mike.util.Log;
import com.mike.website3.dataAnalysis.MilkRunCollection;
import com.mike.website3.db.User;
import com.mike.website3.milkrun.MilkRun;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Created by mike on 7/23/2017.
 *
 *
 *
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class ComputeSuppliersConsumers {

    private static final String TAG = ComputeSuppliersConsumers.class.getSimpleName();

    @Test
    public void analysis1 () {
        dumpSuppliers("18-11-a");
    }

    private void dumpSuppliers(String milkRunName) {
        MilkRunDB milkRunDB = MilkRunDB.findByName(milkRunName);
        MilkRun milkRun = MilkRun.load(milkRunDB.getId());
        List<CartOffer> cartOffers = assembleCartOffers(milkRun);

        final double[] dist = {0};
        cartOffers.forEach(cartOffer -> {
            Address supplier = cartOffer.getSeller().getAddress(Address.Usage.Default);
            Address consumer = cartOffer.getBuyer().getAddress(Address.Usage.Delivery);
            double d = supplier.getLocation().distance(consumer.getLocation()) / 1000.0;
            dist[0] += d;
        });

        Log.d(TAG, String.format("%s gross supplier-consumer distance %.0f km", ((MilkRun) milkRun).getName(), dist[0]));

        Map<User, List<CartOffer>> bySeller = cartOffers.stream()
                .collect(Collectors.groupingBy(cartOffer -> cartOffer.getSeller()));

        Map<User, Map<User, List<CartOffer>>> bySellerByBuyer = new HashMap<>();
        for (User seller : bySeller.keySet()) {
            bySellerByBuyer.put(seller, bySeller.get(seller).stream()
                    .collect(Collectors.groupingBy(cartOffer -> cartOffer.getBuyer())));
        }

        for (User seller : bySellerByBuyer.keySet()) {
            StringBuilder sb = new StringBuilder();
            String coName = seller.getCompanyName();
            sb.append(String.format("%-20.20s, %d, ", coName, bySellerByBuyer.get(seller).keySet().size()));
            Centroid centroid = new Centroid(seller, bySellerByBuyer.get(seller).keySet());

            double cd = centroid.distance(seller.getAddress(Address.Usage.Default).getLocation()) / 1000.0;
            sb.append(String.format("%.1f, ", cd));

            sb.append(String.format("%.1f", centroid.radius() / 1000.0));
            Log.d(TAG, sb.toString());
        }

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

18-11-a gross supplier-consumer distance 542316 km
Bob's Red Mill      , 4, 5.0, 8.9
Lion Heart Kombucha , 6, 29.6, 9.8
Garage Coffee       , 2, 30.5, 6.0
Simington Gardens   , 19, 25.3, 14.2
Mustard Seed Farms  , 30, 30.3, 15.3
Wyld Bread          , 5, 28.0, 5.6
Garden Bar          , 10, 5.5, 14.0
Sandino Coffee Roast, 2, 12.2, 7.1
Kaah Market         , 12, 12.8, 14.3
Rucksack Roasting Co, 3, 28.6, 5.5
Cascade Organic     , 26, 11.0, 15.0
Hab Sauce           , 2, 7.7, 4.0
Hot Mama Salsa      , 1, 35.2, 0.0
Tracy's Small Batch , 3, 7.4, 2.5
Honey Mama's        , 4, 15.5, 9.6
Gathering Together F, 22, 117.0, 15.3
Bowery Bagels       , 8, 4.4, 10.0
TMK Creamery        , 3, 16.1, 3.4
MilkCreek Produce   , 26, 40.0, 14.9
Wet Wizard Sauce    , 1, 36.0, 0.0
Kelly's Jelly       , 1, 16.9, 0.0
Three Sisters Nixtam, 6, 29.8, 9.3
Pok Pok Som         , 1, 35.0, 0.0
KURE Juice Bar      , 4, 24.6, 9.9
Tabor Bread         , 12, 6.2, 7.9
Fishpeople          , 1, 9.1, 0.0
Bliss Nut Butters   , 3, 22.4, 4.7
Esotico Pasta       , 1, 20.9, 0.0
Grano Bakery        , 6, 14.2, 10.5
Umi Organic         , 9, 4.6, 10.9
Birkeland Farm      , 1, 29.2, 0.0
MilkRun             , 1, 19.1, 0.0
Chicken Scratch Farm, 21, 31.0, 10.9
Revel Ranch         , 2, 35.7, 3.9
Revel Meat Co       , 23, 24.6, 15.5
TMK Meat Co.        , 1, 34.2, 0.0
Garrys Meadow Fresh , 24, 31.4, 12.6
Briar Rose Creamery , 2, 44.3, 2.4
Deck Family Farm    , 10, 28.1, 13.5
San Juan Island Sea , 2, 35.8, 0.8
Starvation Alley    , 1, 152.8, 0.0
*/