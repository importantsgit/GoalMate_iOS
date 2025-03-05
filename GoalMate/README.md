# Tuist 사용 법

## 개요

이 프로젝트는 `Tuist`를 사용하여 모듈화된 Xcode 프로젝트를 생성하고 관리. 아래 명령어로 원하는 기능을 빌드하거나 그래프를 확인할 수 있음.

## 사전 요구 사항

- macOS 환경
- Xcode 설치
- [Mise](https://mise.jdx.dev/) 설치

## Tuist 설치 방법

Tuist는 `mise`를 사용하여 설치함. 아래 명령어 중 하나를 실행:
```sh
mise install tuist            # .tool-versions/.mise.toml에 지정된 버전 설치
mise install tuist@x.y.z      # 특정 버전 설치
mise install tuist@3          # 대략적인 버전(메이저 버전) 설치
```
설치 후 `mise use` 명령어로 Tuist 버전 활성화 필요:
```sh
mise use tuist@x.y.z          # 현재 프로젝트에서 tuist-x.y.z 사용
mise use tuist@latest         # 현재 디렉터리에서 최신 Tuist 사용
mise use -g tuist@x.y.z       # 글로벌 기본값으로 tuist-x.y.z 사용
mise use -g tuist@system      # 시스템의 Tuist를 글로벌 기본값으로 사용
```

## 실행 방법

### 프로젝트 생성

Tuist를 사용하여 프로젝트를 생성하려면:
```sh
make generate
```
또는 특정 모듈만 생성하려면:
```sh
make generate-<module>
```
예를 들어, `signup` 모듈을 생성하려면:
```sh
make generate-signup
```

⚠️ `tuist generate`는 빌드되지 않으므로 주의.

### 프로젝트 그래프 확인

Tuist의 그래프 기능을 사용하여 프로젝트 의존성을 확인하려면:
```sh
make graph
```
또는 특정 모듈의 그래프를 확인하려면:
```sh
make graph-<module>
```
예를 들어, `home` 모듈의 그래프를 확인하려면:
```sh
make graph-home
```

### 프로젝트 정리

Xcode 프로젝트 파일을 정리하고 필요 없는 빌드 파일을 삭제하려면:
```sh
make clean
```

## 환경 변수 설정

환경 변수를 설정하려면 `Goalmate > SupportFiles > XCConfigs` 경로에 있는 `Base.xcconfig` 파일을 추가해야 함. 해당 파일이 필요하면 **임폴턴트에게 요청할 것.**

## 모듈 리스트

현재 지원하는 모듈:
- `signup`
- `intro`
- `home`
- `goal`
- `mygoal`
- `profile`
- `comment`

각 모듈은 `make generate-<module>` 또는 `make graph-<module>` 명령어로 개별적으로 관리 가능.

## 참고 사항

- `make generate` 실행 시 `clean` 작업이 자동 실행되므로 별도로 `make clean`을 실행할 필요 없음.
- 프로젝트 실행 중 Xcode가 열려 있으면 종료될 수 있음.
- 프로젝트 루트 디렉터리는 `TUIST_ROOT_DIR` 환경 변수로 설정됨.
- `PROJECT_TYPE` 값이 명시되지 않으면 기본적으로 `APP`으로 설정됨.
