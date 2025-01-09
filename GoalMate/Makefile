.PHONY: generate graph intro signup home all

# Generate 명령어들
generate:
	TUIST_ROOT_DIR=${PWD} tuist generate

generate-all:
	TUIST_ROOT_DIR=${PWD} TUIST_TYPE=ALL tuist generate

generate-intro:
	TUIST_ROOT_DIR=${PWD} TUIST_TYPE=INTRO tuist generate

generate-signup:
	TUIST_ROOT_DIR=${PWD} TUIST_TYPE=SIGNUP tuist generate

generate-home:
	TUIST_ROOT_DIR=${PWD} TUIST_TYPE=HOME tuist generate

# Graph 명령어들
graph-all:
	TUIST_TYPE=ALL tuist graph

graph-intro:
	TUIST_TYPE=INTRO tuist graph

graph-signup:
	TUIST_TYPE=SIGNUP tuist graph

graph-home:
	TUIST_TYPE=HOME tuist graph

APP_DIR = ${PWD}/Projects/App


clean-generate-signup: clean generate-signup

clean-generate-home: clean generate-home

clean-generate-intro: clean generate-intro

clean-generate-all: clean generate-all

clean-generate: clean generate

clean:
	echo "Closing Xcode..."
	killall Xcode || true
	echo "Cleaning Xcode projects in App directory..."
	cd $(APP_DIR) && rm -rf *.xcodeproj
	cd $(APP_DIR) && rm -rf Derived/
	cd $(APP_DIR) && rm -rf Tuist/Dependencies/
	echo "Clean completed ✨"
	tuist clean

generate:
	@echo "Generating Xcode projects..."
	@tuist generate
	@echo "Generation completed 🚀"
