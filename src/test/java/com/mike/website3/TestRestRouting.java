package com.mike.website3;

import com.mike.website3.RestApi.json.Route;
import com.mike.website3.milkrun.MilkRun;
import com.mike.website3.milkrun.RouteErrors;
import com.mike.website3.milkrun.routing.annealing.AnnealData;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.mock.http.MockHttpOutputMessage;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.web.context.WebApplicationContext;

import java.io.IOException;
import java.nio.charset.Charset;
import java.util.Arrays;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertNotNull;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.webAppContextSetup;

/**
 * Created by mike on 7/23/2017.
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Website.class)
@WebAppConfiguration
public class TestRestRouting {

    private static final String TAG = TestRestRouting.class.getSimpleName();

/*
    @Test
    public void test_a () {

        // put a known set of cartoffers in the open run,
        // add extra stop A
        // transition to Closing
        // transition to Unrouted
        // add extra stop B
        // transition to Routed
        // get route via REST
        // check it

        MilkRunDB milkRunDB = MilkRunDB.findOpen();
        MilkRun milkRun = MilkRun.load(milkRunDB.getId());


    }
*/

    private MediaType contentType = new MediaType(MediaType.APPLICATION_JSON.getType(),
            MediaType.APPLICATION_JSON.getSubtype(),
            Charset.forName("utf8"));

    private MockMvc mockMvc;

    private HttpMessageConverter mappingJackson2HttpMessageConverter;

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    void setConverters(HttpMessageConverter<?>[] converters) {

        this.mappingJackson2HttpMessageConverter = Arrays.asList(converters).stream()
                .filter(hmc -> hmc instanceof MappingJackson2HttpMessageConverter)
                .findAny()
                .orElse(null);

        assertNotNull("the JSON message converter must not be null",
                this.mappingJackson2HttpMessageConverter);
    }

    @Before
    public void setup() throws Exception {
        this.mockMvc = webAppContextSetup(webApplicationContext).build();

//        this.bookmarkRepository.deleteAllInBatch();
//        this.accountRepository.deleteAllInBatch();
//
//        this.account = accountRepository.save(new Account(userName, "password"));
//        this.bookmarkList.add(bookmarkRepository.save(new Bookmark(account, "http://bookmark.com/1/" + userName, "A description")));
//        this.bookmarkList.add(bookmarkRepository.save(new Bookmark(account, "http://bookmark.com/2/" + userName, "A description")));
    }

//    @Test
//    public void userNotFound() throws Exception {
//        mockMvc.perform(post("/george/bookmarks/")
//                .content(this.json(new UserNote("")))
//                .contentType(contentType))
//                .andExpect(status().isNotFound());
//    }

    private Route route = null;

    @Test
    public void routeExists() throws Exception {
        String milkRunName = "18-08-a-1";
        MvcResult result = mockMvc.perform(get("/milkrun-api/route/get?milkRunName=" + milkRunName))
                .andExpect(status().isOk())
                .andExpect(content().contentType(contentType))
                .andExpect(jsonPath("$.milkRunName", is(milkRunName)))
//                .andExpect(jsonPath("$.stops", hasSize(30)))
//                .andExpect(jsonPath("$.stops[0].action", is("Pickup")))
                .andReturn()
        ;
        String content = result.getResponse().getContentAsString();
        JSONTokener parser = new JSONTokener(content);
        Route route = new Route((JSONObject) parser.nextValue());

        assertThat("REST encoding of route is correct", verifyEncodingOfRoute(milkRunName, route));
        assertThat("REST route matches database", verifyCorrectnessOfRoute(milkRunName, route));
    }

    // this verifies that the JSON encoding by the REST api is correct
    // by fishing the run out of the database and comparing
    private boolean verifyEncodingOfRoute(String milkRunName, Route restRoute) {
        MilkRun milkRun = MilkRun.load(MilkRunDB.findByName(milkRunName).getId());
        AnnealData routeData = milkRun.getRouteData();
        for(int i = 0; i < restRoute.getStops().size(); ++i) {
            assertThat("Stop action matches",
                    restRoute.getStops().get(i).getAction().equals(
                        routeData.getStops().get(i).getAction().toString()));
            assertThat("Stop street address matches",
                    restRoute.getStops().get(i).getAddress().getStreetAddress().equals(
                            routeData.getStops().get(i).getAddress().getStreetAddress()));
        }
        return true;
    }

    // this verifies that the route gotten from the REST api is
    // operationally correct, e.g. is a good route
    private boolean verifyCorrectnessOfRoute(String milkRunName, Route restRoute) {

        MilkRun milkRun = MilkRun.load(MilkRunDB.findByName(milkRunName).getId());
        AnnealData routeData = milkRun.getRouteData();

        routeData.verify(milkRun.getId());
        RouteErrors errors = routeData.getRouteErrors();

        // compare errors

        return true;
    }

    protected String json(Object o) throws IOException {
        MockHttpOutputMessage mockHttpOutputMessage = new MockHttpOutputMessage();
        this.mappingJackson2HttpMessageConverter.write(
                o, MediaType.APPLICATION_JSON, mockHttpOutputMessage);
        return mockHttpOutputMessage.getBodyAsString();
    }
}
