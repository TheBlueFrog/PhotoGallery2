<!DOCTYPE html>
<html>
<head>
</head>
<body>

<div>
    <h3>
        TEST PAGE
    </h3>

    <#if sessionErrors?? >
        <div>
            FTL variable <i>sessionErrors</i> is defined
            <#list sessionErrors as error >
                <br>
                Error code: ${error.code}, ${error.error}
            </#list>
        </div>
    <#else>
        <div>
            FTL variable <i>error</i> is not defined
        </div>
    </#if>

    <#if testPage?? >
        <div>
            FTL variable <i>testPage</i> is defined
            <br>
            ${testPage}
        </div>
    <#else>
        <div>
            FTL variable <i>testPage</i> is not defined
        </div>
    </#if>
</div>

</body>
</html>

