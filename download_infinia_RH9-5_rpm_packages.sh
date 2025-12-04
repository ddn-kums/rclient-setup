#!/bin/bash

CMD_OUTPUT_DIR="/work/kums/repo/infinia/cmd_output"
BASE_CMD_OUTPUT_FILE="$CMD_OUTPUT_DIR/download_infinia_RH9-6_rpm_pkgs_output"
REPO_DIR="/work/kums/repo/infinia/rpm"
#CLIENT_PKG_LIST="redcli red-client-common red-client-dev red-client-fs red-client-tests red-client-tools red-client-ublk red-client-fs-dkms"
CLIENT_PKG_LIST="redcli red-client-common red-client-fs red-client-tools"
CLIENT_DKMS_PKG="red-client-fs-dkms"
SLEEPT=1

# DO NOT EDIT BELOW, UNLESS NECESSARY

CMD_OUTPUT_FILE=$BASE_CMD_OUTPUT_FILE"_`date +%F-%T`.txt"
echo "Downloading Infinia packages: `date`" 2>&1 | tee -a $CMD_OUTPUT_FILE

export BASE_PKG_URL="https://storage.googleapis.com/ddn-redsetup-public" &&
export RELEASE_TYPE="" && \
export TARGET_ARCH="x86_64" && \
export REL_DIST_PATH="rockylinux/el9/rpm" && \
export REL_PKG_URL="${BASE_PKG_URL}/releases${RELEASE_TYPE}/${REL_DIST_PATH}" && \
export RED_VER="2.3.0-rc5"
export OS_VER="el9"

mkdir -p $REPO_DIR/$RED_VER
sleep $SLEEPT

echo "Downloading Infinia RHEL 9.6 packages: `date`" 2>&1 | tee -a $CMD_OUTPUT_FILE

#Downloading RHEL 9.6 Infinia Client Packages
for pkg in $CLIENT_PKG_LIST
do
	echo "Downloading Client Package: $pkg at `date`" 2>&1 | tee -a $CMD_OUTPUT_FILE
	wget $REL_PKG_URL/"${pkg}"-"${RED_VER}"."${OS_VER}"."${TARGET_ARCH}${RELEASE_TYPE}".rpm?cache-time="$(date +$s)" -O $REPO_DIR/$RED_VER/"${pkg}"-"${RED_VER}"."${OS_VER}"."${TARGET_ARCH}${RELEASE_TYPE}".rpm >> $CMD_OUTPUT_FILE 2>&1
	if [ $? -eq 0 ]; then
		echo "Download of Client Package $pkg is successful" 2>&1 | tee -a $CMD_OUTPUT_FILE
	else
		echo "Download of Client Package $pkg failed" 2>&1 | tee -a $CMD_OUTPUT_FILE
		rm -f $REPO_DIR/$RED_VER/"${pkg}"-"${RED_VER}"."${OS_VER}"."${TARGET_ARCH}${RELEASE_TYPE}".rpm
	fi

	sleep $SLEEPT
done


export BASE_PKG_URL="https://storage.googleapis.com/ddn-redsetup-public" &&
export RELEASE_TYPE="" && \
export TARGET_ARCH="noarch" && \
export REL_DIST_PATH="rockylinux/el9/rpm" && \
export REL_PKG_URL="${BASE_PKG_URL}/releases${RELEASE_TYPE}/${REL_DIST_PATH}" && \
export DKMS_VER="2.3.0-rc5"
export OS_VER="el9"
pkg=$CLIENT_DKMS_PKG

echo "Downloading Client DKMS Package: $pkg at `date`" 2>&1 | tee -a $CMD_OUTPUT_FILE
wget $REL_PKG_URL/"${pkg}"-"${DKMS_VER}"."${OS_VER}"."${TARGET_ARCH}${RELEASE_TYPE}".rpm?cache-time="$(date +$s)" -O $REPO_DIR/$RED_VER/"${pkg}"-"${DKMS_VER}"."${OS_VER}"."${TARGET_ARCH}${RELEASE_TYPE}".rpm >> $CMD_OUTPUT_FILE 2>&1
if [ $? -eq 0 ]; then
        echo "Download of Client Package $pkg is successful" 2>&1 | tee -a $CMD_OUTPUT_FILE
else
        echo "Download of Client Package $pkg failed" 2>&1 | tee -a $CMD_OUTPUT_FILE
        rm -f $REPO_DIR/$RED_VER/"${pkg}"-"${DKMS_VER}"."${OS_VER}"."${TARGET_ARCH}${RELEASE_TYPE}".rpm
fi
