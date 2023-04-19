#! /bin/bash

rm -rf build
echo "Remove ./build"

test_dir="tests"
for sub_dir in "${test_dir}"/*; do
    if [ -d "${sub_dir}" ]; then
        script="${sub_dir}/clean.sh"
        if [ -f "${script}" ]; then
            echo "Run ${script}"
            bash "${script}"
        else
            echo "No clean.sh in ${sub_dir}"
        fi
    fi
done
