#! /bin/bash

# The template file with the installation instructions
template_file="def/all_inclusive_r_template.def"

# The version tag in the template file
template_version="latest"

# For what versions of R/Rstudio do I want to build containers
version=("4.0" "4.1" "4.2" "4.3.1" "4.3.2")

# The build command from apptainer
command='sudo -E apptainer build --force'

for ver in "${version[@]}"; do

    # Define the names of .sif and def. file for a specific version
    output="sif/all_inclusive_r_${ver}.sif"
    input="def/all_inclusive_r_${ver}.def"

    # Replace the version tag in the template with the version to build
    sed "2s/$template_version/$ver/" $template_file > $input

    # Compile full build command
    full_command="$command $output $input"

    echo "Building: v$ver"
    echo "Executing: $full_command"
    $full_command
    echo "Done with v$ver!"

done
