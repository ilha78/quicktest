#!/bin/bash

# Assignment 1: quicktest
# test8.sh
#
# This program was written by ILHA JUNG (z5421387)
# <z5421387@ad.unsw.edu.au> on 07/07/2024
#
# Auxilliary testing and extended testing of quicktest-autotest
# Running quicktest-autotesst and then quicktest-mark for multiple students
# We will also be passing in args rather than stdin

PATH="$PATH:$(pwd)"

set_up_test8() {
    mkdir test8
    touch test8/ass8_student1.sh
    echo '#!/bin/dash' >>test8/ass8_student1.sh 
    echo 'case "$1" in' >>test8/ass8_student1.sh  
    echo '0)' >>test8/ass8_student1.sh 
    echo '    echo the' >>test8/ass8_student1.sh 
    echo '    echo' >>test8/ass8_student1.sh 
    echo '    echo "ANSWER is  2"' >>test8/ass8_student1.sh 
    echo '    ;;' >>test8/ass8_student1.sh 
    echo '1)' >>test8/ass8_student1.sh 
    echo '    echo " The "' >>test8/ass8_student1.sh 
    echo '    echo "  "' >>test8/ass8_student1.sh 
    echo '    echo "answer    is 2 "' >>test8/ass8_student1.sh 
    echo '    ;;' >>test8/ass8_student1.sh 
    echo '2)' >>test8/ass8_student1.sh 
    echo '    echo The' >>test8/ass8_student1.sh 
    echo '    echo "answer is  d"' >>test8/ass8_student1.sh 
    echo '    echo' >>test8/ass8_student1.sh 
    echo '    ;;' >>test8/ass8_student1.sh 
    echo '3)' >>test8/ass8_student1.sh 
    echo '    echo There is extra' >>test8/ass8_student1.sh 
    echo '    echo text here' >>test8/ass8_student1.sh 
    echo '    echo "but answer is still 2"' >>test8/ass8_student1.sh 
    echo '    ;;' >>test8/ass8_student1.sh 
    echo '*)' >>test8/ass8_student1.sh 
    echo '    echo The' >>test8/ass8_student1.sh 
    echo '    echo' >>test8/ass8_student1.sh 
    echo '    echo "answer is  $1"' >>test8/ass8_student1.sh 
    echo 'esac' >>test8/ass8_student1.sh 
    chmod 755 test8/ass8_student1.sh

    touch test8/ass8_student2.sh
    echo '#!/bin/dash' >>test8/ass8_student2.sh
    echo 'echo the' >>test8/ass8_student2.sh
    echo 'echo "answer is $1"' >>test8/ass8_student2.sh
    chmod 755 test8/ass8_student2.sh

    touch test8/ass8_solution.sh
    echo '#!/bin/dash' >>test8/ass8_solution.sh
    echo 'echo The' >>test8/ass8_solution.sh
    echo 'echo "Answer is $1"' >>test8/ass8_solution.sh
    chmod 755 test8/ass8_solution.sh

    touch test8/ass8.autotests test8/ass8.automarking

    echo 'test_1|3||' >>test8/ass8.autotests
    echo 'test_2|2||b' >>test8/ass8.autotests
    echo 'test_3|1||bc' >>test8/ass8.autotests
    echo 'test_4|34||bd' >>test8/ass8.autotests
    echo 'test_5|1||bw' >>test8/ass8.autotests
    echo 'test_6|2||bcd' >>test8/ass8.autotests
    echo 'test_7|3||bcw' >>test8/ass8.autotests
    echo 'test_8|3||bdw' >>test8/ass8.autotests
    echo 'test_9|5||bcdw' >>test8/ass8.autotests
    chmod 755 test8/ass8.autotests

    echo 'test_1|3|||21' >>test8/ass8.automarking
    echo 'test_2|2||b|18' >>test8/ass8.automarking
    echo 'test_3|1||bc|010' >>test8/ass8.automarking
    echo 'test_4|34||bd|31' >>test8/ass8.automarking
    echo 'test_5|1||bw|69' >>test8/ass8.automarking
    echo 'test_6|2||bcd|00030' >>test8/ass8.automarking
    echo 'test_7|3||bcw|8' >>test8/ass8.automarking
    echo 'test_8|3||bdw|51' >>test8/ass8.automarking
    echo 'test_9|5||bcdw|0' >>test8/ass8.automarking
    chmod 755 test8/ass8.automarking
}

rm -rf .quicktest 

set_up_test8

# Redirect stdout and stderr of expected output


# Redirect stdout and stderr of actual output
TEST8_STDOUT_ACT="$(mktemp)"
TEST8_STDERR_ACT="$(mktemp)"

### MY IMPLEMENTATION vs REFERENCE IMPLEMENTATION

# successful creation of ass8
# remove the "directory .quicktest created" message


quicktest-add ass8 test8/ass8_solution.sh test8/ass8.autotests test8/ass8.automarking 1>> TEST8_STDOUT_ACT 2>> TEST8_STDERR_ACT

# successful quicktest-submit for student z1111111
quicktest-submit ass8 z1111111 test8/ass8_student1.sh 1>> TEST8_STDOUT_ACT 2>> TEST8_STDERR_ACT

# successful quicktest-submit for student z2222222
quicktest-submit ass8 z2222222 test8/ass8_student2.sh 1>> TEST8_STDOUT_ACT 2>> TEST8_STDERR_ACT

# run quicktest-autotest for z1111111
quicktest-autotest ass8 test8/ass8_student1.sh 1>> TEST8_STDOUT_ACT 2>> TEST8_STDERR_ACT

# run quicktest-autotest for z2222222
quicktest-autotest ass8 test8/ass8_student2.sh 1>> TEST8_STDOUT_ACT 2>> TEST8_STDERR_ACT

# run the correct solution onto itself
quicktest-autotest ass8 test8/ass8_solution.sh 1>> TEST8_STDOUT_ACT 2>> TEST8_STDERR_ACT

# run quicktest-mark for <assignment>
quicktest-mark ass8 1>> TEST8_STDOUT_ACT 2>> TEST8_STDERR_ACT


rm -rf test8
