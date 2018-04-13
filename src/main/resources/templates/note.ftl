<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <title>Note</title>
    <@styleSheets/>
    <style>
        select {
            width:300px;
        }

       .mine5 {
           width: 100%;
           height: 100%;
            padding: 0;
            margin: 0;
            text-align: left;
            vertical-align: top;
            font-size: 20px;
           rows: 4;
           cols: 200;
    }

    </style>

</head>
    <body class="">
    <header class="header">
        <@pageHeader3/>
    </header>

    <#assign note = session.getAttribute("noteEditor") >

    <div class="container">
        <div class = "row">
            <div class="col-md-3">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin</strong></a>
                <br>
                <a href="/notes"><strong>Back to Notes</strong></a>
                <#if session.getAttribute("noteEditor-returnTo")?? >
                    <br>
                    <a href="${session.getAttribute("noteEditor-returnTo")}"><strong>Back to...</strong></a>
                </#if>
            </div>
            <div class="col-md-5">
                <#if session.getAttributeS("noteEditorMode") == "edit" >
                    <h2>Edit Note</h2>
                    ${note.getId()}
                <#else>
                    <h2>Create Note</h2>
                </#if>
            </div>
            <div class="col-md-3">
            </div>
        </div>
        <div class = "row">
            <p>&nbsp;</p>
        </div>

        <div class = "row">
            <div class="col-md-2">

            </div>
            <div class="col-md-4">

            </div>
        </div>
            <div class = "row">
                <div class="col-md-2">
                    <strong>Date</strong>
                </div>
                <div class="col-md-4">
                    ${Util.formatTimestamp(note.getTimestamp(), "MMM dd YYYY hh:mm z")}
                </div>
            </div>
            <div class = "row">
                <div class="col-md-2">
                    <strong>User</strong>
                </div>
                <div class="col-md-4">
                    <select name="userId" onChange="userSelect(this.value)">
                        <option value="None" selected >None</option>

                        <#list Util.sortByUserName(User.findByEnabled(true)) as user>
                            <option value="${user.username}"
                                <#if user.username == note.getUserId() >
                                    selected
                                </#if>
                            >${user.name}</option>
                        </#list>
                    </select>
                </div>
            </div>
            <div class = "row">
                <div class="col-md-2">
                    <strong>Color</strong>
                </div>
                <div class="col-md-4">
                    <select name="colorName" onChange="colorSelect(this.value)"  style="background-color: #${UserNote.getColor(note)}">
                        <#list UserNote.getColorNames() as colorName >
                            <option value=${colorName} style="background-color: #${UserNote.colorOf(colorName)}"
                                <#if note.getColor().toString() == colorName >
                                    selected
                                </#if>
                            >${colorName}</option>
                        </#list>
                    </select>
                </div>
            </div>
            <div class = "row">
                <div class="col-md-2">
                    <strong>MilkRun</strong>
                </div>
                <div class="col-md-4">
                    <select name="milkRunId"  onChange="milkRunSelect(this.value)">
                        <option value="None"
                            <#if note.getMilkRunSeriesName() == "" >
                                    selected
                            </#if>
                        >None</option>
                        <#list MilkRunCollection.findSeriesNames() as seriesName >
                            <option value="${seriesName}"
                                <#if seriesName == note.getMilkRunSeriesName() >
                                    selected
                                </#if>
                            >
                            ${seriesName}
                        </#list>
                    </select>
                </div>
            </div>
        <#--
            <div class = "row">
                <div class="col-md-2">
                    <strong>CartOffer</strong>
                </div>
                <div class="col-md-4">
                    <select name="itemShortOne"  onChange="cartOfferSelect(this.value)">
                        <option value="None"
                        <#if note.getCartOfferIdAsId() == "" >
                                selected
                        </#if>
                        >None</option>
                    <#if note.getUserId() != "" >
                        <#list CartOffer.findByUserIdAndMilkRunIdOrderByTimeDesc(note.getUserId(), note.getMilkRunSeriesName()) as cartOffer >
                            <option value="${cartOffer.getTimeAsId()}"
                                <#if cartOffer.getTimeAsId() == note.getCartOfferIdAsId() >
                                    selected
                                </#if>
                            >${cartOffer.getItem().getSupplier().getCompanyName()}
                                &nbsp;
                            ${cartOffer.getItem().getShortOne()}</option>
                        </#list>
                    <#else>
                        <#if note.getMilkRunSeriesName() != "" >
                            <#list CartOffer.findByMilkRunId(note.getMilkRunSeriesName()) as cartOffer >
                                <option value="${cartOffer.getTimeAsId()}"
                                    <#if cartOffer.getTimeAsId() == note.getCartOfferIdAsId() >
                                        selected
                                    </#if>
                                >${cartOffer.getItem().getSupplier().getCompanyName()}
                                    &nbsp;
                                ${cartOffer.getItem().getShortOne()}</option>
                            </#list>
                        </#if>
                    </#if>
                    </select>
                <#if note.getCartOfferIdAsId() != "" >
                    <br>${Util.formatTimestamp(note.getCartOffer().getTime(), "MMM dd, YYYY")}
                    <br>${note.getCartOffer().getSeller().getCompanyName()}
                </#if>
                </div>
            </div>
        -->
            <div class = "row">
                <div class="col-md-2">
                    <strong>Status</strong>
                </div>
                <div class="col-md-4">
                    <select name="status" onChange="statusSelect(this.value)">
                        <#list UserNote.getStatusList() as s >
                            <option value="${s}"
                                <#if note.getStatusAsString() == s >
                                    selected
                                </#if>
                            >${s}
                            </option>
                        </#list>
                    </select>
                </div>
            </div>
            <div class = "row">
                <p></p>
                <div class="col-md-1">
                </div>
                <div class="col-md-5 well">
                    <strong>Note</strong>
                    <br>
                    <textarea class="mine5"
                              type=""
                              style="height: 200px; background-color: #${UserNote.getColor(note.getColor())}"
                              id="body"
                              onchange="bodyChanged(this.value)">${note.getBody()}</textarea>
                </div>
                <div class="col-md-1">
                </div>
                <div class="col-md-5 well">
                    <#--<strong>Note Rendered</strong>-->
                    <#--<br>-->
                    <#--<textarea class="mine5"-->
                              <#--type=""-->
                              <#--style="height: 200px"-->
                              <#--id="body"-->
                              <#--onchange="bodyChanged(this.value)">${note.getBody()}</textarea>-->
                </div>
            </div>
            <div class = "row">
                <div class="col-md-2">
                    <button onclick="saveButton()">Save</button>
                </div>
                <p>&nbsp;</p>
            </div>
    </div>


    <@pageFooter/>
    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>
    <@jsIncludes/>

    <script>
    function bodyChanged(s) {
        location.assign("/note/update?body=" + encodeURIComponent(s));
    }
    function statusSelect(s) {
        location.assign("/note/update?status=" + s);
    }
    function cartOfferSelect(s) {
        location.assign("/note/update?cartOfferId=" + s);
    }
    function milkRunSelect(s) {
        location.assign("/note/update?milkRunSeriesName=" + s);
    }
    function userSelect(s) {
        location.assign("/note/update?userId=" + s);
    }
    function colorSelect(s) {
        location.assign("/note/update?color=" + s);
    }

    function saveButton() {
        location.assign("/note/save");
    }

    </script>

    </body>
</html>