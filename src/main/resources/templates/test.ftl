<!DOCTYPE html>
<html>
<head>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script>
$(document).ready(function(){
    $("button").click(function(){
        if(this.id == "alertOK") {
            <#if session.notice?? >
                var url = "/session-api/clear/notice/${session.notice.id}";
                $.get(url, function(data, status){
                    $("#alertDiv").remove();
                });
            </#if>
        }
        else {
            var i = this.id;

            var q = i + "-quantity";
            var qid = "#" + q;
            var qv = $(qid);

            var r = i + "-freq";
            var s = "input[name=" + r + "]:checked";
            var f = $(s).val()

            var url = "/shop-api/addToCart/" + i + "/" + qv.val() + "/" + f;
            $("#result").load(url);
        }
    });
});
</script>
</head>
<body>

<div>
    <h3>
        JQuery TEST PAGE
    </h3>
    <h3>
        server: <div id="result"></div>
    </h3>
</div>

<#if session.notice?? >
    <div id="alertDiv">
        <div><h2>${session.notice.body}</h2></div>
        <button id="alertOK">OK</button>
    </div>
</#if>

<div>
    <div>item one</div>

    <input id="one-quantity" type="number" min="1" max="10" value="1"/>

    <input id="one-freq-once" type="radio" name="one-freq" value="once" checked/> Once <br>
    <input id="one-freq-week" type="radio" name="one-freq" value="weekly"/> Weekly
    <br>
    <button id="one">Add</button>
</div>

<div>
    <div>item two</div>

    <input id="two-quantity" type="number" min="1" max="10" value="1"/>
    <input id="two-freq-once" type="radio" name="two-freq" value="once" checked/> Once <br>
    <input id="two-freq-week" type="radio" name="two-freq" value="weekly"/> Weekly

    <button id="two">Add</button>
</div>


</body>
</html>

