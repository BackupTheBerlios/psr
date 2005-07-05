#!/bin/sh

# this outputs a very basic list of most played sound files.

NUMBER=$1
if echo $NUMBER | grep '^[0-9]\+$' > /dev/null; then
	N=$NUMBER
else
	N=10
fi

FILE=$2

#grep "/play " $FILE | grep -v http | sed 's/^.*\/play//' | sed 's/<\/.*$//' | sed 's/^ *//' | tr -s ' ' '\n' | tr 'A-Z' 'a-z' | sort | uniq -c | sort -gr | head -n $N
grep "[\\/]play " $FILE | grep -v http | sed 's/^.*[\\\/]play//' | sed 's/<\/.*$//' | sed 's/^ *//' | tr -s ' ' '\n' | tr 'A-Z' 'a-z' | sort | uniq -c | sort -gr | head -n $N
