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
    @Perception.Bindable var store: StoreOf<TermsAgreementFeature>
    // obseravable framework 알아야함
    // 선언해줄테니까 써라 16.0 이하 /
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
                            .fill(store.isAllTermsAgreed ?
                                    Colors.primary :
                                    Colors.grey200
                            )
                            .frame(width: 24, height: 24)
                            .clipShape(.rect(cornerRadius: 4))
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
                HStack {
                    Button {
                        store.send(.view(.termsOfServiceButtonTapped))
                    } label: {
                        HStack(spacing: 8) {
                            Images.check
                                .resizable()
                                .renderingMode(.template)
                                .tint(store.isServiceTermsAgreed ? Colors.grey900 : Colors.grey200)
                                .frame(width: 16, height: 16)
                            Text("이용약관에 동의합니다. (필수)")
                                .pretendardStyle(.regular, size: 16)
                        }
                    }
                    Spacer()
                    Button {
                        store.send(.view(.openTermsOfServiceView))
                    } label: {
                        Image(systemName: "chevron.right")
                            .resized(length: 10)
                            .foregroundStyle(Colors.grey600)
                    }
                }

                Spacer()
                    .frame(height: 8)
                HStack {
                    Button {
                        store.send(.view(.privacyPolicyAgreeButtonTapped))
                    } label: {
                        HStack(spacing: 8) {
                            Images.check
                                .resizable()
                                .renderingMode(.template)
                                .tint(store.isPrivacyPolicyAgreed ? Colors.grey900 : Colors.grey200)
                                .frame(width: 16, height: 16)
                            Text("개인정보 처리 방침에 동의합니다. (필수)")
                                .pretendardStyle(.regular, size: 16)
                        }
                    }
                    Spacer()
                    Button {
                        store.send(.view(.openPrivacyPolicyAgreeView))
                    } label: {
                        Image(systemName: "chevron.right")
                            .resized(length: 10)
                            .foregroundStyle(Colors.grey600)
                    }
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
                        $0.keyboardClient = .previewValue
                    } operation: {
                        TermsAgreementFeature()
                    }
                }
            )
        )
        .presentationDetents([.height(340)])
        .presentationCornerRadius(30)
    }
}
