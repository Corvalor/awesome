#!/bin/bash

for var in "$@"
do
echo "$var"
done
#UTC
date -u                       +"<b><span size=\"x-large\">⌚</span>UTC:        </b><i> %T</i>"
#Places
TZ='Europe/Rome' date         +"<b><span size=\"x-large\">⌚</span>Europe:     </b><i> %T</i>"
