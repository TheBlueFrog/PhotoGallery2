<!DOCTYPE html>
<html>
<head>
</head>
<body>

<div>
    <h3>
        Test JSON Post Page
    </h3>

    <button onclick="sendJSON()">Send</button>

</div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

    <script>
        var data = {
            zipcode: "99999",
            email: "m@m.com"
        };

        function sendJSON() {
            var d = JSON.stringify(data);
            // $.post("/rest/future-service-area", d, function(response) {
            //     var x = 9;
            // }, 'json');
            $.ajax({
                type: "POST",
                url: 'rest/future-service-area',
                data: d,
                success: function(data, status, jqXHR) {
                    var x = 9;
                    },
                dataType: 'json'
            });
        }
    </script>
</body>
</html>

