package com.mike.website3;

import com.mike.util.Log;
import com.mike.website3.dataAnalysis.MilkRunCollection;
import com.mike.website3.milkrun.MilkRun;
import com.mike.website3.milkrun.MilkRunMem;
import com.mike.website3.milkrun.NameWrapper;
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
public class TestBasicMilkRun {

    private static final String TAG = TestBasicMilkRun.class.getSimpleName();

    @Test
    public void test_a () {
        List<MilkRunDB> x = MilkRunDB.findAllOrderByTimestampDesc().stream()
                .filter(milkRunDB -> milkRunDB.getState().equals(MilkRunMem.State.Delivered))
                .filter(milkRunDB -> milkRunDB.getParentMilkRunId() != "")  // remove roots
                .collect(Collectors.toList());

        assertThat ("should have at least one", x.size() > 0);
    }

    @Test
    public void test_b () {
        // check that all CartOffers are in exactly one, pretty much impossible to fail
        MilkRunCollection all = new MilkRunCollection(MilkRunCollection.Predefined.All);
        List<Timestamp> allTimestamps = new ArrayList<>();
        all.walk(new MilkRunCollection.walkFunc() {
            @Override
            public void visit(MilkRunDB milkRunDB, Object context) {
                List<Timestamp> timestamps = (List<Timestamp>) context;
                MilkRun m = new MilkRun(milkRunDB);
                m.getCartOffers().forEach(cartOffer -> {
                    assertThat("CartOffer in more than one MilkRun", ! timestamps.contains(cartOffer.getTimestamp()));
                    timestamps.add(cartOffer.getTimestamp());
                });
            }
        }, allTimestamps);
    }

    @Test
    public void test_c () {
        // check that the hierarchy defined by MilkRun names matches the
        // parent_milkrun_id
        MilkRunCollection all = new MilkRunCollection(MilkRunCollection.Predefined.All);
        List<String> names = new ArrayList<>();
        all.walk(new MilkRunCollection.walkFunc() {
            @Override
            public void visit(MilkRunDB milkRunDB, Object context) {
                List<String> names = (List<String>) context;
                assertThat("Duplicate Milkrun name ", ! names.contains(milkRunDB.getName()));
                names.add(milkRunDB.getName());

                NameWrapper nameWrapper = milkRunDB.getNameWrapper();

                String parentId = milkRunDB.getParentMilkRunId();
                if ( ! parentId.equals("")) {
                    MilkRunDB parent = MilkRunDB.findById(parentId);
                    NameWrapper parentNameWrapper = parent.getNameWrapper();

                    assertThat(String.format("%s does not start with %s",
                            nameWrapper.getName(), parentNameWrapper.getName()),
                            nameWrapper.getName().startsWith(parentNameWrapper.getName()));
                    assertThat(String.format("Series name %s does not match parent series name %s",
                            nameWrapper.getSeriesName(), parentNameWrapper.getSeriesName()),
                            nameWrapper.getSeriesName().equals(parentNameWrapper.getSeriesName()));
                }
                else {
                    if ( ! milkRunDB.getName().startsWith(milkRunDB.getSeriesName())) {
                        Log.d(TAG, String.format("getName() %s of a root run doesn't start with getSeriesName() %s",
                                milkRunDB.getName(), milkRunDB.getSeriesName()));
                    }
                }

            }
        }, names);

    }

}

