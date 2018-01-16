#!/bin/bash
set -e

#
# Required parameters
pwd = `pwd`
if [ -z "${gradle_file_path}" ] ; then
  echo " [!] Missing required input: gradle_file_path"
  exit 1
fi
if [ ! -f "${gradle_file_path}" ] ; then
  echo " [!] File doesn't exist at specified build.gradle path: ${gradle_file_path}"
  exit 1
fi

old_version_name=`grep -m 1 versionName ${gradle_file_path} | sed 's/^[[:blank:]]*versionName[[:blank:]]*[[:blank:]]*\"\([^\"]*\)\".*$/\1/'`
if [ -z "${old_version_name}" ] ; then
  echo " [!] No versionName founded on $gradle_file_path"
  exit 1
fi

old_version_code=`grep versionCode ${gradle_file_path} | sed 's/.*versionCode*"//;s/".*//' | awk '{print $2}'`
if [ -z "${old_version_code}" ] ; then
  echo " [!] No versionCode founded on $gradle_file_path"
  exit 1
fi

# Set version code
if [ -n "${version_code}" ] ; then
	new_version_code=$(($version_code+$version_code_offset))
	sed -i.bak "s/versionCode $old_version_code/versionCode $new_version_code/g" $gradle_file_path
	version_code=new_version_code
else
	version_code=$old_version_code
fi

# Set version name
if [ -n "${version_name}" ] ; then
	sed -i.bak "versionName $old_version_name/versionName $version_name/s" $gradle_file_path
else
	version_name=$old_version_name
fi

# Set env vars
envman add --key GRADLE_FILE_PATH --value "${gradle_file_path}"
envman add --key GRADLE_VERSION_NAME --value $version_name
envman add --key GRADLE_VERSION_NAME --value $version_code
