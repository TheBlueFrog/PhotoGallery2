package com.mike.website3;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import static org.hamcrest.MatcherAssert.assertThat;

/**
 * Created by mike on 7/23/2017.
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class TestItem {

    private static final String TAG = TestItem.class.getSimpleName();

    @Test
    public void test_doubleSingleQuote () {
        Item.findAll().forEach(item -> {
            assertThat("found item identification with multiple single quote", ! item.getIdentification().contains("''"));
            assertThat("found item shortOne with multiple single quote", ! item.getShortOne().contains("''"));
            assertThat("found item shortTwo with multiple single quote", ! item.getShortTwo().contains("''"));
//            assertThat("found item description with multiple single quotes", ! item.getDescription().contains("''"));
            assertThat("found item note with multiple single quote", ! item.getNote().contains("''"));
        });

    }

}

