.PHONY: generate graph intro signup home all

PROJECT_TYPE ?= "APP"

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
	TUIST_TYPE=ALL PROJECT_TYPE=ALL tuist graph

graph-intro:
	TUIST_TYPE=INTRO PROJECT_TYPE=INTRO tuist graph

graph-signup:
	TUIST_TYPE=SIGNUP tuist PROJECT_TYPE=SIGNUP graph

graph-home:
	TUIST_TYPE=HOME PROJECT_TYPE=HOME tuist graph

APP_DIR = ${PWD}/Projects/App


clean-generate-signup: clean generate-signup

clean-generate-home: clean generate-home

clean-generate-intro: clean generate-intro

clean-generate-all: clean generate-all

clean-generate: clean generate

clean:
	@echo "Closing Xcode..."
	@killall Xcode || true
	@echo "Cleaning other Xcode projects except $(PROJECT_TYPE)..."
	@if [ "$(PROJECT_TYPE)" = "HOME" ]; then \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoSignUpFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoIntroFeature.xcodeproj; \
	elif [ "$(PROJECT_TYPE)" = "SIGNUP" ]; then \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoHomeFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoIntroFeature.xcodeproj; \
	elif [ "$(PROJECT_TYPE)" = "INTRO" ]; then \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoHomeFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoSignUpFeature.xcodeproj; \
	fi
	@rm -rf $(TUIST_ROOT_DIR)/Projects/App/Derived
