#!/bin/bash

PROGRAMA=$1

for directorio in $(find . -type f -name "*.4gl" | cut -c 3- | \
		awk -F "/" '{for(i=1; i<NF; i++){printf "%s/", $i}; print ""}' | uniq); do

	DBSRC=${PWD}/${directorio}:${DBSRC}
done

export DBSCR

fgldb ${PROGRAMA}
