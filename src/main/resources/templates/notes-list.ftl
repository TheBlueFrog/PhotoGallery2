<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">

<#macro showNote notes>
<div class="row">
    <div class="col-md-2"></div>
    <div class="col-md-1"><strong>Status</strong></div>
    <div class="col-md-2"><strong>User</strong></div>
    <div class="col-md-5"><strong>Note</strong></div>
    <div class="col-md-1"><strong>MilkRun</strong></div>
    <div class="col-md-1"><strong>Offer</strong></div>
</div>
    <#list notes as note >
        <a href="/note/edit?id=${note.getId()}">
            <div class="row">
                <div class="col-md-2">
                ${Util.formatTimestamp(note.getTimestamp(), "MMM dd YYYY hh:mm z")}
                </div>
                <div class="col-md-1">
                ${note.getStatus()}
                </div>
                <div class="col-md-2">
                    <#if note.getUserId() != "" >
                        <#assign address = Address.findNewestByUserIdAndUsageS(note.getUserId(), "Default") >
                        ${address.getLastName()},
                        ${address.getFirstName()}
                    </#if>
                </div>
                <div class="col-md-5" style="background-color: #${UserNote.getColor(note)}" >
                ${note.getBody()}
                </div>
                <div class="col-md-1">
                    <#if note.getMilkRunSeriesName() != "" >
                        <a href="/milkrun/show2/${note.getMilkRunSeriesName()}">MilkRun</a>
                    </#if>
                </div>
                <div class="col-md-1">
                </div>
            </div>
        </a>
    </#list>
</#macro>


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
            <p></p>
            <div class="col-md-2">
                <a href="/"><strong>Home</strong></a>
                <br>
                <a href="/admin"><strong>Admin Home</strong></a>
                <br>
                <a href="${backURL}"><strong>Back to...</strong></a>
            </div>
            <div class="col-md-5">
                <h4>${title}</h4>
            </div>
            <div class="col-md-4">
            </div>
            <div class="col-md-1"></div>
        </div>
        <p></p>
    </div>
    <p></p>
    <div class="container">
        <@showNote notes/>
    </div>
</div>

<script>
    $(document).ready(function(){
        $(".nav-tabs a").click(function(){
            $(this).tab('show');
        });
    });

    function newNoteButton(type) {
        location.assign("/note/create?type=" + type);
    }

</script>

</body>
</html>
