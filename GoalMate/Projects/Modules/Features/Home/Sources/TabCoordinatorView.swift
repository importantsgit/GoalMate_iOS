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
                        CustomTabBar(
                            selectedTab: $store
                                .selectedTab.sending(\.tabbarButtonTapped),
                            hasRemainingTodos: store.hasRemainingTodos,
                            newCommentsCount: store.newCommentsCount
                        )
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
    var hasRemainingTodos: Bool
    var newCommentsCount: Int
    init(
        selectedTab: Binding<TabCoordinator.Tab>,
        hasRemainingTodos: Bool,
        newCommentsCount: Int
    ) {
        self._selectedTab = selectedTab
        self.hasRemainingTodos = hasRemainingTodos
        self.newCommentsCount = newCommentsCount
    }
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(TabCoordinator.Tab.allCases, id: \.self) { tab in
                    ZStack {
                        tabButton(tab, newCommentsCount)
                    }
                }
            }
            .overlay {
                if selectedTab != .myGoal && hasRemainingTodos {
                    GeometryReader { geometry in
                        let tabWidth = geometry.size.width / 4
                        VStack(spacing: 0) {
                            Text("오늘 해야 할 일 남았어요")
                                .pretendardStyle(
                                    .semiBold,
                                    size: 12,
                                    color: .white)
                                .frame(height: 12)
                                .padding(10)
                                .background(Colors.error)
                                .clipShape(.capsule)
                            createTrianglePath()
                                .fill(Colors.error)
                                .frame(width: 12, height: 6)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .offset(x: -(tabWidth/2), y: -44)
                    }
                    .frame(height: 38)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 32)
            .padding(.horizontal, 20)
            .background(Color.white)
        }
    }
    @ViewBuilder
    private func tabButton(
        _ tab: TabCoordinator.Tab,
        _ newCommentsCount: Int
    ) -> some View {
        Button {
            withAnimation(.spring(response: 0.2)) {
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
                        Group {
                            selectedTab == tab ?
                                Images.commentSelected.resized(length: 24) :
                                Images.comment.resized(length: 24)
                        }
                        .overlay {
                            if newCommentsCount > 0 {
                                Text("\(newCommentsCount)")
                                    .pretendardStyle(
                                        .regular,
                                        size: 12,
                                        color: .white
                                    )
                                    .frame(
                                        width: 14,
                                        height: 14)
                                    .background {
                                        Circle()
                                            .fill(Colors.error)
                                    }
                                    .offset(x: 10, y: -7)
                            }
                        }
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
    func createTrianglePath() -> Path {
        var path = Path()
        path.move(to: .init(x: 0, y: 0))
        path.addLine(to: .init(x: 6, y: 6))
        path.addLine(to: .init(x: 12, y: 0))
        path.closeSubpath()
        return path
    }
}

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
