#!/bin/bash
echo -ne "would you like to\n1) Create a new baseline\nOr\n2) Proceed with the previously recorded one\n1 | 2 ? "
read ans
echo $ans
#check user input 


if [ "$ans" = "1" ];then
       	echo "yes"
fi

