#!/bin/bash

# update git repos
#cd "$dir_src_mr_website"
git pull


# parse version from Website.java
grep_version_string=$(grep 'ThisVersion = ' src/main/java/com/mike/website3/Website.java)
this_version=$(echo $grep_version_string | awk -F '= \"' '{print $2}' | awk -F '\"' '{print $1}') # EXAMPLE: grep_version_string = private static final String ThisVersion = "0.50.7";
echo "### this_version: $this_version"


# build it!
gradle build -x test

# copy built jar to runtime location
cp build/libs/PhotoGallery2-0.0.1-SNAPSHOT.jar ../website/website.jar

