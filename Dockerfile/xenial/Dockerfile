
ARG BASE_IMAGE=rstudio/r-base
FROM ${BASE_IMAGE}:xenial

ARG R_VERSION=4.0.0
ARG OS_IDENTIFIER=ubuntu-1604

# Install R
RUN wget https://cdn.rstudio.com/r/${OS_IDENTIFIER}/pkgs/r-${R_VERSION}_1_amd64.deb && \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -f -y ./r-${R_VERSION}_1_amd64.deb && \
    ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
    ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R && \
    rm r-${R_VERSION}_1_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# Install git
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

# magick
RUN apt-get install libssl-dev -y
RUN apt-get install -y libmagick++-dev



# Clone the files into the docker container
RUN git clone https://github.com/henry090/kerastuneR.git k

WORKDIR k

# dir
RUN R -e "getwd()"
RUN R -e "list.files()"

# set cran
RUN R -e "r = getOption('repos')"
RUN R -e "r['CRAN'] = 'http://cran.us.r-project.org'"
RUN R -e "options(repos = r)"

# Install dependecies
RUN R -e "install.packages('remotes', repos='http://cran.us.r-project.org')"
RUN R -e "remotes::install_deps(dependencies =  TRUE)"
RUN R -e "remotes::install_cran('rcmdcheck')"


# Install python
RUN R -e "remotes::install_github('rstudio/reticulate')"
RUN R -e "try(reticulate::install_miniconda())"
RUN R -e "reticulate::conda_create('r-reticulate', packages = 'python==3.6.10')"


# Install Keras Tuner
RUN R -e "remotes::install_local()"
RUN R -e "tensorflow::install_tensorflow(version = '2.0')"
RUN R -e "reticulate::py_install(c('setuptools', 'wheel', 'requests'), pip = TRUE)"
RUN R -e "kerastuneR::install_kerastuner()"

# Check
RUN R -e "rcmdcheck::rcmdcheck(args = '--no-manual', error_on = 'warning', check_dir = 'check')"






