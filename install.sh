#!/usr/bin/env bash

shopt -s extglob

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
dry_run="0"

configDir=${XDG_CONFIG_HOME}/nvim
files=(
	init.lua
	.neoconf.json
	stylua.toml
)
# folders=(
# 	after
# 	snippets
# 	spell
# )

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
# for file in "${files[@]}"; do
for file in *; do
	if [[ -f $file ]]; then
		log "Copying file: $file to $configDir"
		if [[ $dry_run == "0" ]]; then
			cp "$file" "$configDir"
		fi
	fi
done

# for folder in !(.)*/; do
# 	log "Copying folder: $folder to $configDir"
# 	if [[ $dry_run == "0" ]]; then
# 		cp -R "$folder" "$configDir"
# 	fi
# done
