#!/bin/zsh
cd "$(dirname "$0")"
cd ..

version=$1
profile=$2
filename=$3
include_debug=$4

echo
echo "Building Standalone release for: $profile"
echo "Game Version is: $version"

godot_version="32"
project_path=$(pwd)
base_builds_path="$(dirname $project_path)/GameBuilds"
project_name="ShaderExperiments"

fpath=( ~/.zfunc "${fpath[@]}" )
autoload -Uz godot

echo "###########################################################"
unquoted_profile=$(sed -e 's/^"//' -e 's/"$//' <<< $profile)
final_path_release=$base_builds_path/$version/Release/$project_name$unquoted_profile/
final_path_debug=$base_builds_path/$version/Debug/$project_name$unquoted_profile/

echo "Exporting $unquoted_profile Release to $final_path_release"
mkdir -p $final_path_release
godot $godot_version --export $unquoted_profile $final_path_release$filename

if [[ $include_debug = "true" ]]
then
	echo "Exporting $unquoted_profile Debug to $final_path_debug"
	mkdir -p $final_path_debug
	godot $godot_version --export-debug $unquoted_profile $final_path_debug$filename
fi

echo "Exporting $unquoted_profile Finished"
echo "###########################################################"
echo