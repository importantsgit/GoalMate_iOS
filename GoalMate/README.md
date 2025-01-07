
## 참고 링크 정리
### 상대 경로 지정
https://minsone.github.io/swift-relative-file-path

### Unit Test의 Host Application을 None
https://minsone.github.io/architecture-decision-record-module-unit-test-host-application-none

## Stencil 문법
// 조건문
{% if condition %}{% endif %}
{% if families %} ... {% endif %}  

// 반복문
{% for item in items %}{% endfor %}  
{% for family in families %}

// 변수 출력
{{ variable }}  
{{accessModifier}}

// 변수 설정
{% set variable %}value{% endset %}
{% set accessModifier %}{% if param.publicAccess %}public{% else %}internal{% endif %}{% endset %}

{% macro name %}{% endmacro %}  // 매크로 정의
{% macro transformPath path %}

{% filter filterName %}{% endfilter %}  // 필터 적용


accessModifier: 생성되는 코드의 접근 수준을 제어
타입 매크로들: 각 리소스 타입별 Swift 타입 이름 정의
forceNamespaces: 네임스페이스 구조 강제 여부
transformPath: 폰트 파일 경로 처리
casesBlock: 리소스 열거형 케이스 생성
allValuesBlock: 모든 리소스 값의 배열 생성
