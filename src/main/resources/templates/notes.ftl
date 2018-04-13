<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">

<#assign showClosedNotes = true >
<#if session.getAttribute("showClosedNotes")?? >
    <#assign showClosedNotes = session.getAttribute("showClosedNotes") >
</#if>

<#assign milkRunSeriesNameSelector = "Any" >
<#if session.getAttribute("milkRunSeriesNameSelector")?? >
    <#assign milkRunSeriesNameSelector = session.getAttribute("milkRunSeriesNameSelector") >
</#if>

<#assign userIdSelector = "Any" >
<#if session.getAttribute("userIdSelector")?? >
    <#assign userIdSelector = session.getAttribute("userIdSelector") >
</#if>

<#assign colorSelector = "Any" >
<#if session.getAttribute("colorSelector")?? >
    <#assign colorSelector = session.getAttribute("colorSelector") >
</#if>

<#macro showCheck note >
    <#if note.getStatus().toString() == "Open" >
        <input type="button" class="btn btn-sm" value="C" />
    </#if>
</#macro>

<#macro showAddress note >
    <#if note.getUserId() != "" >
        <#assign address = Address.findNewestByUserIdAndUsageS(note.getUserId(), "Default") >
        <span class="cell" >${address.getLastName()}, ${address.getFirstName()}</span>
    </#if>
</#macro>

<#macro showTime note>
    <span class="cell" >${Util.formatTimestamp(note.getTimestamp(), "MM/dd/YY hh:mm z")}</span>
</#macro>

<#macro showMilkRun note >
    <#if note.getMilkRunSeriesName() != "" >
        <a href="/milkrun/show2/${note.getMilkRunSeriesName()}">
            <span class="cell" style="font-size: 10pt">
                ${note.getMilkRunSeriesName()}
            </span>
        </a>
    </#if>
</#macro>


<#macro byTime>
<div class="row">
    <div class="col-md-2"><strong>Time</strong></div>
    <div class="col-md-2"><strong>User</strong></div>
    <#if showClosedNotes >
        <div class="col-md-1"><strong>Status</strong></div>
    </#if>
    <div class="col-md-4"><strong>Note</strong></div>
    <div class="col-md-3"><strong>MilkRun</strong></div>
    <#--<div class="col-md-1"><strong>Offer</strong></div>-->
</div>
    <#list UserNote.findSome2(showClosedNotes, milkRunSeriesNameSelector, userIdSelector, colorSelector) as note >
        <a href="/note/edit?id=${note.getId()}">
            <div class="row">
                <#--<div class="col-md-1">                  <@showCheck note />           </div>-->
                <div class="col-md-2" >                  <@showTime note />            </div>
                <div class="col-md-2">                  <@showAddress note />         </div>
                <#if showClosedNotes >
                    <div class="col-md-1">              ${note.getStatus()}           </div>
                </#if>
                <div class="col-md-4" style="background-color: #${UserNote.getColor(note)}" >     ${note.getBody()}             </div>
                <div class="col-md-3">                  <@showMilkRun note />         </div>
                <#--<div class="col-md-1">                  <@showCartOffer note />       </div>-->
            </div>
        </a>
    </#list>
</#macro>

<#macro byUser>
<div class="row">
    <div class="col-md-2"><strong>User</strong></div>
    <div class="col-md-2"><strong>Time</strong></div>
    <#if showClosedNotes >
        <div class="col-md-1"><strong>Status</strong></div>
    </#if>
    <div class="col-md-4"><strong>Note</strong></div>
    <div class="col-md-3"><strong>MilkRun</strong></div>
    <#--<div class="col-md-1"><strong>Offer</strong></div>-->
</div>
    <#list Util.sortNotesByUserName(UserNote.findSome2(showClosedNotes, milkRunSeriesNameSelector, userIdSelector, colorSelector)) as note >
        <a href="/note/edit?id=${note.getId()}">
            <div class="row">
                <#--<div class="col-md-1">                  <@showCheck note />           </div>-->
                <div class="col-md-2">                  <@showAddress note />            </div>
                <div class="col-md-2">                  <@showTime note />               </div>
                <#if showClosedNotes >
                    <div class="col-md-1">              ${note.getStatus()}              </div>
                </#if>
                <div class="col-md-4" style="background-color: #${UserNote.getColor(note)}" >     ${note.getBody()}                </div>
                <div class="col-md-3">                  <@showMilkRun note />            </div>
                <#--<div class="col-md-1">                  <@showCartOffer note />          </div>-->
            </div>
        </a>
    </#list>
</#macro>

<#macro byColor>
<div class="row">
    <div class="col-md-2"><strong>User</strong></div>
    <div class="col-md-2"><strong>Time</strong></div>
        <#if showClosedNotes >
            <div class="col-md-1"><strong>Status</strong></div>
        </#if>
    <div class="col-md-4"><strong>Note</strong></div>
    <div class="col-md-3"><strong>MilkRun</strong></div>
    <#--<div class="col-md-1"><strong>Offer</strong></div>-->
