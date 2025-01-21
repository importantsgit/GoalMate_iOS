//
//  SignUpProcessView.swift
//  SignUp
//
//  Created by 이재훈 on 1/7/25.
//

import FeatureCommon
import SwiftUI

internal struct SignUpProcessView: View {
    enum ProcessType {
        case signUp
        case nickname
        case complete
    }
    var processType: ProcessType

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(processType == .signUp ? Colors.grey200 : Colors.primary100)
                        .frame(height: 8)
                    Rectangle()
                        .fill(processType == .complete ? Colors.primary100 : Colors.grey200)
                        .frame(height: 8)
                }
                .padding(.horizontal, 12)
                HStack {
                    CircleView(
                        type: processType == .signUp ? .current : .complete,
                        config: .init(subTitle: "회원가입", number: 1)
                    )
                    Spacer()
                    CircleView(
                        type: processType == .signUp ? .pending :
                               processType == .nickname ? .current : .complete,
                        config: .init(subTitle: "닉네임 설정", number: 2)
                    )
                    Spacer()
                    CircleView(
                        type: processType == .complete ? .current : .pending,
                        config: .init(subTitle: "시작하기", number: 3)
                    )
                }
            }
        }
        .padding(.horizontal, 8)
        .frame(width: 190)
    }
}

fileprivate struct CircleView: View {
    enum CircleType {
        case complete   // 완료
        case current    // 진행중
        case pending    // 대기
    }

    public struct Config {
        let subTitle: String
        let number: Int
    }

    let type: CircleType
    let config: Config

    public init(
        type: CircleType,
        config: Config
    ) {
        self.type = type
        self.config = config
    }

    public var body: some View {
        switch type {
        case .complete:
            Images.check
                .resized(length: 12)
                .background {
                    Circle()
                        .fill(Colors.primary100)
                        .frame(width: 25, height: 25)
                }
                .frame(width: 25, height: 25)
        case .current:
            Text("\(config.number)")
                .pretendard(.semiBold, size: 14, color: Colors.grey900)
                .background {
                    Circle()
                        .fill(Colors.primary)
                        .frame(width: 25, height: 25)
                }
                .frame(width: 25, height: 25)
                .overlay {
                    Text(config.subTitle)
                        .pretendard(.regular, size: 12, color: Colors.grey600)
                        .frame(width: 100)
                        .offset(x: 0, y: 24)
                }
        case .pending:
            Text("\(config.number)")
                .pretendard(.semiBold, size: 14, color: Colors.grey400)
                .background(
                    Circle()
                        .stroke(Colors.grey300, lineWidth: 1)
                        .frame(width: 25, height: 25)
                        .background(.white)
                )
                .frame(width: 25, height: 25)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    VStack(spacing: 40) {
        SignUpProcessView(processType: .signUp)
            .frame(width: 175)
        SignUpProcessView(processType: .nickname)
            .frame(width: 175)
        SignUpProcessView(processType: .complete)
            .frame(width: 175)
        HStack {
            CircleView(type: .complete, config: .init(subTitle: "", number: 1))
            CircleView(type: .current, config: .init(subTitle: "", number: 2))
            CircleView(type: .pending, config: .init(subTitle: "", number: 3))
        }
    }
}
