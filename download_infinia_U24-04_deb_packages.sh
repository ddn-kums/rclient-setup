#!/bin/bash

CMD_OUTPUT_DIR="/work/kums/repo/infinia/cmd_output"
BASE_CMD_OUTPUT_FILE="$CMD_OUTPUT_DIR/download_infinia_U24-04_deb_pkgs_output"
REPO_DIR="/work/kums/repo/infinia/deb"
SERVER_PKG_LIST="redsetup"
#CLIENT_PKG_LIST="redcli red-client-common red-client-dev red-client-fs red-client-tests red-client-tools red-client-ublk red-client-fs-dkms"
CLIENT_PKG_LIST="redcli red-client-common red-client-fs red-client-tools"
CLIENT_DKMS_PKG="red-client-fs-dkms"
SLEEPT=1

# DO NOT EDIT BELOW, UNLESS NECESSARY

CMD_OUTPUT_FILE=$BASE_CMD_OUTPUT_FILE"_`date +%F-%T`.txt"
echo "Downloading Infinia packages: `date`" 2>&1 | tee -a $CMD_OUTPUT_FILE

export BASE_PKG_URL="https://storage.googleapis.com/ddn-redsetup-public" &&
export RELEASE_TYPE="" && \
export TARGET_ARCH="$(dpkg --print-architecture)" && \
export REL_DIST_PATH="ubuntu/24.04" && \
export REL_PKG_URL="${BASE_PKG_URL}/releases${RELEASE_TYPE}/${REL_DIST_PATH}" && \
export RED_VER="2.2.43"

mkdir -p $REPO_DIR/$RED_VER
sleep $SLEEPT

echo "Downloading Infinia Ubuntu 24.04 packages: `date`" 2>&1 | tee -a $CMD_OUTPUT_FILE

#Downloading U24.04 Infinia Server Packages
for pkg in $SERVER_PKG_LIST
do
	echo "Downloading Server Package: $pkg at `date`" 2>&1 | tee -a $CMD_OUTPUT_FILE
	wget $REL_PKG_URL/"${pkg}"_"${RED_VER}"_"${TARGET_ARCH}${RELEASE_TYPE}".deb?cache-time="$(date +$s)" -O $REPO_DIR/$RED_VER/"${pkg}"_"${RED_VER}"_"${TARGET_ARCH}${RELEASE_TYPE}".deb >> $CMD_OUTPUT_FILE 2>&1
	if [ $? -eq 0 ]; then
		echo "Download of Server Package $pkg is successful" 2>&1 | tee -a $CMD_OUTPUT_FILE
	else
		echo "Download of Server Package $pkg failed" 2>&1 | tee -a $CMD_OUTPUT_FILE
		rm -f $REPO_DIR/$RED_VER/"${pkg}"_"${RED_VER}"_"${TARGET_ARCH}${RELEASE_TYPE}".deb
	fi

	sleep $SLEEPT
done

#Downloading U24.04 Infinia Client Packages
for pkg in $CLIENT_PKG_LIST
do
	echo "Downloading Client Package: $pkg at `date`" 2>&1 | tee -a $CMD_OUTPUT_FILE
	wget $REL_PKG_URL/"${pkg}"_"${RED_VER}"_"${TARGET_ARCH}${RELEASE_TYPE}".deb?cache-time="$(date +$s)" -O $REPO_DIR/$RED_VER/"${pkg}"_"${RED_VER}"_"${TARGET_ARCH}${RELEASE_TYPE}".deb >> $CMD_OUTPUT_FILE 2>&1
	if [ $? -eq 0 ]; then
		echo "Download of Client Package $pkg is successful" 2>&1 | tee -a $CMD_OUTPUT_FILE
	else
		echo "Download of Client Package $pkg failed" 2>&1 | tee -a $CMD_OUTPUT_FILE
		rm -f $REPO_DIR/$RED_VER/"${pkg}"_"${RED_VER}"_"${TARGET_ARCH}${RELEASE_TYPE}".deb
	fi

	sleep $SLEEPT
done

#Download U24.04 Infinia Client dkms Package
export BASE_PKG_URL="https://storage.googleapis.com/ddn-redsetup-public" &&
export RELEASE_TYPE="" && \
export TARGET_ARCH="all" && \
export REL_DIST_PATH="ubuntu/24.04" && \
export REL_PKG_URL="${BASE_PKG_URL}/releases${RELEASE_TYPE}/${REL_DIST_PATH}" && \
export DKMS_VER="0.0.12"
pkg=$CLIENT_DKMS_PKG
	
echo "Downloading Client DKMS Package: $pkg at `date`" 2>&1 | tee -a $CMD_OUTPUT_FILE
wget $REL_PKG_URL/"${pkg}"_"${DKMS_VER}"_"${TARGET_ARCH}${RELEASE_TYPE}".deb?cache-time="$(date +$s)" -O $REPO_DIR/$RED_VER/"${pkg}"_"${DKMS_VER}"_"${TARGET_ARCH}${RELEASE_TYPE}".deb >> $CMD_OUTPUT_FILE 2>&1
if [ $? -eq 0 ]; then
	echo "Download of Client Package $pkg is successful" 2>&1 | tee -a $CMD_OUTPUT_FILE
else
	echo "Download of Client Package $pkg failed" 2>&1 | tee -a $CMD_OUTPUT_FILE
	rm -f $REPO_DIR/$RED_VER/"${pkg}"_"${DKMS_VER}"_"${TARGET_ARCH}${RELEASE_TYPE}".deb
fi
