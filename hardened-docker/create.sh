#!/bin/bash
if [ "$#" -ne 4 ]; then
    printf "Usage:\n  $0 <vendor> <product> <container> <version>\n"
    exit 1
fi

# Create the directory structure
fullpath=${1}/${2}/${3}/${4}

# Define the subdirectories to create
declare -a subdirs=("accreditation" "compliance" "documentation" "examples" "scripts" "helm" "src")

# Create the subdirectories
for i in "${subdirs[@]}"
do
   mkdir -p ${fullpath}/"$i"
done

# Populate inital versions of the supporting files, with TODOs as appropriate
printf "# %s %s %s\n\nTODO Describe this image here\n" $1 $2 $3 $4 > ${fullpath}/README.md
printf "# Changelog\n\nAll notable changes to this project will be documented in this file.\n\nThe format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)\n\n## [%s] - %s\n\n### Added\nInitial version\n\n### Changed\n\n### Removed" $4 "$(date +%D)" > ${fullpath}/CHANGELOG.md
printf "TODO - License information should be placed here" > ${fullpath}/LICENSE
printf "FROM registry.access.redhat.com/ubi7-dev-preview/ubi:latest \n\nMAINTAINER <vendor>\n\nLABEL <labels>\n\n  \n\n#TODO populate this dockerfile" > ${fullpath}/Dockerfile
printf "// TODO - define jenkinsfile for the %s %s %s image" $1 $2 $3 $4 > ${fullpath}/Jenkinsfile
printf "# Accreditation\n\nAny accreditation related documentation will be placed in this directory.\n" > ${fullpath}/accreditation/README.md
printf "# Compliance\n\nAny SCAP files or OVAL or similar compliance configuration goes here.\n" > ${fullpath}/compliance/README.md
printf "# Documentation\n\nAdditional documentation files go here (e.g., pdf documentations)\n" > ${fullpath}/documentation/README.md
printf "# Examples\n\nDocumentation examples that explain how to use this container\n" > ${fullpath}/examples/README.md
printf "# Scripts\n\nSupporting scripts required by the Dockerfile" > ${fullpath}/scripts/README.md
printf "# Helm chart\n\nSupporting chart(s) required to install your application. Use \`helm create myapp\`" > ${fullpath}/helm/README.md