</div>
    <#list Util.sortNotesByColor(UserNote.findSome2(showClosedNotes, milkRunSeriesNameSelector, userIdSelector, colorSelector)) as note >
        <a href="/note/edit?id=${note.getId()}">
            <div class="row">
                <#--<div class="col-md-1">                  <@showCheck note />           </div>-->
                <div class="col-md-2">                   <@showAddress note />          </div>
                <div class="col-md-2">                   <@showTime note />             </div>
                    <#if showClosedNotes >
                        <div class="col-md-1">           ${note.getStatus()}            </div>
                    </#if>
                <div class="col-md-4" style="background-color: #${UserNote.getColor(note)}" >      ${note.getBody()}              </div>
                <div class="col-md-3">                   <@showMilkRun note />          </div>
                <#--<div class="col-md-1">                   <@showCartOffer note />        </div>-->
            </div>
        </a>
    </#list>
</#macro>

<style>
        .scrolled70 {
            verflow-y:scroll; overflow-x:scroll;
            max-height: 70vh;
        }
        .cell {
            padding: 0;
            margin: 0;
            //background-color: pink;
        }
</style>


<head>
    <title>Users</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<@styleSheets/>


</head>
<body>

<div class="container">
<@pageHeader3 />

    <div class="container">
        <div class="row" >
            <div class="col-md-2">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin Home</strong></a>
                <br>
            </div>
            <div class="col-md-5">
                <h4>Notes</h4>
            </div>
            <div class="col-md-4">
            </div>
            <div class="col-md-1"></div>
        </div>
        <p></p>
        <div class="row">
            <div class="col-md-2">
                <button onclick="newNoteButton('user')">Create Note</button>
            </div>
            <div class="col-md-4 well" >
                <form method="post" action="/notes/filters">
                    <div>
                        <input type="checkbox" name="showClosedNotes" onChange="this.form.submit()"
                        <#if showClosedNotes >
                               checked
                        </#if>
                        > Show Closed notes
                    </div>
                    <div>
                        <select name="milkRunSeriesNameSelector" onChange="this.form.submit()" style="width: 150px" >
                            <option value="Any"
                                <#if milkRunSeriesNameSelector == "Any" >
                                    selected
                                </#if>
                            >Any</option>
                            <#list MilkRunCollection.findSeriesNames() as seriesName >
                                <option value="${seriesName}"
                                    <#if milkRunSeriesNameSelector == seriesName >
                                        selected
                                    </#if>
                                    >
                                    ${seriesName}
                                </option>
                            </#list>
                        </select>
                        MilkRun
                    </div>
                    <div>
                        <select name="userIdSelector" onChange="this.form.submit()" style="width: 150px" >
                            <option value="Any"  selected >Any</option>
                            <#list Util.sortByUserName(User.findByEnabled(true)) as user >
                                <option value="${user.getId()}"
                                    <#if userIdSelector == user.getId() >
                                        selected
                                    </#if>
                                    >
                                    ${user.getName()}
                                </option>
                            </#list>
                        </select>
                        User Name
                    </div>
                    <div>
                        <select name="colorSelector" onChange="this.form.submit()" style="width: 150px" >
                            <option value="Any"
                            <#if colorSelector == "Any" >
                                    selected
                            </#if>
                            >Any</option>
                            <#list UserNote.getColorNames() as colorName >
                                <option value=${colorName} style="background-color: #${UserNote.colorOf(colorName)}"
                                <#if colorSelector == colorName >
                                    selected
                                </#if>
                                >${colorName}</option>
                            </#list>
                        </select>
                        Color
                    </div>
                </form>
            </div>
            <div class="col-md-5">
                Notes cannot be deleted, however setting them
                Closed and not displaying Closed notes has a similar effect
                without deleting information.
            </div>
        </div>
    </div>
    <p></p>
    <div class="container">
        <div class="row" >
            <ul class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#by-time">By Time</a></li>
                <li><a data-toggle="tab" href="#by-user">By User</a></li>
                <li><a data-toggle="tab" href="#by-color">By Color</a></li>
            </ul>
        </div>
        <div class="col-md-12">
            <div class="tab-content scrolled70" >
                <div id="by-time" class="tab-pane fade in active">
                <@byTime />
                </div>
                <div id="by-user" class="tab-pane fade">
                <@byUser />
                </div>
                <div id="by-color" class="tab-pane fade">
                <@byColor />
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function(){
        $(".nav-tabs a").click(function(){
            $(this).tab('show');
        });
    });

    function newNoteButton(type) {
        location.assign("/note/create");
    }

</script>

</body>
</html>
