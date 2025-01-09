//
//  RoundedButton.swift
//  Common
//
//  Created by 이재훈 on 1/7/25.
//

import SwiftUI

/**
 RoundedButtonStyle은 버튼의 스타일을 정의하는 프로토콜입니다.
 
 각 스타일은 자신만의 Background 뷰 타입을 가질 수 있습니다.
 */
public protocol RoundedButtonStyle {
    associatedtype Background: View
    func makeBackground() -> Background
}

/**
 BorderStyle
 
 테두리가 있는 버튼 스타일을 구현하는 구조체입니다.
 
 - **Parameters**:
 - borderConfig: 테두리의 색상과 두께 설정
 - backgroundColor: 버튼의 배경색
 ```swift
 BorderStyle(
    borderConfig: .init(color: .blue, width: 2),
    backgroundColor: .white
 )
 ```
 */
public struct BorderStyle: RoundedButtonStyle {
    private let backgroundColor: Color
    private let borderConfig: BorderConfig

    public struct BorderConfig {
        var color: Color
        var width: CGFloat

        init(color: Color, width: CGFloat) {
            self.color = color
            self.width = width
        }
    }

    public init(
        borderConfig: BorderConfig,
        backgroundColor: Color
    ) {
        self.borderConfig = borderConfig
        self.backgroundColor = backgroundColor
    }

    public func makeBackground() -> some View {
        Rectangle()
            .fill(backgroundColor)
            .overlay {
                Capsule()
                    .stroke(borderConfig.color, lineWidth: borderConfig.width)
            }
    }
}

/**
 FilledStyle

 단색으로 채워진 버튼 스타일을 구현하는 구조체입니다.

 - **Parameters**:
 - backgroundColor: 버튼을 채울 배경색
 ```swift
 FilledStyle(backgroundColor: .blue)
 ```
 */
public struct FilledStyle: RoundedButtonStyle {
    public let backgroundColor: Color

    public init(backgroundColor: Color) {
        self.backgroundColor = backgroundColor
    }

    public func makeBackground() -> some View {
        Rectangle()
            .fill(backgroundColor)
    }
}

/**
RoundedButton

커스터마이즈 가능한 둥근 모서리 버튼 컴포넌트입니다.

- **Parameters**:
  - buttonType: 버튼에 적용할 스타일 (FilledStyle 또는 BorderStyle)
  - buttonTapped: 버튼 탭 시 실행할 액션
  - label: 버튼 내부에 표시될 뷰
 
 ```swift
 RoundedButton(
    buttonType: FilledStyle(backgroundColor: .blue)
 ) {
    print("Tapped")
 } label: {
    Text("Button")
    .foregroundColor(.white)
 }
 ```
*/
public struct RoundedButton<Content: View, Style: RoundedButtonStyle>: View {
    let buttonType: Style
    let height: CGFloat
    @Binding var isDisabled: Bool
    let buttonTapped: () -> Void
    let label: Content

    public init(
        buttonType: Style = FilledStyle(backgroundColor: .primary),
        height: CGFloat = 54,
        isDisabled: Binding<Bool> = .constant(false),
        buttonTapped: @escaping () -> Void,
        @ViewBuilder label: () -> Content
    ) {
        self.buttonType = buttonType
        self.height = height
        self._isDisabled = isDisabled
        self.buttonTapped = buttonTapped
        self.label = label()
    }

    public var body: some View {
        Button {
            guard isDisabled == false else { return }
            buttonTapped()
        } label: {
            HStack {
                Spacer()
                label
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .background {
                if isDisabled == false {
                    buttonType.makeBackground()
                } else {
                    Rectangle()
                        .fill(Colors.gray300)
                }
            }
            .clipShape(.capsule)
            .frame(height: height)
        }
        .disabled(isDisabled)
    }
}

// MARK: - 버튼 작성 예시
@available(iOS 17.0, *)
#Preview {
    VStack {
        RoundedButton(
            buttonType: FilledStyle(backgroundColor: .primary),
            height: 54,
            isDisabled: .constant(true)
        ) {
            print("FilledStyle") // 액션 추가
        } label: {
            Text("hello")        // 라벨 추가
                .pretendard(.semiBold, size: 16, color: .white)
        }
        RoundedButton(
            buttonType: FilledStyle(backgroundColor: .primary),
            height: 54
        ) {
            print("FilledStyle") // 액션 추가
        } label: {
            Text("hello")        // 라벨 추가
                .pretendard(.semiBold, size: 16, color: .white)
        }
        RoundedButton(
            buttonType: BorderStyle(
                borderConfig: .init(color: .primary, width: 2),
                backgroundColor: .white
            ),
            height: 54
        ) {
            print("BorderStyle")
        } label: {
            Text("hello")
                .pretendard(.semiBold, size: 16, color: .primary)
        }

        HStack(spacing: 10) {
            RoundedButton(
                buttonType: FilledStyle(backgroundColor: .white),
                height: 48
            ) {
                print("FilledStyle") // 액션 추가
            } label: {
                Text("hello")        // 라벨 추가
                    .pretendard(.semiBold, size: 16, color: .black)
            }
            RoundedButton(
                buttonType: FilledStyle(backgroundColor: .primary),
                height: 48
            ) {
                print("FilledStyle") // 액션 추가
            } label: {
                Text("hello")        // 라벨 추가
                    .pretendard(.semiBold, size: 16, color: .white)
            }
        }
    }
    .padding(10)
}
