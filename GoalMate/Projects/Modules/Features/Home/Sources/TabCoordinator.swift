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
        public var selectedTab: Tab
        public var goal: GoalCoordinator.State
        public var myGoal: MyGoalCoordinator.State
        public init(
            selectedTab: Tab = .goal,
            goal: GoalCoordinator.State = .init(),
            myGoal: MyGoalCoordinator.State = .init()
        ) {
            self.selectedTab = selectedTab
            self.goal = goal
            self.myGoal = myGoal
        }
    }
    public enum Action: BindableAction {
        case selectedTabChanged(Tab)
        case goal(GoalCoordinator.Action)
        case myGoal(MyGoalCoordinator.Action)
        case binding(BindingAction<State>)
    }
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .selectedTabChanged(tab):
                state.selectedTab = tab
                return .none
            case .goal, .myGoal:
                return .none
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
    }
}

public struct TabCoordinatorView: View {
    @Perception.Bindable var store: StoreOf<TabCoordinator>
    public init(store: StoreOf<TabCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TabView(
            selection: $store.selectedTab.sending(\.selectedTabChanged)
        ) {
            WithPerceptionTracking {
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
                
                MyGoalCoordinatorView(
                    store: store.scope(
                        state: \.myGoal,
                        action: \.myGoal
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
        }
        .tint(Colors.grey800)
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
