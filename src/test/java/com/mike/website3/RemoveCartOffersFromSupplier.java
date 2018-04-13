package com.mike.website3;

import com.mike.website3.dataAnalysis.MilkRunCollection;
import com.mike.website3.milkrun.MilkRun;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mike on 7/23/2017.
 *
 *
 *
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class RemoveCartOffersFromSupplier {

    private static final String TAG = RemoveCartOffersFromSupplier.class.getSimpleName();


    @Test
    public void analysis1 () {
        clean("18-12-a", "94baee96-e5c7-4907-8dc6-0fba9f4e93e0");
    }

    // drop all cartoffers not from the given supplier

    private void clean(String milkRunName, String supplier) {
        MilkRunDB milkRunDB = MilkRunDB.findByName(milkRunName);
        MilkRun milkRun = MilkRun.load(milkRunDB.getId());
        List<CartOffer> cartOffers = assembleCartOffers(milkRun);

        cartOffers.forEach(cartOffer -> {
            if ( ! cartOffer.getSeller().getId().equals(supplier)) {
                cartOffer.delete();
            }
        });

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

18-11-a gross supplier-consumer distance 13244 km
Bob's Red Mill      , 4, 5.0, 8.9
Lion Heart Kombucha , 8, 29.6, 9.8
Garage Coffee       , 2, 30.5, 6.0
Simington Gardens   , 20, 25.3, 14.2
Mustard Seed Farms  , 38, 30.3, 15.3
Wyld Bread          , 7, 28.0, 5.6
Garden Bar          , 10, 5.5, 14.0
Sandino Coffee Roast, 2, 12.2, 7.1
Kaah Market         , 13, 12.8, 14.3
Rucksack Roasting Co, 3, 28.6, 5.5
Cascade Organic     , 47, 11.0, 15.0
Hab Sauce           , 2, 7.7, 4.0
Hot Mama Salsa      , 1, 35.2, 0.0
Tracy's Small Batch , 3, 7.4, 2.5
Honey Mama's        , 7, 15.5, 9.6
Gathering Together F, 28, 117.0, 15.3
Bowery Bagels       , 11, 4.4, 10.0
TMK Creamery        , 4, 16.1, 3.4
MilkCreek Produce   , 49, 30.0, 14.9
Wet Wizard Sauce    , 1, 36.0, 0.0
Kelly's Jelly       , 1, 16.9, 0.0
Three Sisters Nixtam, 6, 29.8, 9.3
Pok Pok Som         , 1, 35.0, 0.0
KURE Juice Bar      , 4, 24.6, 9.9
Tabor Bread         , 14, 6.2, 7.9
Fishpeople          , 1, 9.1, 0.0
Bliss Nut Butters   , 4, 22.4, 4.7
Esotico Pasta       , 1, 20.9, 0.0
Grano Bakery        , 6, 14.2, 10.5
Umi Organic         , 12, 4.6, 10.9
Birkeland Farm      , 1, 29.2, 0.0
MilkRun             , 1, 19.1, 0.0
Chicken Scratch Farm, 21, 31.0, 10.9
Revel Ranch         , 2, 35.7, 3.9
Revel Meat Co       , 43, 24.6, 15.5
TMK Meat Co.        , 1, 34.2, 0.0
Garrys Meadow Fresh , 35, 31.4, 12.6
Briar Rose Creamery , 2, 44.3, 2.4
Deck Family Farm    , 11, 28.1, 13.5
San Juan Island Sea , 2, 35.8, 0.8
Starvation Alley    , 1, 152.8, 0.0
 */