#!/usr/bin/env bash

shopt -s extglob

THIS_PATH=$(dirname "${BASH_SOURCE[0]}")
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
dry_run="0"

configDir=${XDG_CONFIG_HOME}/nvim

log() {
	if [[ $dry_run == "1" ]]; then
		echo "[DRY RUN] $*"
	else
		echo "$*"
	fi
}

##################################################
#	MAIN
##################################################

while [[ $# -gt 0 ]]; do
	if [[ $1 =~ ^-d ]] || [[ $1 =~ ^--d ]]; then
		dry_run="1"
	fi
	shift
done

mkdir -p "$configDir"

pushd "$THIS_PATH" &>/dev/null || exit 1
(
	# Copy files
	for file in *; do
		if [[ -f $file ]] && [[ ! "$file" == "install.sh" ]]; then
			log "Copying file: $file to $configDir"
			if [[ $dry_run == "0" ]]; then
				cp "$file" "$configDir"
			fi
		fi
	done

	if [[ -f .neoconf.json ]]; then
		log "Copying file: .neoconf.json to $configDir"
		if [[ $dry_run == "0" ]]; then
			cp .neoconf.json "$configDir"
		fi
	fi

	for folder in !(.)*/; do
		log "Copying folder: $folder to $configDir"
		if [[ $dry_run == "0" ]]; then
			cp -R "$folder" "$configDir"
		fi
	done
)

popd &>/dev/null || exit 1
