package com.mike.website3;

import com.mike.website3.db.User;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class UserActivity {

    private final User user;
    private final long joined;
    private double totalSpend;
    private long weeksSinceJoined;
    private final int numMilkRuns;

    private final double metric;

    // incoming map of MilkRunIds to CartOffers for this user
    //
    public UserActivity(User user) {
        this.user = user;
        this.joined = user.getJoinTimestamp().getTime();
        long now = MySystemState.getInstance().now();
        this.weeksSinceJoined = (now - joined) / (7 * 24 * 60 * 60 * 1000L);
        if (weeksSinceJoined < 1)
            weeksSinceJoined = 1;
        this.totalSpend = 0;

        List<CartOffer> cartOffers = CartOffer.findByUserId(user.getId());
        cartOffers.forEach(cartOffer -> totalSpend += cartOffer.getOurSellPrice());
        Map<String, List<CartOffer>> milkRunsToCartOffers = cartOffers.stream()
                .collect(Collectors.groupingBy(cartOffer -> cartOffer.getMilkRunId()));

        this.numMilkRuns = milkRunsToCartOffers.keySet().size();

        // the join date is funky early in history
        if (weeksSinceJoined < numMilkRuns)
            weeksSinceJoined = numMilkRuns;

        this.metric = (double) numMilkRuns / (double) weeksSinceJoined;
    }

    public double getMetric() {
        return metric;
    }
    public double getTotalSpend() {
        return totalSpend;
    }
    public double getAverageSpend() {
        return totalSpend / numMilkRuns;
    }
    public int getNumMilkRuns() {
        return numMilkRuns;
    }

    public User getUser() {
        return user;
    }

    public boolean hasValidMetric() {
        return weeksSinceJoined > 0;
    }
}
