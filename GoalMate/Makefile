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
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoGoalFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoMyGoalFeature.xcodeproj; \
	elif [ "$(PROJECT_TYPE)" = "MYGOAL" ]; then \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoHomeFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoSignUpFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoIntroFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoGoalFeature.xcodeproj; \
	elif [ "$(PROJECT_TYPE)" = "GOAL" ]; then \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoHomeFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoSignUpFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoIntroFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoMyGoalFeature.xcodeproj; \
	elif [ "$(PROJECT_TYPE)" = "PROFILE" ]; then \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoHomeFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoSignUpFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoIntroFeature.xcodeproj; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoMyGoalFeature.xcodeproj; \
	fi
	rm -rf $(TUIST_ROOT_DIR)/Projects/App/Derived

# Generate 명령어들
generate:
	TUIST_ROOT_DIR=${PWD} TUIST_TYPE=${TUIST_TYPE} tuist generate

generate-signup:
	$(MAKE) TUIST_TYPE=SIGNUP PROJECT_TYPE=SIGNUP clean generate
	
generate-intro:
	$(MAKE) TUIST_TYPE=INTRO PROJECT_TYPE=INTRO clean generate

generate-home:
	$(MAKE) TUIST_TYPE=HOME PROJECT_TYPE=HOME clean generate

generate-goal:
	$(MAKE) TUIST_TYPE=GOAL PROJECT_TYPE=GOAL clean generate

generate-mygoal:
	$(MAKE) TUIST_TYPE=MYGOAL PROJECT_TYPE=MYGOAL clean generate
	
generate-profile:
	$(MAKE) TUIST_TYPE=MYGOAL PROJECT_TYPE=PROFILE clean generate

# Graph 명령어들
graph: clean
	TUIST_ROOT_DIR=${PWD} TUIST_TYPE=${TUIST_TYPE} tuist graph

graph-signup:
	$(MAKE) TUIST_TYPE=SIGNUP PROJECT_TYPE=SIGNUP graph

graph-intro:
	$(MAKE) TUIST_TYPE=INTRO PROJECT_TYPE=INTRO graph

graph-home:
	$(MAKE) TUIST_TYPE=HOME PROJECT_TYPE=HOME graph

graph-goal:
	$(MAKE) TUIST_TYPE=GOAL PROJECT_TYPE=GOAL graph

graph-mygoal:
	$(MAKE) TUIST_TYPE=MYGOAL PROJECT_TYPE=MYGOAL graph

graph-profile:
	$(MAKE) TUIST_TYPE=PROFILE PROJECT_TYPE=PROFILE graph
