# Comp-Med R Apptainer Image

## Introduction

This is a `singularity` container similar to the RStudio containers in
`/all-inclusive-rstudio-apptainer/` but does not contain RStudio but the
improved R console [`radian`](https://github.com/randy3k/radian).

This repository contains the definition files (`.def`) for building a
modified [rocker/r-ver](https://hub.docker.com/r/rocker/r-ver)
container. Using this container to launch R sessions will
prevent you from experiencing common issues when installing and using
R packages that depend on a variety of system libraries during build-
or runtime.

Please check the [Apptainer Documentation](https://apptainer.org/docs/) for
more information on how to create, modify, build and run the image (`.sif`)
files.

## Build Container

Containers can be build based on any available rocker/r-ver container.
Building one on your own will most likely only be necessary when you need to
run a specific version of R that is not already available. Check the [group
documentation](https://github.com/comp-med/group-documentation/blob/master/docs/working-with-containers/singularity-overview.md)
for details on how to build your own containers. When working from within the
Charite/BIH network, make sure you have set the proxy environment variables. To
change the base R version used in the container, modify the line starting with
`From:` in the definition file, e.g. to `From: rocker/r:4.3.1` to use the
version 4.3.1 of R or `From: rocker/r-ver:4.1` to use the latest version of R
4.1, i. e. 4.1.3.

```bash
# Navigate to the directory where images are located
cd /sc-projects/sc-proj-computational-medicine/programs/all-inclusive-r-apptainer/

# Containers need to be built with root priviliges
sudo -E apptainer build sif/all_inclusive_r_4.3.1.sif def/all_inclusive_r_4.3.1.def
```

The script `build_apptainer.sh` will automatically modify the file
`def/all_inclusive_r_template.def` to create containers for every version
of R specified in the `version` variable. This simplifies the updating of all
containers. This way, only the template needs to be updated with additional
library installations and the script will automatically create updated
`.def`-files for each version of R and build the containers.

## Launch a Container

Pre-built containers that can be used to launch R sessions on the HPC cluster
are located in
`/sc-projects/sc-proj-computational-medicine/programs/all-inclusive-r-apptainer/`.
The containers can be used interactively to lauch a terminal or R session.

```bash
# Start an interactive session on a compute node
srun --time=00-7 --mem=32G --ntasks=1 --pty bash -i

# Check that apptainer (formerly singularity) is available
apptainer --version

# Navigate to the directory where images are located
cd /sc-projects/sc-proj-computational-medicine/programs/all-inclusive-r-apptainer/

# Launch a terminal session from the container. Root priviliges are not necessary
apptainer shell sif/all_inclusive_r_4.3.1.sif

# Launch R from within the container
apptainer exec sif/all_inclusive_r_4.3.1.sif radian
```

## You Still Have Installation Errors?

What should you do when you still face installation errors in R? Check
which package makes problems and search the installation log for the exact
library that is missing. Often, it'll print `ERROR`, followed by something
about a missing `.h` or `.so` file, indicating a missing shared library or
development headers that we simply have to add to the definition file. Identify
what library from the Ubuntu package repository provides the missing file and
add it to the definition file template and run the `build_apptainer.sh` script
to re-build the containers with the new library. Re-launch RStudio and try to
install the previously failed package again.
