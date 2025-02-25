//
//  TabCoordinatorView.swift
//  FeatureHome
//
//  Created by Importants on 2/26/25.
//

import ComposableArchitecture
import FeatureComment
import FeatureCommon
import FeatureGoal
import FeatureMyGoal
import FeatureProfile
import SwiftUI
import TCACoordinators

public struct TabCoordinatorView: View {
    @Perception.Bindable var store: StoreOf<TabCoordinator>
    public init(store: StoreOf<TabCoordinator>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                TabView(
                    selection: $store.selectedTab
                ) {
                    GoalCoordinatorView(
                        store: store.scope(
                            state: \.goal,
                            action: \.goal
                        )
                    )
                    .tag(TabCoordinator.Tab.goal)
                    MyGoalCoordinatorView(
                        store: store.scope(
                            state: \.myGoal,
                            action: \.myGoal
                        )
                    )
                    .tag(TabCoordinator.Tab.myGoal)
                    CommentCoordinatorView(
                        store: store.scope(
                            state: \.comment,
                            action: \.comment
                        )
                    )
                    .tag(TabCoordinator.Tab.comment)
                    ProfileCoordinatorView(
                        store: store.scope(
                            state: \.profile,
                            action: \.profile
                        )
                    )
                    .tag(TabCoordinator.Tab.profile)
                }
                .toolbar(.hidden, for: .tabBar)  // 기본 탭바 숨기기
                if store.isTabVisible {
                    VStack {
                        Spacer()
                        CustomTabBar(selectedTab: $store.selectedTab)
                            .onAppear {
                                store.send(.viewCycling(.onAppear))
                            }
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
                }
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabCoordinator.Tab
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(TabCoordinator.Tab.allCases, id: \.self) { tab in
                    tabButton(tab)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 32)
            .padding(.horizontal, 20)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
//        .overlay {
//            Rectangle()
//                .stroke(Colors.grey200, lineWidth: 1)
//                .cornerRadius(24, corners: [.topLeft, .bottomRight])
//        }
//        .shadow(color: .black.opacity(0.05), radius: 8, y: -4)
    }
    @ViewBuilder
    private func tabButton(_ tab: TabCoordinator.Tab) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Group {
                    switch tab {
                    case .goal:
                        selectedTab == tab ?
                            Images.homeSelected.resized(length: 24) :
                            Images.home.resized(length: 24)
                    case .myGoal:
                        selectedTab == tab ?
                            Images.goalSeleceted.resized(length: 24) :
                            Images.goal.resized(length: 24)
                    case .comment:
                        selectedTab == tab ?
                            Images.commentSelected.resized(length: 24) :
                            Images.comment.resized(length: 24)
                    case .profile:
                        selectedTab == tab ?
                            Images.profileSelected.resized(length: 24) :
                            Images.profile.resized(length: 24)
                    }
                }
                Text(tab.title)
                    .pretendard(
                        selectedTab == tab ? .semiBold : .regular,
                        size: 12,
                        color: selectedTab == tab ? Colors.grey800 : Colors.grey400
                    )
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// Tab에 title 추가
extension TabCoordinator.Tab {
    static var allCases: [TabCoordinator.Tab] {
        [.goal, .myGoal, .comment, .profile]
    }
    var title: String {
        switch self {
        case .goal:
            return "홈"
        case .myGoal:
            return "목표"
        case .comment:
            return "코멘트"
        case .profile:
            return "마이"
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
