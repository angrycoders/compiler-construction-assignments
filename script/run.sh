#!/usr/bin/env bash

set -e

lex_file="$(readlink -f "${1}")"
yacc_file=""
input_file="$(readlink -f "${2}")"
lex_file_id="$(sed -e s/\\W/_/g <<< "${lex_file}")"
tmp_dir="/tmp/${lex_file_id}"

# colors
COLOR_RESET="\e[0m"
COLOR_WHITE="\033[1;37m"


# logging to console
log() {
    echo -e "${COLOR_WHITE}${color}${1}${COLOR_RESET}"
}


# optional yacc spec file
if [[ -n "${3}" ]]
then
    yacc_file="${input_file}"
    input_file="$(readlink -f "${3}")"
fi

# we need a lex file
if [[ -z "${lex_file}" ]]
then
    echo "Lex file missing"
    exit 1
fi

# we need an input file
if [[ -z "${input_file}" ]]
then
    echo "Input file missing"
    exit 1
fi

mkdir -p "${tmp_dir}"
pushd "${tmp_dir}" > /dev/null || {
    echo "Can NOT cd into tmp dir"
    exit 1
}


c_files="lex.yy.c"


if [[ -n "${yacc_file}" ]]
then
    log ">> yacc"
    yacc -d "${yacc_file}"
    c_files="${c_files} y.tab.c"
fi

log ">> lex"
lex "${lex_file}"

log ">> gcc"
gcc ${c_files} -ll

log ">> run"
./a.out "${input_file}"
