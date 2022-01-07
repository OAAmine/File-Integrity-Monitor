#!/bin/bash
declare -A test_var
test_var[key1]=5
test_var['key2']='value2'
echo ${test_var[key1]}
echo ${test_var['key2']}
