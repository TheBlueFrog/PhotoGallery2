<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>${session.user.address.firstName}'s Home</title>
    <@styleSheets/>
    <style>
        .calendarCell {
            background-color: 	#f6f6f6;
        }
        .calendarCellToday {
            background-color: 	#FFE6FA;
        }
        .calDate {
            text-align: center;
            color: black;
        }
        .calDelivered {
            text-align: left;
        }

        table {
            table-layout: fixed;
            width: 100%;
            border: 0px solid grey;
        }

        td {
            text-align: center;
            border: 1px solid grey;
            height: 80px;
        }
        th {
            text-align: center;
            border: 0px solid grey;
            height: 20px;
        }

    </style>
</head>
<body class="">
    <header class="header">
        <@topOfPageHeader/>
    </header>

    <div class="col-sm-12 col-md-12 col-lg-12">
        <div class="row">
            <div class="col-sm-4 col-md-4 col-lg-4"></div>
            <div class="col-sm-4 col-md-4 col-lg-4">
                <h2>${session.user.username}'s Orders</h2>
            </div>
            <div class="col-sm-4 col-md-4 col-lg-4"></div>
        </div>
    </div>

    <div class="maincontainer">
        <div class="col-sm-1 col-md-1 col-lg-1">
            <form method="post">
                <input type="hidden" name="operation" value="back" />
                <button type="submit" value="back">Back</button>
            </form>
            <br>
            <form method="post">
                <input type="hidden" name="operation" value="forward" />
                <button type="submit" value="forward">Forward</button>
            </form>
        </div>
        <div class="col-sm-10 col-md-10 col-lg-10">
            <table>
                <tr><!-- 100% / 7 = 14% -->
                    <th width="15%">Sunday</th>
                    <th width="14%">Monday</th>
                    <th width="14%">Tuesday</th>
                    <th width="14%">Wednesday</th>
                    <th width="14%">Thursday</th>
                    <th width="14%">Friday</th>
                    <th width="15%">Saturday</th>
                </tr>
                <#list 1..5 as week >
                    <tr>
                        <#list 1..7 as day>
                            <#if session.calendar.isToday(week day) >
                                <td class="calendarCellToday">
                            <#else>
                                <td class="calendarCell">
                            </#if>
                                    <p class="calDate" >${session.calendar.getDate(week day)}</p>
                                    <br>
                                    <#if session.calendar.hasEvents(week day) >
                                        <div class="search-panel calendarCell">
                                            <a class="icon" href="#">Cart</a>
                                            <div class="mini-cart-content">
                                                <#list session.calendar.getNews(week day) as news >
                                                    <li><a href="${news.poster.publicHomePageURL}?newsId=${news.id}">
                                                        ${news.title}</a>
                                                    </li>
                                                </#list>

                                                <#if session.calendar.hasDelivered(week day) >
                                                    <li><a href="delivered-cart?date=${session.calendar.getDateLong(week day)}">
                                                        Past deliveries</a></li>
                                                </#if>

                                                <#if session.calendar.hasFutureOrders(week day) >
                                                    <li><a href="future-cart?date=${session.calendar.getDateLong(week day)}&days=7">
                                                        Future orders</a></li>
                                                </#if>
                                            </div>
                                        </div>
                                    <#else>
                                        <p></p>
                                        <p></p>
                                    </#if>
                                </td>
                        </#list>
                    </tr>
                </#list>
            </table>
        </div>
        <div class="col-sm-1 col-md-1 col-lg-1"></div>
    </div>

    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>


