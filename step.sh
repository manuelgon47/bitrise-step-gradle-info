#!/bin/bash
set -e

#
# Required parameters
pwd = `pwd`
echo $pwd
if [ -z "${gradle_file_path}" ] ; then
  echo " [!] Missing required input: gradle_file_path"
  exit 1
fi
if [ ! -f "${gradle_file_path}" ] ; then
  echo " [!] File doesn't exist at specified build.gradle path: ${gradle_file_path}"
  exit 1
fi

version_name=`grep -m 1 versionName ${gradle_file_path} | sed 's/^[[:blank:]]*versionName[[:blank:]]*[[:blank:]]*\"\([^\"]*\)\".*$/\1/'`

if [ -z "${version_name}" ] ; then
  echo " [!] No version_name specified!"
  exit 1
fi

version_code=`grep versionCode ${gradle_file_path} | sed 's/.*versionCode*"//;s/".*//' | awk '{print $2}'`

if [ -z "${version_code}" ] ; then
  echo " [!] No version_code specified!"
  exit 1
fi

# Set env vars
envman add --key GRADLE_FILE_PATH --value "${gradle_file_path}"
envman add --key GRADLE_VERSION_NAME --value $version_name
envman add --key GRADLE_VERSION_NAME --value $version_code
