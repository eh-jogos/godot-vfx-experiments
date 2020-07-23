#!/bin/zsh

project_settings="../project.godot"
export_configs="../export_presets.cfg"
include_debug=$1
export_output=$2


if [[ -z $include_debug || $include_debug = "false" ]]
then
   	include_debug=false
elif [[ $include_debug = "true" ]]
then
	include_debug=true
else
	echo "Unrecognized option for include_debug: $include_debug | changing to false"
	include_debug=false
fi


game_version=$(cat $project_settings | grep "^config/build_folder" | cut -d'=' -f2)
game_version=$(sed -e 's/^"//' -e 's/"$//' <<< $game_version)
echo "Exporting $game_version with debug turned: $include_debug"


function getProperty {
   	prop_key=$1
   	prop_value=$(cat $export_configs | grep $prop_key | cut -d'=' -f2)
   	echo $prop_value
}

export_profiles=(${=$(getProperty "^name")})
echo "Going to Export the following profiles: $export_profiles"
export_paths=(${=$(getProperty "^export_path")})

length=${#export_profiles[@]}
for ((i = 1; i <= $length; i++));
do
	profile=${export_profiles[i]}
	filename=$(sed -e 's/^"//' -e 's/"$//' <<< ${export_paths[i]})
	# This is to accept other modifiers in case you want
	# to have separate scripts for building steam releases
	# or building itch.io releases. Just add them as cases below
	case $export_output in
		"steam")
			./build_steam_releases.sh $game_version $profile $filename $include_debug
			;;
		*)
			./build_standalone_releases.sh $game_version $profile $filename $include_debug
			;;
	esac
done