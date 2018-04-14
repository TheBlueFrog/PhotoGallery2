package com.mike.website3;

import com.mike.util.Log;
import com.mike.website3.db.EmailAddress;
import com.mike.website3.db.User;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.*;
import java.util.stream.Collectors;

import static org.hamcrest.MatcherAssert.assertThat;

/**
 * Created by mike on 7/23/2017.
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class TestLoginNames {

    private static final String TAG = TestLoginNames.class.getSimpleName();

    @Test
    public void test_LookForDuplicateLoginsPerUser () {
        User.findAll().forEach(user -> {
            List<LoginName> x = LoginName.findAllByUserId(user.getId());
            Set<String> names = new HashSet<>();
            x.forEach(loginName -> {
                if ( ! names.add(loginName.getLoginName()))
                    Log.d("", String.format("Duplicate login %s for %s", loginName.getLoginName(), user.getId(),
                        names.add(loginName.getLoginName())));
            });
        });
    }

    @Test
    public void test_OverusedEmails () {
        Map<String, List<EmailAddress>> map = EmailAddress.findAll().stream()
                .collect(Collectors.groupingBy(email -> email.getEmail()));

        List<String> overused = map.keySet().stream()
                .filter(email -> map.get(email).size() > 1)
                .collect(Collectors.toList());

        overused.forEach(email -> {
            map.get(email).forEach(emailAddress -> {
                User u = User.findById(emailAddress.getUserId());
                if (u.getEnabled()) {
                    Log.d(TAG, String.format("%s %s %s",
                            email,
                            u.getName(),
                            emailAddress.getUserId()));
                }
            });
        });
    }

/*
evangregoirepdx@gmail.com Portland Seedhouse Portland_Seedhouse
evangregoirepdx@gmail.com Stargazer Farm Stargazer_Farm
ricksteffenfarm@gmail.com Rick Steffan inactive Rick__Steffen_Farm
ricksteffenfarm@gmail.com Rick Steffen Farm Rick_Steffen_Farm
danielle.erin.lohr@gmail.com Danielle Lohr 471d7c8b-f66b-43e9-a893-be0eabc35037
danielle.erin.lohr@gmail.com Daniell Lohr 4ea15e27-729e-46db-9361-98c7923d3a86
l@a.com Liam Collins liam
l@a.com Liam Collins Liam
steelchris23@gmail.com Christopher Steel steelchris23
steelchris23@gmail.com Chris Steel Chris_Steel
mike.d.collins@gmail.com Mike Collins mike
mike.d.collins@gmail.com Mike Collins mikey
lamathubten@gmail.com Thubten Comerford Thubten_Comerford
lamathubten@gmail.com Thubten Comerford thubten
eaters@localmilkrun.com by Ben Meyer of Old Salt Marketplace Chef_Kit
eaters@localmilkrun.com Kara Pratt 8cd2102c-0c4a-422c-8a8f-1edccbdc0cc3
eaters@localmilkrun.com MilkRun Team 2dc94634-f7d7-4a8e-9443-1876df228074
amye@msamye.com Amye Scavarda 7f5d4f1d-c29e-4cf0-ad1f-1686e1350667
amye@msamye.com Amye Scavarda 7c6cfa9c-ae14-4bf0-a3ba-4d0ec3f7e52a
john.cohoon@gmail.com John Cohoon be416353-d359-4fa8-9fbd-aee62c427360
john.cohoon@gmail.com john cohoon 2d7e758a-b9a8-4ebb-ad26-64dfc558f170
caldwellfamilyfarm@ymail.com Kiyokawa Orchard Kiyokawa_Orchard
caldwellfamilyfarm@ymail.com Mary Hill Farm e979e219-fc6e-47f9-af8d-3a499f7f2780

 */
//


//    email             | count
//------------------------------+-------
//    eaters@localmilkrun.com      |     3
//    l@a.com                      |     2
//    caldwellfamilyfarm@ymail.com |     2
//    steelchris23@gmail.com       |     2
//    lamathubten@gmail.com        |     2
//    evangregoirepdx@gmail.com    |     2
//    mike.d.collins@gmail.com     |     2
//    john.cohoon@gmail.com        |     2
//    ricksteffenfarm@gmail.com    |     2
//    danielle.erin.lohr@gmail.com |     2
//    amye@msamye.com              |     2
//            (11 rows)

}

