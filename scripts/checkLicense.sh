#!/bin/bash

#ALL=''
#ONLY_ERRORS=0
COLOR='YES'

DIR=$1
if [ -z "$DIR" ]; then
    DIR='../'
fi

if [ -n "$COLOR" ]; then
    RED='\E[0;31m'
    YELLOW='\E[0;33m'
    GREEN='\e[0;32m'
    NORM='\E[0;37;40m'
    RED_BG='\E[41m'
fi


#let 'invlid=0'
#let 'lgplCnt=0'
#let 'gplCnt=0'
#let 'unknownCnt=0'


# License compatibility: BSD 3-Clause; LGPL v2.1 or later

for file in `find ${DIR} -type f \( -name '*.h' -o -name '*.cpp' \)  2>/dev/null`; do
    license=`head -n 5 "$file"| grep '(c)' | sed -e 's/*//'`;# | sed -e 's/\([()]\)/\\1/g'`;

    case "$license" in
        *LGPL2+*|*DWTFYW*|*BSD3*)
            [ -z "$ALL" ] && continue
            color=$GREEN
            ;;

        *LGPL3+*)
            color=$GREEN
            ;;

        *LGPL2*|*LGPL3*)
            [ -n "$ONLY_ERRORS" ] && continue
            color=$YELLOW
            ;;

        *GPL2*|*GPL3*)
            [ -n "$ONLY_ERRORS" ] && continue
            color=$RED
            ;;

        *)
            color=$RED_BG
            [ -z "$license" ] && license='  Not set'
            ;;
    esac

    let "div = 20 - ${#license}"
    printf "${color}%-20s %s${NORM}\n"  "${license}" "$file"
done
#echo
#echo "LGPL:    $lgplCnt"
#echo "GPL:     $gplCnt"
#echo "Unknown: $unknownCnt"
