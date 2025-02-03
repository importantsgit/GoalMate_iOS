.PHONY: clean generate generate-signup generate-home generate-intro

# export를 해야지 하위 Task도 해당 값을 사용 가능 > clean
export TUIST_ROOT_DIR := ${PWD}
# 조건부 할당으로 PROJECT_TYPE 값이 정의되어 있지 않다면 App으로 할당
PROJECT_TYPE ?= "APP"

# Generate 상위 Tasks
# $(MAKE)로 하위 Task로 변수 전달
# clean / generate 라는 두 개의 별도 프로세스를 실행함
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
	$(MAKE) TUIST_TYPE=PROFILE PROJECT_TYPE=PROFILE clean generate

# Graph 상위 Tasks
# : 뒤에 명령어를 쓴다면 해당 task가 실행하기 전에 해당 명령어를 사용하라는 뜻임
graph: clean
	TUIST_TYPE=${TUIST_TYPE} tuist graph

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

# 하위 Task (Target)
clean:
	@echo "Closing Xcode..."
	@killall Xcode || true
	@echo "Cleaning other Xcode projects except $(PROJECT_TYPE)..."
	@if [ "$(PROJECT_TYPE)" != "SIGNUP" ]; then \
		echo "Cleaning SIGNUP"; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoSignUpFeature.xcodeproj; \
	fi
	@if [ "$(PROJECT_TYPE)" != "INTRO" ]; then \
		echo "Cleaning INTRO"; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoIntroFeature.xcodeproj; \
	fi
	@if [ "$(PROJECT_TYPE)" != "HOME" ]; then \
		echo "Cleaning HOME"; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoHomeFeature.xcodeproj; \
	fi
	@if [ "$(PROJECT_TYPE)" != "GOAL" ]; then \
		echo "Cleaning GOAL"; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoGoalFeature.xcodeproj; \
	fi
	@if [ "$(PROJECT_TYPE)" != "MYGOAL" ]; then \
		echo "Cleaning MYGOAL"; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoMyGoalFeature.xcodeproj; \
	fi
	@if [ "$(PROJECT_TYPE)" != "PROFILE" ]; then \
		echo "Cleaning PROFILE"; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/DemoProfileFeature.xcodeproj; \
	fi
	@if [ "$(PROJECT_TYPE)" != "APP" ]; then \
		echo "Cleaning PROFILE"; \
		rm -rf $(TUIST_ROOT_DIR)/Projects/App/App.xcodeproj; \
	fi
	@rm -rf $(TUIST_ROOT_DIR)/Projects/App/Derived

generate: clean
	TUIST_ROOT_DIR=${PWD} TUIST_TYPE=${TUIST_TYPE} tuist generate
