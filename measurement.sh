#/bin/bash

if ! [ $(command -v lighthouse) ]; then
    echo "Found no lighthouse executable this system. Please get it from https://github.com/GoogleChrome/lighthouse"
    exit 1
elif [ $# -lt 1 ]; then
    echo "Please provide a target URL argument."
    exit 1
elif [ $(wget --spider $1 2>/dev/null) ]; then
    echo "Please provide a proper and existing target URL." 
    exit 1
fi

pathPrefix=$(pwd)/$(date  +"%Y-%m-%d-%H:%M")


# Lighthouse npm package
# https://github.com/GoogleChrome/lighthouse
lighthouse $1 --preset=desktop --output=json --output-path=$pathPrefix-lighthouse-report-destkop.json;
lighthouse $1 --output=json --output-path=$pathPrefix-lighthouse-report-mobile.json;

# Use curL + PageSpeed Insights API
# https://developers.google.com/speed/docs/insights/rest/v5/pagespeedapi/runpagespeed
accessKey=# TODO: Add your PageSpeed Insights API Key
baseURL="https://pagespeedonline.googleapis.com/pagespeedonline/v5/runPagespeed?key=$accessKey&category=PERFORMANCE"

curl -G --data-urlencode "url=$1" --header 'Accept: application/json' --compressed "$baseURL&strategy=DESKTOP"   > $pathPrefix-pagespeedonline-report-desktop.json; 
curl -G --data-urlencode "url=$1" --header 'Accept: application/json' --compressed "$baseURL&strategy=MOBILE"   > $pathPrefix-pagespeedonline-report-mobile.json; 
