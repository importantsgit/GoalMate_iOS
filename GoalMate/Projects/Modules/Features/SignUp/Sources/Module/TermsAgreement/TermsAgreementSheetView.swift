//
//  TermsAgreementSheetView.swift
//  FeatureSignUp
//
//  Created by Importants on 2/7/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI
import Utils

public struct TermsAgreementSheetView: View {
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Perception.Bindable var store: StoreOf<TermsAgreementFeature>
    public init(store: StoreOf<TermsAgreementFeature>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 36)
                    .overlay {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Colors.grey300)
                            .frame(width: 32, height: 4)
                    }
                Spacer()
                    .frame(height: 16)
                Text("골메이트를 시작하려면\n약관 동의가 필요해요")
                    .pretendardStyle(.medium, size: 18)
                Spacer()
                    .frame(height: 28)
                Button {
                    store.send(.view(.allAgreeButtonTapped))
                } label: {
                    HStack(spacing: 8) {
                        Rectangle()
                            .frame(width: 24, height: 24)
                            .tint(store.isAllTermsAgreed ?
                                    Colors.primary :
                                    Colors.grey200
                            )
                            .clipShape(.rect(cornerRadius: 4))
                            .frame(width: 28, height: 28)
                            .overlay {
                                if store.isAllTermsAgreed {
                                    Images.check
                                        .resized(length: 16)
                                }
                            }
                        Text("모두 동의합니다.")
                            .pretendardStyle(.regular, size: 16)
                    }
                }
                Spacer()
                    .frame(height: 16)
                VStack(spacing: 8) {
                    AgreementRowView(
                        title: "이용약관에 동의합니다. (필수)",
                        isChecked: store.isServiceTermsAgreed,
                        onToggle: {
                            store.send(.view(.termsOfServiceButtonTapped))
                        },
                        onLinkTap: {
                            store.send(.view(.openTermsOfServiceView))
                        }
                    )
                    AgreementRowView(
                        title: "개인정보 처리 방침에 동의합니다. (필수)",
                        isChecked: store.isPrivacyPolicyAgreed,
                        onToggle: {
                            store.send(.view(.privacyPolicyAgreeButtonTapped))
                        },
                        onLinkTap: {
                            store.send(.view(.openPrivacyPolicyAgreeView))
                        }
                    )
                    AgreementRowView(
                        title: "만 14세 이상입니다. (필수)",
                        isChecked: store.isAtLeastFourteenYearsOld,
                        onToggle: {
                            store.send(.view(.ageVerificationButtonTapped))
                        },
                        onLinkTap: nil
                    )
                }
                Spacer()
                RoundedButton(
                    buttonType: FilledStyle(backgroundColor: Colors.primary),
                    height: 54,
                    isDisabled: store.isAllTermsAgreed == false
                ) {
                    store.send(.view((.startButtonTapped)))
                } label: {
                    Text("목표 시작하기")
                        .pretendard(
                            .semiBold,
                            size: 16,
                            color: store.isAllTermsAgreed ? .black : .white
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, safeAreaInsets.bottom)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    HStack {
        Spacer()
        Text("hello")
        Spacer()
    }
    .sheet(isPresented: .constant(true), onDismiss: nil) {
        TermsAgreementSheetView(
            store: Store(
                initialState: TermsAgreementFeature.State.init(),
                reducer: {
                    withDependencies {
                        $0.authClient = .previewValue
                        $0.environmentClient = .previewValue
                    } operation: {
                        TermsAgreementFeature()
                    }
                }
            )
        )
        .customSheet(heights: [389], radius: 30, corners: [.topLeft, .topRight])
    }
}

fileprivate struct AgreementRowView: View {
    let title: String
    let isChecked: Bool
    var onToggle: () -> Void
    var onLinkTap: (() -> Void)?
    var body: some View {
        HStack {
            Button {
                onToggle()
            } label: {
                HStack(spacing: 8) {
                    Images.check
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 16, height: 16)
                        .tint(isChecked ?
                                Colors.grey900 :
                                Colors.grey200)
                        .frame(width: 28, height: 28)
                    Text(title)
                        .pretendardStyle(.regular, size: 16)
                }
            }
            Spacer()
            if let onLinkTap {
                Button {
                    onLinkTap()
                } label: {
                    Image(systemName: "chevron.right")
                        .resized(length: 10)
                        .foregroundStyle(Colors.grey600)
                        .frame(width: 32, height: 32)
                }
            }
        }
    }
}
