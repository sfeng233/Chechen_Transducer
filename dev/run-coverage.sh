#!/bin/bash

LG=che
CORPUSDIR=~/ling073/ling073-$LG-corpus/
ANALYSERDIR=~/ling073/ling073-$LG/
CORPUS=$CORPUSDIR/che.wikipedia.2019-02-01.txt.bz2
ANALYSER=$ANALYSERDIR/$LG.automorf.hfst

TMPCORPUS=/tmp/$LG.corpus.txt

bzcat $CORPUS > $TMPCORPUS

echo "Generating hitparade (might take a bit!)"
cat $TMPCORPUS | apertium-destxt | hfst-proc -w $ANALYSER | apertium-retxt | sed 's/\$\s*/\$\n/g' > /tmp/$LG.parade.txt

echo "TOP UNKNOWN WORDS:"

cat /tmp/$LG.parade.txt | grep '\*' | sort | uniq -c | sort -rn | head -n20

#TOTAL=`bzcat $CORPUS | apertium-destxt | hfst-proc $ANALYSER | apertium-retxt| sed 's/\$/\$\n/g' | wc -l`
TOTAL=`cat /tmp/$LG.parade.txt | wc -l`
#KNOWN=`bzcat $CORPUS | apertium-destxt | hfst-proc $ANALYSER | apertium-retxt | sed 's/\$/\$\n/g' | grep -v '\*' | wc -l`
KNOWN=`cat /tmp/$LG.parade.txt | grep -v '\*' | wc -l`
#UNKNOWN=`bzcat $CORPUS | apertium-destxt | hfst-proc $ANALYSER | apertium-retxt | sed 's/\$ /\$\n/g' | grep '\*' | wc -l`
UNKNOWN=`cat /tmp/$LG.parade.txt | grep '\*' | wc -l`

PERCENTAGE=`calc $KNOWN/$TOTAL | sed 's/[\s\t]//g'`

echo "coverage: $KNOWN / $TOTAL ($PERCENTAGE)"
echo "remaining unknown forms: $UNKNOWN"


