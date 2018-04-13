<!DOCTYPE HTML>
<html>
<head>
    <style>
        body {
            margin: 0px;
            padding: 0px;
        }
    </style>
</head>
<body>

<canvas id="myCanvas" width="500" height="500"></canvas>
<script>
    var canvas = document.getElementById('myCanvas');
    var context = canvas.getContext('2d');

    context.font = 'italic 10pt Calibri';
    context.fillText('Hello World!', 150, 75);

    context.beginPath();
    context.moveTo(100, 100);
    context.lineTo(200, 50);
    context.stroke();

</script>

</body>
</html>