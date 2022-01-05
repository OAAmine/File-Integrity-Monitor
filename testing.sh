#!/bin/bash
echo "What Would you like to do ? "
echo "A) Collect baseline ? "
echo "B) Begin monitoring files with saves Baseline ?"
#add cases of users not entering A or B
echo -n "[A/B] ? :"
read ans 
if [ $ans = "a" ] || [ $ans = "A" ]
then
	echo "yes he responded A or a"
fi
