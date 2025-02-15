//
//  TabCoordinator.swift
//  FeatureHome
//
//  Created by Importants on 1/20/25.
//

import ComposableArchitecture
import FeatureCommon
import FeatureGoal
import FeatureMyGoal
import FeatureProfile
import SwiftUI
import TCACoordinators

@Reducer
public struct TabCoordinator {
    public init() {}
    public enum Tab: Equatable {
        case goal
        case myGoal
        case profile
    }
    @ObservableState
    public struct State: Equatable {
        public var id: UUID
        public var selectedTab: Tab
        public var goal: GoalCoordinator.State
        public var myGoal: MyGoalCoordinator.State
        public var profile: ProfileCoordinator.State
        public init(
            selectedTab: Tab = .goal,
            goal: GoalCoordinator.State = .init(),
            myGoal: MyGoalCoordinator.State = .init(),
            profile: ProfileCoordinator.State = .init()
        ) {
            self.id = UUID()
            self.selectedTab = selectedTab
            self.goal = goal
            self.myGoal = myGoal
            self.profile = profile
        }
    }
    public enum Action: BindableAction {
        case goal(GoalCoordinator.Action)
        case myGoal(MyGoalCoordinator.Action)
        case profile(ProfileCoordinator.Action)
        case coordinator(CoordinatorAction)
        case binding(BindingAction<State>)
    }
    public enum CoordinatorAction {
        case showLogin
    }
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .coordinator(action):
                return reduce(into: &state, action: action)
            case let .goal(action):
                return reduce(into: &state, action: action)
            case let .myGoal(action):
                return reduce(into: &state, action: action)
            case .profile:
                return reduce(into: &state, action: action)
            case .binding:
                return .none
            }
        }
        Scope(state: \.goal, action: \.goal) {
            GoalCoordinator()
        }
        Scope(state: \.myGoal, action: \.myGoal) {
            MyGoalCoordinator()
        }
        Scope(state: \.profile, action: \.profile) {
            ProfileCoordinator()
        }
    }
}

public struct TabCoordinatorView: View {
    @State var store: StoreOf<TabCoordinator>
    public init(store: StoreOf<TabCoordinator>) {
        self.store = store
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    public var body: some View {
        WithPerceptionTracking {
            TabView(
                selection: $store.selectedTab
            ) {
                GoalCoordinatorView(
                    store: store.scope(
                        state: \.goal,
                        action: \.goal
                    )
                )
                .tabItem {
                    Label {
                        Text("홈")
                            .pretendard(
                                .regular,
                                size: 12
                            )
                    } icon: {
                        store.selectedTab == .goal ?
                        Images.homeSelected :
                        Images.home
                    }
                }
                .tag(TabCoordinator.Tab.goal)
                MyGoalCoordinatorView(
                    store: store.scope(
                        state: \.myGoal,
                        action: \.myGoal
                    )
                )
                .tabItem {
                    Label {
                        Text("목표")
                    } icon: {
                        store.selectedTab == .myGoal ?
                        Images.goalSeleceted :
                        Images.goal
                    }
                }
                .tag(TabCoordinator.Tab.myGoal)
                ProfileCoordinatorView(
                    store: store.scope(
                        state: \.profile,
                        action: \.profile
                    )
                )
                .tabItem {
                    Label {
                        Text("마이")
                    } icon: {
                        store.selectedTab == .profile ?
                        Images.profileSelected :
                        Images.profile
                    }
                }
                .tag(TabCoordinator.Tab.profile)
            }
            .tint(Colors.grey800)
        }
    }
}

#Preview {
    TabCoordinatorView(
        store: .init(
            initialState: TabCoordinator.State.init()
        ) {
            TabCoordinator()
        }
    )
}
