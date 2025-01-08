//
//  SignUpSuccessFeature.swift
//  SignUp
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture

@Reducer
public struct SignUpSuccessFeature {
    @ObservableState
    public struct State: Equatable {
        var nickName: String = "임폴턴트"

        public init(nickName: String) {
            self.nickName = nickName
        }
    }
    public enum Action {
        case startButtonTapped
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .startButtonTapped:
                return .none
            }
        }
    }
}
