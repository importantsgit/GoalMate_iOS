.PHONY: generate graph intro login home all

# Generate 명령어들
generate:
	TUIST_ROOT_DIR=${PWD} tuist generate

generate-all:
	TUIST_ROOT_DIR=${PWD} TUIST_TYPE=ALL tuist generate

generate-intro:
	TUIST_ROOT_DIR=${PWD} TUIST_TYPE=INTRO tuist generate

generate-login:
	TUIST_ROOT_DIR=${PWD} TUIST_TYPE=LOGIN tuist generate

generate-home:
	TUIST_ROOT_DIR=${PWD} TUIST_TYPE=HOME tuist generate

# Graph 명령어들
graph-all:
	TUIST_TYPE=ALL tuist graph

graph-intro:
	TUIST_TYPE=INTRO tuist graph

graph-login:
	TUIST_TYPE=LOGIN tuist graph

graph-home:
	TUIST_TYPE=HOME tuist graph
