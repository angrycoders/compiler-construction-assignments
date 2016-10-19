#!/usr/bin/env bash

lex_file="$(readlink -f "${1}")"
input_file="$(readlink -f "${2}")"
lex_file_id="$(sed -e s/\\W/_/g <<< "${lex_file}")"
tmp_dir="/tmp/${lex_file_id}"

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

lex "${lex_file}"
gcc lex.yy.c -lfl
./a.out "${input_file}"
