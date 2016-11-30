# Assignments: Compiler Construction

> Unit: **Compiler Construction** *(ICS 2402 / ICS 2370 / BCT 2311)*
>
> School: **Jomo Kenyatta University of Agriculture and Technology**


## introduction:

<!--
 ! In your terminal at the repo's root directory,
 ! run 'tree -L 2' to re-generate the tree below
 !-->

```
.
├── 1                       # Assignment I
│   ├── 1_i                 # Solution for question 1.i
│   ├── 1_ii                # Solution for question 1.ii
│   ├── 1_iii               # ...
│   ├── 2                   # ...
│   └── assignment.pdf      # The questions
├── 2                       # Assignment II
│   ├── 1                   # Solution for question 1
│   ├── 2                   # ...
│   ├── 3                   # ...
│   └── assignment.pdf      # The questions
├── README.md
└── script                  # Helper scripts. See below.
    └── run.sh
```


## helper scripts:

#### run.sh

This allows compiling a parser and running it immediately.

Usage:

```bash
$ ./script/run.sh <path> [input-file]
```

where:

* `<path>` is a path to a solution directory (**REQUIRED**)
* `[input-file]` is a path to an input file,
  or `-` to use stdin (**optional**)

For example,

```bash
$ ./script/run.sh 1/2               # run solution at 1/2
$ ./script/run.sh 1/2 input.txt     # run solution at 1/2, using a custom input file
$ ./script/run.sh 2/1 -             # run solution at 2/1, using stdin
```


## license:

**DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE**
<br>Version 2, December 2004

Copyright (C) 2016 AngryCoders
