# This script will obtain the source code for Synergia2 (and CHEF, upon which
# Synergia2 depends), and then build and install the software.
#
# The following shell variables should be set for your build.

# Neither of these directories should already exist.
# This script will create the directories.
SYNERGIA_WORK_DIR="$HOME/workdir"
SYNERGIA_INSTALL_DIR="$HOME/synergia-install"

SYNERGIA_PYTHON_DOTVER="python3.8"
SYNERGIA_GIT_BRANCH="mac-native"

# If you need to load any environment modules (e.g. on Fedora) do that here.
# module load mpi

die()
{
  echo "$1"; exit 1;
}

export PYTHONPATH=${SYNERGIA_INSTALL_DIR}/lib/${SYNERGIA_PYTHON_DOTVER}/site-packages${PYTHONPATH+:$PYTHONPATH}
export LD_LIBRARY_PATH=${SYNERGIA_INSTALL_DIR}/lib${LD_LIBRARY_PATH+:$LD_LIBRARY_PATH}
export PATH=${SYNERGIA_INSTALL_DIR}/bin${PATH+:$PATH}

# Make sure running this script with not trash some existing installation.
if [ -d "${SYNERGIA_WORK_DIR}" ]; then
  echo "Please define SYNERGIA_WORK_DIR to specify a new directory to be created, not an existing directory"
  exit 1;
fi

if [ -d "${SYNERGIA_INSTALL_DIR}" ]; then
  echo "Please define SYNERGIA_INSTALL_DIR to specify a new directory to be created, not an existing directory"
fi

# Create directory structure we will use
mkdir -p "${SYNERGIA_WORK_DIR}" || die "Failed to create directory ${SYNERGIA_WORK_DIR}"
mkdir -p "${SYNERGIA_INSTALL_DIR}" || die "Failed to create directory ${SYNERGIA_INSTALLDIR}"

mkdir "${SYNERGIA_WORK_DIR}/chef-build" || die "Failed to create directory for building chef"
mkdir "${SYNERGIA_WORK_DIR}/synergia-build" || die "Failed to create directory for building synergia"

# Clone repositories
cd "${SYNERGIA_WORK_DIR}"
echo "Cloning repositories into ${SYNERGIA_WORK_DIR}"
git clone --branch "${SYNERGIA_GIT_BRANCH}" https://bitbucket.org/fnalacceleratormodeling/chef.git || die "Failed to clone chef repository"
git clone --branch "${SYNERGIA_GIT_BRANCH}" https://mpaterno@bitbucket.org/fnalacceleratormodeling/synergia2.git || die "Failed to clone synergia2 repository"

# Configure, build and install CHEF
cd "${SYNERGIA_WORK_DIR}/chef-build"
echo "Building chef in ${PWD}"
cmake -DUSE_PYTHON_3=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${SYNERGIA_INSTALL_DIR}" ../chef || die "cmake generation failed for chef"
# set parallel build degree as a variable above
make -j 4 || die "Building failed for chef"
make install || die "Installation failed for chef"

echo "Skipping directly to build of Synergia"
# Configure, build and install Synergia
cd "${SYNERGIA_WORK_DIR}/synergia-build"
echo "Building synergia in ${PWD}"
cmake -DUSE_PYTHON_3=1 -DCHEF_DIR=${SYNERGIA_INSTALL_DIR}/lib/chef/cmake -DUSE_SIMPLE_TIMER=0 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=${SYNERGIA_INSTALL_DIR} ../synergia2 || die "cmake generation failed for synergia" 
make -j 4 || die "Building failed for synergia"
make install || die "Installation failed for synergia"

# Generate setup script
cd "${SYNERGIA_WORK_DIR}"
echo "Writing setup-synergia.sh in ${PWD}"
(cat <<ENDTEXT
# This script must be sourced
command -v synergia >/dev/null 2>&1 && { echo "Synergia is already set up."; return 0; }
export PATH=${SYNERGIA_INSTALL_DIR}/bin\${PATH+:\$PATH}
export LD_LIBRARY_PATH=${SYNERGIA_INSTALL_DIR}/lib\${LD_LIBRARY_PATH+:\$LD_LIBRARY_PATH}
export PYTHONPATH=${SYNERGIA_INSTALL_DIR}/lib/${SYNERGIA_PYTHON_DOTVER}/site-packages\${PYTHONPATH+:\$PYTHONPATH}
ENDTEXT
) > setup-synergia.sh
chmod ug+x setup-synergia.sh

echo "Copying setup-synergia.sh into ${SYNERGIA_INSTALL_DIR}"
cp setup-synergia.sh ${SYNERGIA_INSTALL_DIR}/setup-synergia.sh
