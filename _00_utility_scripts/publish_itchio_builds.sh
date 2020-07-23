#!/bin/zsh
cd "$(dirname "$0")"
cd ..

project_settings="project.godot"
export_configs="export_presets.cfg"
build_folder=$(cat $project_settings | grep "^config/build_folder" | cut -d'=' -f2)
build_folder=$(sed -e 's/^"//' -e 's/"$//' <<< $build_folder)
game_version=$(cat $project_settings | grep "^config/version" | cut -d'=' -f2)
game_version=$(sed -e 's/^"//' -e 's/"$//' <<< $game_version)
project_path=$(pwd)
base_builds_path="$(dirname $project_path)/GameBuilds/$build_folder/Release"
itch_game_adress=eh-jogos/shaderexperiments

builds_to_push=$1

if [[ -z $builds_to_push || $builds_to_push = "all" ]]
then
	builds_to_push="all"
elif [[ $builds_to_push = "linux" ]]
then
	builds_to_push="linux"
elif [[ $builds_to_push = "win" || $builds_to_push = "windows" ]]
then
	builds_to_push="win"
elif [[ $builds_to_push = "mac" || $builds_to_push = "osx" ]]
then
	builds_to_push="osx"
elif [[ $builds_to_push = "html" || $builds_to_push = "web" ]]
then
	builds_to_push="html"
else
	echo "Unrecognized option for builds_to_push: $builds_to_push | changing to 'all'"
	builds_to_push=false
fi

# In the future, maybe try to use the same folder structure you use for steam, but add some ignores to separate the versions
# for OSX you can just send the zip directly
function push_linux {
	echo $itch_game_adress
	butler push --userversion=$game_version $base_builds_path/ShaderExperimentsLinux32 $itch_game_adress\:linux32
	butler push --userversion=$game_version $base_builds_path/ShaderExperimentsLinux64 $itch_game_adress\:linux64
}

function push_windows {
	butler push --userversion=$game_version $base_builds_path/ShaderExperimentsWindows32 $itch_game_adress\:windows32
	butler push --userversion=$game_version $base_builds_path/ShaderExperimentsWindows64 $itch_game_adress\:windows64
}

function push_osx {
	butler push --userversion=$game_version $base_builds_path/ShaderExperimentsOSX $itch_game_adress\:osx-universal
}

function push_html {
	butler push --userversion=$game_version $base_builds_path/ShaderExperimentsHTML5 $itch_game_adress\:html
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