.PHONY: generate GoalMate App

# make generate / intro / login / home / all 명령어 입력

# 기본 generate
generate:
	tuist generate
	
# Main과 Demos 생성
all:
	TUIST_TYPE=ALL tuist generate
	
# Intro 데모만 생성
intro:
	TUIST_TYPE=INTRO tuist generate

# Login 데모만 생성
login:
	TUIST_TYPE=LOGIN tuist generate

# Home 데모만 생성
home:
	TUIST_TYPE=HOME tuist generate
