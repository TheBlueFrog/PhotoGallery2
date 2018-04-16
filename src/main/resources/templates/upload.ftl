<!DOCTYPE html>
<html lang="en">
<#include "macros.ftl">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8">
    <@styleSheets/>
    <title>Upload Items</title>
    <style>
        th { text-align: left; }
        td {
            text-align: left;
            vertical-align: text-top;
        }
        .mine {
            padding-top: 5px;
            padding-bottom: 5px;
        }
    </style>

</head>
<body>
    <@pageHeader3 />

    <p></p>
    <div>
        <div class="row">
            <div class="col-sm-12">
                <div class="col-sm-1"></div>

                <form  method="POST" enctype="multipart/form-data" action="/upload-image">
                    <div class="col-sm-2">
                            Select Files to upload &nbsp;
                    </div>
                    <div class="col-sm-2">
                            <input type="file" name="files" multiple/> &nbsp;
                    </div>
                    <div class="col-sm-3">
                        <button class="btn btn-sm" type="submit" >Upload</button>
                    </div>
                </form>

            </div>
        </div>
    </div>
    <p></p>

    <a href="#" class="scroll_top" title="Scroll to Top">Scroll</a>

</body>
</html>