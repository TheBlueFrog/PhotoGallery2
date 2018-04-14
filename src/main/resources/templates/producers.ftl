<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>PNW Producers | The Collective</title>
    <@styleSheets/>
</head>
<body class="">
    <@pageHeader "producers.ftl"/>
    <section class="banner banner-fortfolio bg-parallax">
        <div class="overlay"></div>
        <div class="container">
            <div class="banner-content text-center">
                <h2 class="page-title">Meet The Collective</h2>
                <div class="breadcrumbs">
                    <a href="${system.site.indexPage}">Home</a>
                    <span>Local Producers</span>
                </div>
            </div>
        </div>
    </section>
    <!-- Section portfolio -->
    <div class="section-portfolio">
        <div class="container">
            <div class="portfolio-nav">
                <a class="active" data-filter="*" href="#">all</a>
                <a data-filter=".farmers" href="#">FARMERS</a>
                <a data-filter=".butchers" href="#">BUTCHERS</a>
                <a data-filter=".bakers" href="#">BAKERS</a>
                <a data-filter=".makers" href="#">MAKERS</a>
                <a data-filter=".chefs"  href="#">CHEFS</a>
            </div>
            <div class="portfolios portfolio-columns columms-3" data-layoutmode="packery" data-gutter="0" >

                <!-- this list has to include all of the above mentioned User roles -->
                <#list system.getUsersByRoles("Seeder Butcher Baker Maker Feeder") as user >

                    <!-- this has to create a div with the right kind of class as in the above data-filter list for each role
                    -->
                    <#if user.doesRole("Seeder") >
                        <div class="portfolio grid farmers">
                    <#elseif user.doesRole("Butcher") >
                        <div class="portfolio grid butchers">
                    <#elseif user.doesRole("Baker") >
                        <div class="portfolio grid bakers">
                    <#elseif user.doesRole("Maker") >
                        <div class="portfolio grid makers">
                    <#else>
                        <div class="portfolio grid chefs">
                    </#if>

                            <!-- now fill in the body of the div -->
                            <#if user.mainImage?? >
                                <a href="#"><img src="${user.mainImage.path}" alt="" /></a>
                            </#if>
                            <div class="portfolio-info">
                                <!-- this seems redundant <h3 class="portfoli-title"><a href="#">${user.companyName}</a></h3>-->
                                <div class="portfolio-cat">
                                    <a href="${user.publicHomePageURL}">${user.companyName}</a>
                                </div>
                            </div>
                        </div>  <!-- this div matches the one in the if above, careful -->
                </#list>
            </div>

                <!--<div class="portfolio grid bakers">-->
                    <!--<a href="#"><img src="/images/portfolios/portfolio3.jpg" alt="" /></a>-->
                    <!--<div class="portfolio-info">-->
                        <!--<h3 class="portfoli-title"><a href="#">Bakers</a></h3>-->
                        <!--<div class="portfolio-cat">-->
                            <!--<a href="#">Bakers</a>-->
                        <!--</div>-->
                    <!--</div>-->
                <!--</div>-->
        </div>
    </div>
    <!-- ./Section portfolio -->
    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>
</body>
</html>