//
//  SignUpFeature.swift
//  SignUp
//
//  Created by Importants on 1/6/25.
//

import ComposableArchitecture
import Data
import Dependencies
import Utils

@Reducer
public struct SignUpFeature {
    public enum SignUpProvider {
        case apple
        case kakao
    }
    @ObservableState
    public struct State: Equatable {
        var isLoading: Bool
        public init(
            isLoading: Bool = false
        ) {
            self.isLoading = isLoading
        }
    }
    public enum Action: BindableAction {
        case signUpButtonTapped(SignUpProvider)
        case signUpSucceeded
        case signUpFailed
        case binding(BindingAction<State>)
    }
    @Dependency(\.authClient) var authClient
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .signUpButtonTapped(provider):
                state.isLoading = true
                return .run { [provider] send in
                    do {
                        let result = try await (
                            provider == .apple ?
                                authClient.appleLogin() :
                                authClient.kakaoLogin()
                        )
                        print(result)
                        let tokens = try await authClient.authenticate(
                            response: result,
                            type: provider == .apple ? .apple : .kakao
                        )
                        print(tokens)
                        await send(.signUpSucceeded)
                    } catch let error as LoginError {
                        print("Error(LoginError): \(error.localizedDescription)")
                        await send(.signUpFailed)
                    } catch let error as NetworkError {
                        print("Error(NetworkError): \(error.localizedDescription)")
                        print(error.localizedDescription)
                        await send(.signUpFailed)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            case .signUpSucceeded:
                state.isLoading = false
                return .none
            case .signUpFailed:
                state.isLoading = false
                return .none
            case .binding(_):
                return .none
            }
        }
        BindingReducer()
    }
}
