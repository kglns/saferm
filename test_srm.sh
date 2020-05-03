#!/bin/bash

# Set up
mkdir -p tmp_test/{a..d}
touch tmp_test/{a..d}/{1..5}
rm -r /tmp/recycle

cd tmp_test/a
../../srm.sh 1
if test -f tmp_test/a/1;then echo "Fail";else echo "Pass";fi
if test -f /tmp/recycle/.restore;then echo "Pass";else echo "Fail";fi

../../srm.sh {2..5}
count=$(grep tmp_test/a /tmp/recycle/.restore | wc -l)
if test $count -eq 5;then echo "Pass - expected 5, got $count";else echo "Fail - expected 5, got $count";fi

# Clean up
rm -r ../../tmp_test