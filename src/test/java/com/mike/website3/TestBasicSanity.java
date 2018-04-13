package com.mike.website3;

import com.mike.website3.db.*;
import com.mike.website3.tools.GetCPULoad;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.List;

import static org.hamcrest.CoreMatchers.instanceOf;
import static org.hamcrest.MatcherAssert.assertThat;

/**
 * Created by mike on 7/23/2017.
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class TestBasicSanity {

    private static final String TAG = TestBasicSanity.class.getSimpleName();

    @Test
    public void test_checkRolesOfUserMike () {
        User mike = User.findByUsername("mike");
        assertThat("is admin", mike.doesRole2(UserRole.Role.Admin));
    }

    @Test
    public void test_findAndAccessUserMike () {
        User mike = User.findByUsername("mike");
        assertThat(mike, instanceOf(User.class));
        assertThat(mike.getAddress(), instanceOf(Address.class));
        assertThat("City is right", mike.getAddress().getCity().equals("Portland"));
    }

    @Test
    public void test_getCartOffersOfUserMike () {
        User mike = User.findByUsername("mike");
        assertThat("has delivered CartOffers", CartOffer.findAllDeliveredTo(mike).size() > 0);
    }

    @Test
    public void test_getMilkRuns () {

        List<MilkRunDB> v3roots = MilkRunDB.findByParentMilkRunIdOrderByTimestampDesc("");
        List<MilkRunDB> v2roots = MilkRunDB.findAllByVersionOrderByTimestampAsc("2");

        assertThat("has V2 MilkRuns", v2roots.size() > 0);
        assertThat("has V3 MilkRuns", v3roots.size() > 0);
    }

    @Test
    public void test_getCPULoad() {
        List<String> a = GetCPULoad.snap("hi");
        assertThat("output starts with tag", a.get(0).startsWith("hi"));
        if (GetCPULoad.isWindows)
            assertThat("output starts with tag", a.get(1).startsWith("Not Supported"));
    }

//    @Test
//    public void test_notifyAdminOfNewPendingUser() {
//        User mike = User.findByUsername("mike");
//
//        int queued = OutgoingEmail.findByStatus(OutgoingEmail.Status.Pending).size();
//        int numAdmins = UserRole.findByRole(UserRole.Role.UserAdmin).size();
//
//        User.notifyAdminsOfNewPendingUser(mike);
//
//        assertThat(
//                "added one outgoing email for each admin",
//                OutgoingEmail.findByStatus(OutgoingEmail.Status.Pending).size() == (queued + numAdmins));
//    }

    /*
    sanity
        iterate stops of run


    functional
        create user

        login
        logout
        add to cart
        remove from cart
        close the open run
        add extra stop
        remove extra stop
        split the closed run
        make it delivered


        reset a login
        clear the reset

 */
}

