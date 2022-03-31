#!/bin/bash

# Constants
GIT_CLONE_SSH="git@github.com:netguru/netguru-android-template.git"
GIT_CLONE_HTTPS="https://github.com/netguru/netguru-android-template.git"
GIT_CLONE_URL=$GIT_CLONE_SSH
TEMP_DIR=".TEMP_DIR"
SRC_SUB_DIRS=( "kotlin/" "java/")
APP_MODULE_DIR="app/"

# Functions

function read_arguments() {

	if  [[ $1 = "-manual" ]]; then
		# Assign input arguments to variables
		GIT_PROTOCOL=$2 # ssh or https
		NEW_APP_ID=$3
		PROJECT_DIR=$4
		MAKE_INITIAL_COMMIT=$5 # y or n
		REMOTE_NAME=$6
		REMOTE_URL=$7
		BRANCH_NAME=$8
		COMMIT_MSG=$9
	else
		# Read arguments from console.
		read -p 'SSH or HTTPS, which protocol would you use for git [ssh]: ' GIT_PROTOCOL
		GIT_PROTOCOL=${GIT_PROTOCOL:-ssh}

		read -p 'New applicationId: ' NEW_APP_ID

		DEFAULT_PROJECT_DIR=`echo $NEW_APP_ID|awk -F . '{print $NF}'`
		read -p "Enter your project directory [$DEFAULT_PROJECT_DIR]: " PROJECT_DIR
		PROJECT_DIR=${PROJECT_DIR:-$DEFAULT_PROJECT_DIR}

		read -p 'Do you want to make initial commit and push it to remote y/n [y]: ' MAKE_INITIAL_COMMIT
		MAKE_INITIAL_COMMIT=${MAKE_INITIAL_COMMIT:-y}

		if [[ $MAKE_INITIAL_COMMIT =~ ^[Yy] ]]; then

			read -p 'Remote name [origin]: ' REMOTE_NAME
				REMOTE_NAME=${REMOTE_NAME:-origin}
				read -p 'Remote URL: ' REMOTE_URL
				while [[ -z $REMOTE_URL ]]; do
					echo "Remote URL cannot be empty!"
					read -p 'Remote URL: ' REMOTE_URL
				done

			read -p 'Branch name (remember that master is probably protected from direct push) [initial]: ' BRANCH_NAME
				BRANCH_NAME=${BRANCH_NAME:-initial}

			read -p 'Initial commit msg [Initial commit]: ' COMMIT_MSG
		fi

	fi
}

function validate_arguments() {
	if [ -z "$NEW_APP_ID" ]; then
			echo "New applicationId cannot be empty!"
			exit 1
	fi

	if [ ! -z "`echo $NEW_APP_ID | awk 'gsub(/[a-zA-Z0-9_\.]/,"") {print $0}'`" ]; then
			echo "All characters in applicationId must be alphanumeric or an underscore [a-zA-Z0-9_]."
			exit 1
	fi
	if [ ! -z "`echo $NEW_APP_ID | awk 'match($0, /\.\.|^\.|\.$/) {print $0}'`" ]; then
			echo "ApplicationId cannot have empty segments."
			exit 1
	fi
	appidsegments=( `echo $NEW_APP_ID | awk 'gsub(/\./," ") {print $0}'` )
	if [ ${#appidsegments[@]} -lt 2 ]; then
			echo "ApplicationId should containt at least 2 segments (i.e. co.project)."
			exit 1
	fi
	for segment in "${appidsegments[@]}"; do
		if [ -z "`echo $segment | awk 'match($0, /^[a-zA-Z]/) {print $0}'`" ]; then
			echo "Segment \"$segment\" - is invalid. Each segment of applicationId must start with a letter."
			exit 1
		fi
	done

	if [ -d "$PROJECT_DIR" ]; then
		echo "Project directory already exists, please try again."
		exit 1
	fi
}

function create_project() {
	if [[ $GIT_PROTOCOL =~ ^[Hh] ]]; then
		GIT_CLONE_URL=$GIT_CLONE_HTTPS
	fi

	git clone $GIT_CLONE_URL $PROJECT_DIR
	cd $PROJECT_DIR
	rm -rf .git/
	touch secret.properties
	cd $APP_MODULE_DIR
	OLD_APP_ID=`cat build.gradle | grep -w applicationId | awk 'match($0, /\"(.*?)\"/) {print substr($0, RSTART + 1, RLENGTH - 2)}'`
	OLD_DIR=`echo $OLD_APP_ID | awk 'gsub(/\./,"\/") {print $0}'`
	NEW_DIR=`echo $NEW_APP_ID | awk 'gsub(/\./,"\/") {print $0}'`
	cd src
	shopt -s dotglob nullglob
	for srcdir in $(ls -d */); do
		cd ${srcdir}
		for srcsubdir in "${SRC_SUB_DIRS[@]}"; do
			if [ -d "$srcsubdir" ]; then
				cd ${srcsubdir}
				mkdir -p "$TEMP_DIR"
				mv -f "$OLD_DIR"/* "$TEMP_DIR/"
				rm -rf "`echo $OLD_DIR | awk -F / '{print $1}'`"
				mkdir -p "$NEW_DIR"
				mv -f "$TEMP_DIR"/* "$NEW_DIR/"
				rm -rf "$TEMP_DIR"
				cd ..
			fi
		done
		cd ..
	done
	cd ..
	cd ..
	echo "Replacing old application id inside files:"
	OLD_APP_ID_REGEX=`echo $OLD_APP_ID | awk 'gsub(/\./,"\\\.") {print $0}'`
	NEW_APP_ID_REGEX=`echo $NEW_APP_ID | awk 'gsub(/\./,"\\\.") {print $0}'`
	set +e
	find . \( -type d -name .git -prune \) -o -type f | while read -r file; do
		NON_BINARY_FILE=`file -I "$file"|grep -Ev "charset=binary"| awk -F : '{print $1}'`
		if [ -z "$NON_BINARY_FILE" ]; then
			echo "Binnary file skipped: $file"
		else
			echo "Processing file: $NON_BINARY_FILE"
			sed -i '' -e "s/$OLD_APP_ID_REGEX/$NEW_APP_ID_REGEX/g" "$NON_BINARY_FILE"
		fi
	done
	set -e
	git init
	git add .

	if [[ $MAKE_INITIAL_COMMIT =~ ^[Yy] ]]; then
		git remote add $REMOTE_NAME $REMOTE_URL
		git fetch
		git checkout -b $BRANCH_NAME
		COMMIT_MSG=${COMMIT_MSG:-Initial commit}
		git commit -m "$COMMIT_MSG"
		set +e
		git rebase --strategy-option ours $REMOTE_NAME/master
		set -e
		git push -f -u $REMOTE_NAME $BRANCH_NAME
	fi
}

# Execution

read_arguments
validate_arguments
create_project
echo "DONE!"
exit 0
