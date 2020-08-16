#!/bin/zsh
cd "$(dirname "$0")"
cd ..

itch_game_adress=eh-jogos/shaderexperiments
project_name="ShaderExperiments"

project_settings="project.godot"
export_configs="export_presets.cfg"
build_folder=$(cat $project_settings | grep "^config/build_folder" | cut -d'=' -f2)
build_folder=$(sed -e 's/^"//' -e 's/"$//' <<< $build_folder)
game_version=$(cat $project_settings | grep "^config/version" | cut -d'=' -f2)
game_version=$(sed -e 's/^"//' -e 's/"$//' <<< $game_version)
project_path=$(pwd)
base_builds_path="$(dirname $project_path)/GameBuilds/$build_folder/Release"

builds_to_push=$1

case $builds_to_push in
	"all")
		builds_to_push="all"
		;;
	"linux" | "lin")
		builds_to_push="linux"
		;;
	"win" | "windows")
		builds_to_push="win"
		;;
	"mac" | "osx")
		builds_to_push="osx"
		;;
	"html" | "web")
		builds_to_push="html"
		;;
	*)
		echo "Unrecognized option for builds_to_push: $builds_to_push | changing to default ('all')"
		builds_to_push="all"
		;;
esac


# In the future, maybe try to use the same folder structure you use for steam, but add some ignores to separate the versions
# for OSX you can just send the zip directly
function push_linux {
	echo $itch_game_adress
	butler push --userversion=$game_version $base_builds_path/$project_name+Linux32 $itch_game_adress\:linux32
	butler push --userversion=$game_version $base_builds_path/$project_name+Linux64 $itch_game_adress\:linux64
}

function push_windows {
	butler push --userversion=$game_version $base_builds_path/$project_name+Windows32 $itch_game_adress\:windows32
	butler push --userversion=$game_version $base_builds_path/$project_name+Windows64 $itch_game_adress\:windows64
}

function push_osx {
	butler push --userversion=$game_version $base_builds_path/$project_name+OSX $itch_game_adress\:osx-universal
}

function push_html {
	butler push --userversion=$game_version $base_builds_path/$project_name+HTML5 $itch_game_adress\:html
}


case $builds_to_push in
	"linux")
		push_linux
		;;
	"win")
		push_windows
		;;
	"osx")
		push_osx
		;;
	"html")
		push_html
		;;
	*)
		push_linux
		push_windows
		push_osx
		push_html
		;;
esac