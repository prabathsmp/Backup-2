#!/bin/bash
echo -e "Make sure that base file is available at SYSROM_SRC/dev/AL/Reporting/ReportManager/reportgenerator_base.cpp\n"
#export Error=0 
#echo -e "environment var Error = $Error\n"
BASE_FILE=./SYSROM_SRC/dev/AL/Reporting/ReportManager/rmdefines_base.h
if [ -f $BASE_FILE ];
then
   echo -e "File $BASE_FILE exists\n";
else
   echo -e "File $BASE_FILE does not exists,Exiting...\n";
   exit 0;
fi
COUNT_A=$[$(cat $BASE_FILE  | wc -c) - $(cat $BASE_FILE  | tr -d "♠" | wc -c)|bc];
echo -e "Count of Character [♠] in BASE_FILE = [$COUNT_A]\n";
COUNT_B=$[$(cat $BASE_FILE  | wc -c) - $(cat $BASE_FILE  | tr -d "♣" | wc -c)|bc];
echo -e "Count of Character [♣] in BASE_FILE = [$COUNT_B]\n";
COUNT_C=$[$(cat $BASE_FILE  | wc -c) - $(cat $BASE_FILE  | tr -d "♦" | wc -c)|bc];
echo -e "Count of Character [♦] in BASE_FILE = [$COUNT_C]\n";
MODIFIED_FILE=./SYSROM_SRC/dev/AL/Reporting/ReportManager/rmdefines.h


if [ -f $MODIFIED_FILE ];
then
   echo -e "File $MODIFIED_FILE exists\n";
else
   echo -e "File $MODIFIED_FILE does not exists,Exiting...\n";
  exit 0; 
fi
COUNT_a=$[$(cat $MODIFIED_FILE  | wc -c) - $(cat $MODIFIED_FILE  | tr -d "♠" | wc -c)|bc];
echo -e "Count of Character [♠] in MODIFIED_FILE = [$COUNT_a]\n";
COUNT_b=$[$(cat $MODIFIED_FILE  | wc -c) - $(cat $MODIFIED_FILE  | tr -d "♣" | wc -c)|bc];
echo -e "Count of Character [♣] in MODIFIED_FILE = [$COUNT_b]\n";
COUNT_c=$[$(cat $MODIFIED_FILE  | wc -c) - $(cat $MODIFIED_FILE  | tr -d "♦" | wc -c)|bc];
echo -e "Count of Character [♦] in MODIFIED_FILE = [$COUNT_c]\n";


if [ $COUNT_A == $COUNT_a ];
then
	echo -e "Character count of [♠] is same\n"
else
	echo -e "Character [♠] Newly introduced, Difference = $[$COUNT_A - $COUNT_a|bc]\n"
	#Error=1
fi

if [ $COUNT_B == $COUNT_b ];
then
	echo -e "Character count of [♣] is same\n"
else
	echo -e "Character [♣] Newly introduced, Difference = $[$COUNT_B - $COUNT_b|bc]\n"
	#Error=1
fi

if [ $COUNT_C == $COUNT_c ];
then
	echo -e "Character count of [♦] is same\n"
	#rror=1
else
	echo -e "Character [♦] Newly introduced, Difference = $[$COUNT_C - $COUNT_c|bc]\n"
fi
