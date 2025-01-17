.PHONY: clean generate generate-signup generate-home generate-intro

PROJECT_TYPE ?= "APP"

clean:
	echo "Closing Xcode..."
	killall Xcode || true
	echo "Cleaning other Xcode projects except $(PROJECT_TYPE)..."
	if [ "$(PROJECT_TYPE)" = "HOME" ]; then \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoSignUpFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoIntroFeature.xcodeproj; \
	elif [ "$(PROJECT_TYPE)" = "SIGNUP" ]; then \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoHomeFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoIntroFeature.xcodeproj; \
	elif [ "$(PROJECT_TYPE)" = "INTRO" ]; then \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoHomeFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoSignUpFeature.xcodeproj; \
	fi
	rm -rf $(TUIST_ROOT_DIR)/Projects/App/Derived

# Generate 명령어들
generate:
	TUIST_ROOT_DIR=${PWD} TUIST_TYPE=${TUIST_TYPE} tuist generate

generate-signup:
	$(MAKE) TUIST_TYPE=SIGNUP PROJECT_TYPE=SIGNUP clean generate

generate-home:
	$(MAKE) TUIST_TYPE=HOME PROJECT_TYPE=HOME clean generate

generate-intro:
	$(MAKE) TUIST_TYPE=INTRO PROJECT_TYPE=INTRO clean generate

# Graph 명령어들
graph: clean
	TUIST_ROOT_DIR=${PWD} TUIST_TYPE=${TUIST_TYPE} tuist graph

graph-signup:
	$(MAKE) TUIST_TYPE=SIGNUP PROJECT_TYPE=SIGNUP graph

graph-home:
	$(MAKE) TUIST_TYPE=HOME PROJECT_TYPE=HOME graph

graph-intro:
	$(MAKE) TUIST_TYPE=INTRO PROJECT_TYPE=INTRO graph
