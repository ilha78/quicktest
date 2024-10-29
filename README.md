# QuickTest: A minimal workspace to validate your scripts

This project was written using bash.

## Setup

Clone this repository and in the cloned directory (where all the scripts are located), run `PATH="$PATH:$(pwd)"`.

## Important notes

Each quicktest directory should be made to test/verify for a particular solution.

All autotests files must be in the format where each line's columns are separated by `|` and in the form `name of test|argv|stdin|option` e.g. `test_9|5|2|bcdw`. option includes **b** to ignoring empty lines, **c** to ignore case sensitivity, **d** to ignore characters other than numbers and newline, and **w** to ignore space and tabs.

Similarly, all automarking files must be in the same format as autotests files with an additional column representing the available marks for that test, i.e. `name of test|argv|stdin|test option|mark`.

All names should be alphanumeric otherwise an invalid error will trigger.

## Available Scripts

### `quicktest-add <project> <solution> <autotests> <automarking>`

Creates a new directory for your `project` to later verify script file(s) to the target `solution` file. The series of tests are in the `autotest` file and marks are calculated via the `automarking` file. Note that `project` is simply the name of the project.

### `quicktest-submit <project> <user> <script>`

Submit a `script` for a particular `user`. The most recent submission will test against the solution in the `project` directory. `user` can simply be the name of the user.

### `quicktest-summary`

Lists the names of all projects with a count of the number of users contributing to the project.

### `quicktest-status <user>`

Lists all submissions a user has made.

### `quicktest-fetch <project> <user> [n]`

Outputs the contents of a submission the `user` has made for the `project`. If the optional third argument `n` is specified, output the the nth submission made by the `user`. Otherwise, output the latest submission.

### `quicktest-autotest <project> <script>`

Runs the autotest for a targeted `script` in the current working directory against the solution in the specified `project`.

### `quicktest-mark <project>`

Runs the automarking for the latest submission made by each user against the solution in the specified `project`.

### `quicktest-rm <project>`

Removes a project from workspace.







