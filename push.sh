#!/bin/sh
if [ $# -ne 1 ]; then
    echo "Usage: $0 destination"
    exit 1
fi
#Copy a catalog elsewhere. Wonderful script.
REMOTE=/Volumes/www-sop/members/Fabien.Hermenier/
cp -r $1 $REMOTE/