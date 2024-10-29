#!/bin/bash

PATH="$PATH:$(pwd)"

set_up_test9() {
    mkdir test9
    touch test9/ass9.automarking test9/ass9.autotests
    echo "test_1|1||" >>test9/ass9.autotests
    echo "test_2|3||b" >>test9/ass9.autotests
    echo "test_3|5||w" >>test9/ass9.autotests
    chmod 755 test9/ass9.autotests

    echo "test_1|1|||5" >>test9/ass9.automarking
    echo "test_2|3||b|6" >>test9/ass9.automarking
    echo "test_3|5||w|09" >>test9/ass9.automarking
    chmod 755 test9/ass9.automarking

    touch test9/ass9_solution.sh
    echo "#!/bin/dash" >> test9/ass9_solution.sh
    echo 'echo "The magic number is: $1 :)))"' >> test9/ass9_solution.sh
    chmod 755 test9/ass9_solution.sh

    touch test9/student_solution.sh
    echo "#!/bin/dash" >> test9/student_solution.sh
    echo 'echo "The magic number is $1 :::"' >> test9/student_solution.sh
    chmod 755 test9/student_solution.sh

    touch test9/non_executable.sh
    mkdir test9/non_x_dir
    chmod -755 test9/non_x_dir

    echo "test_1|@||" >>test9/invalid_arguments.autotests
    echo "test_1|%^||" >>test9/invalid_arguments.autotests
    echo "test_3||%@|" >>test9/invalid_arguments.autotests

}

rm -rf .quicktest
set_up_test9

# Redirect stdout and stderr of actual output
TEST8_STDOUT_ACT="$(mktemp)"
TEST8_STDERR_ACT="$(mktemp)"

### MY IMPLEMENTATION vs REFERENCE IMPLEMENTATION

# successful creation of ass9a
# remove the "directory .quicktest created" message
quicktest-add ass9a test9/ass9_solution.sh test9/ass9.autotests test9/ass9.automarking 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT

# invalid quicktest-add of autotests arguments
quicktest-add ass9i test9/ass9_solution.sh test9/invalid_arguments.autotests test9/ass9.automarking 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT

# successful creation of ass9b
quicktest-add ass9b test9/student_solution.sh test9/ass9.autotests test9/ass9.automarking 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT

# sucessful multiple submissions by multiple students
# successful quicktest-submit for student z1111111
i=0
while [ "$i" -lt 5 ]; do
    quicktest-submit ass9a z1111111 test9/student_solution.sh 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
    quicktest-submit ass9b z2222222 test9/ass9_solution.sh 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
    quicktest-submit ass9a z3333333 test9/student_solution.sh 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
    i=$((i+1))
done

i=0
while [ "$i" -lt 2 ]; do
    quicktest-submit ass9b z1111111 test9/ass9_solution.sh 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
    quicktest-submit ass9a z3333333 test9/student_solution.sh 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
    i=$((i+1))
done

i=0
while [ "$i" -lt 4 ]; do
    quicktest-submit ass9a z2222222 test9/student_solution.sh 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
    quicktest-submit ass9b z3333333 test9/ass9_solution.sh 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
    i=$((i+1))
done

# run quicktest-summary
quicktest-summary 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT

# run quicktest-status
quicktest-status z1111111 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
quicktest-status z2222222 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
quicktest-status z3333333 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT

# run quicktest-fetch
quicktest-fetch ass9a z1111111 3 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
quicktest-fetch ass9a z2222222 -1 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
quicktest-fetch ass9a z3333333 4 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT

quicktest-fetch ass9b z1111111 0 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
quicktest-fetch ass9b z2222222 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
quicktest-fetch ass9b z3333333 6 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT

# check if <assignment> does not exist AND file is not executable
quicktest-autotest ass9i test9/non_executable.sh 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT

# check if <assignment> does not exist AND file does not exist
quicktest-autotest ass9i test9/not_exists.sh 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT

# check if <assignment> does not exist AND file is a non-executable directory
quicktest-autotest ass9i test9/non_x_dir 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT

# run quicktest-autotest
quicktest-autotest ass9a test9/student_solution.sh 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
quicktest-autotest ass9b test9/ass9_solution.sh 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT

# run quicktest-mark
quicktest-mark ass9a 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
quicktest-mark ass9b 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT

# run quicktest-rm
quicktest-rm ass9a 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT
quicktest-rm ass9b 1>> TEST9_STDOUT_ACT 2>> TEST9_STDERR_ACT

rm -rf test9
rm -rf .quicktest