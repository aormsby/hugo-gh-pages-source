#!/bin/sh

# TODO: make ignored file list and branch lists
ignore_files=(".git" "CNAME")
pub_submodule="public/"
dev_branches=()
prod_branches=()

# TODO: Add auto-build number to commit message
auto_build=0
commit_message="site auto-build #${auto_build} - $(date +"%D %T")"

# TODO: check for any remote updates to module/sub before doing anything
# TODO: record branches to commit and publish to, switch to them, and then return to previous branch

# TODO: check for errors after commands and back out if failure

# Build the project.
# TODO: check for build errors, exit if errors
if ! hugo # if using a theme, replace with `hugo -t <YOURTHEME>`
then
	echo "Deploy failed. Please fix Hugo build errors and try again."
	exit
fi

# TODO: properly catch later errors and remove this option
set -e

# TODO: delete all files in public for full refresh (except ignored list) if command option is set

# Git add all files in public submodule
git -C "${pub_submodule}" add .

# Git commit public submodule with message
if [ -n "$*" ] ; then
	commit_message="$*"
fi
git -C "${pub_submodule}" commit -m "${commit_message}"

# Git add all files in main module
git add .

# Git commit main module with message
if [ -n "$*" ] ; then
	commit_message="$*"
fi
git commit -m "${commit_message}"

# Push parent and submodule source changes together
git push -u origin master --recurse-submodules=on-demand
