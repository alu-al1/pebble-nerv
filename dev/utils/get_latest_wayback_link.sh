
#!/bin/bash

## get wayback link to given url using jq, date and curl minus 'waybackpy' bloatware and majority of its cool features tbh =) 

## MIT License
## 
## Copyright (c) 2025 Andrei Povarov
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
## 
## The above copyright notice and this permission notice shall be included in all
## copies or substantial portions of the Software.
## 
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.

wayback_api_search="https://web.archive.org/cdx/search/cdx"
## Search API available query parameters ( not all are tested )

##  * General Query Parameters for wayback_api_search
## url=		The URL to search for in the archive.	url=example.com
## matchType=	Type of URL matching (exact, prefix, host, domain).	matchType=prefix
## collapse=	Collapse results to avoid duplicates (timestamp:N, digest).	collapse=digest
## filter=		Filter results based on fields (!statuscode:500).	filter=!statuscode:500
## fl=		Specifies which fields to return (comma-separated).	fl=timestamp,original,statuscode
## limit=		Limits the number of results returned.	limit=5
## offset=		Skips the first N results.	offset=10

##  * Timestamp & Sorting Parameters
## from=		Start date (YYYYMMDDhhmmss format).	from=20230101
## to=		End date (YYYYMMDDhhmmss format).	to=20231231
## closest=	Finds the closest snapshot to a given timestamp.	closest=20240301000000
## sort=		Sort results by date (asc, desc).	sort=desc

##  * Output Formatting
## output=		Output format (json, xml, csv, txt).	output=json
## gzip=		Compress output (true or false).	gzip=true

wayback_api_wayback="https://web.archive.org/web"

ts=$(date +%Y%m%d%H%M%S)
url=$1

missing=
for deps in jq date curl; do
    ## note: type -p will not work right of the bat with the vanilla sh
    type -p $deps 1>/dev/null || { missing="$missing $deps"; }
done

if [ ! -z "$missing" ]; then
    echo "The following packages or utilities required: $missing";
    exit 1;
fi
set -e

[ ! -z "$url" ] || { echo "USAGE: $0 <url>"; exit 1; }

set -x              # you may want to disable this

url_encoded=$(jq -rn --arg url "$url" '$url|@uri')

latest_ts=\
$(curl -s "$wayback_api_search"\
"?""url=""$url_encoded"\
"&""timestamp=""$ts"\
"&""closest=""true"\
"&""sort=""desc"\
"&""output=""json"\
"&""filter=""!statuscode:500""&""filter=""!statuscode:404"\
"&""limit=""1"\
"&""fl=""timestamp" | \
\
jq -r 'if length > 1 then .[1][] else "" end')

[ ! -z "$latest_ts" ]

echo "$wayback_api_wayback""/""$latest_ts""/""$url_encoded"