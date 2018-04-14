<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">

    <style>
    </style>

    <script>
    </script>
</head>
<body>

Email addresses for user ${user.username}
    <ul>
        <#list user.phoneNumbers as pn>
            <li>
                ${pn.phoneNumber}
            </li>
        </#list>
    </ul>

End
</body>
</html>
