#!/usr/bin/env bash


base_dir="$(readlink -f "${1}")"
arg_input_file="${2}"
solution_id="$(sed -e s/\\W/_/g <<< "${base_dir}")"
tmp_dir="/tmp/compiler-assignments/${solution_id}"
# input files
lex_file="${base_dir}/solution.l"
yacc_file="${base_dir}/solution.y"
c_file="${base_dir}/solution.c"
input_file="${base_dir}/input.txt"
# colors
COLOR_RED="\033[0;31m"
COLOR_RESET="\e[0m"
COLOR_WHITE="\033[1;37m"
# intermediate output
c_files=""
in_file=""


# Log to stdout, with colors
# @param message
log() {
    echo -e "${COLOR_WHITE}${1}${COLOR_RESET}"
}


# Log to stderr, with colors
# @param message
error() {
    echo -e "${COLOR_RED}ERROR: ${1}${COLOR_RESET}" 1>&2
}


# we require path to the directory
if [[ ! -d "${base_dir}" ]]
then
    error "missing solution directory"
    exit 1
fi


# we allow passing a custom input file
if [[ -n "${arg_input_file}" ]]
then
    # '-' means use stdin
    if [[ "${arg_input_file}" == "-" ]]
    then
        input_file=""
    else
        input_file="$(readlink -f "${arg_input_file}")"
    fi
fi


# enter our temporary directory
mkdir -p "${tmp_dir}"
pushd "${tmp_dir}" > /dev/null
if [[ ! $? ]]
then
    error "Can not cd into temporary directory"
    exit 1
fi


# process yacc spec file
if [[ -f "${yacc_file}" ]]
then
    log ">> yacc"
    yacc -d "${yacc_file}" || exit 1
    c_files="${c_files} y.tab.c"
fi


# process lex spec file
if [[ -f "${lex_file}" ]]
then
    log ">> lex"
    lex "${lex_file}" || exit 1
    c_files="${c_files} lex.yy.c"
fi


# capture c file
if [[ -f "${c_file}" ]]
then
    c_files="${c_files} ${c_file}"
fi


# ensure we have files to compile
if [[ -z "${c_files}" ]]
then
    error "nothing to do"
    error "ensure you provided a solution directory"
    exit 1
fi


# compile
log ">> gcc"
gcc ${c_files} -ll || exit 1


# un-capture input file
if [[ -f "${input_file}" ]]
then
    in_file="${input_file}"
# we exit with an error if our custom input file is missing
elif [[ -n "${arg_input_file}" ]]
then
    error "custom input file is missing"
    exit 1
fi


# run the executable
log ">> run"
./a.out ${in_file}
