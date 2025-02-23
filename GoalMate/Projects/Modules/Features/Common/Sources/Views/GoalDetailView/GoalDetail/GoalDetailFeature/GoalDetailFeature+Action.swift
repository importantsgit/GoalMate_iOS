//
//  GoalDetailFeature+Action.swift
//  FeatureGoal
//
//  Created by Importants on 2/16/25.
//

import ComposableArchitecture
import Data
import Foundation

extension GoalDetailFeature {
    enum CancelID: Hashable {
        case initialLoad
    }
    // MARK: ViewCycling
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
            return .run { send in
                await send(
                    .feature(.checkLogin(try await authClient.checkLoginStatus()))
                )
            }
        }
    }
    // MARK: View
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .loginButtonTapped:
            return .send(.delegate(.showLogin))
        case .retryButtonTapped:
            state.didFailToLoad = false
            state.isLoading = true
            return .run { [contentId = state.contentId ] send in
                do {
                    let content = try await goalClient.fetchGoalDetail(goalId: contentId)
                    let today = Date()
                    let endDate = Calendar.current.date(
                        byAdding: .day, value: content.period ?? 0, to: today
                    ) ?? today
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
                    let maxOccupancy = content.participantsLimit ?? 0
                    let currentParticipants = content.currentParticipants ?? 0
                    let weeklyObjectives = content.weeklyObjectives
                        .sorted { ($0.weekNumber ?? 0) < ($1.weekNumber ?? 0) }
                    let milestoneObjectives = content.midObjectives
                        .sorted { ($0.number ?? 0) < ($1.number ?? 0) }
                    let result: GoalContentDetail = .init(
                        id: content.id,
                        details: .init(
                            title: content.title ?? "",
                            goalSubject: content.topic ?? "",
                            mentor: content.mentorName ?? "",
                            period: "\(content.period ?? 0)",
                            startDate: dateFormatter.string(from: today),
                            endDate: dateFormatter.string(from: endDate),
                            goalDescription: "\"\(content.description ?? "")\"",
                            weeklyGoal: weeklyObjectives.map {
                                $0.description ?? ""
                            },
                            milestoneGoal: milestoneObjectives.map {
                                $0.description ?? ""
                            }
                        ),
                        discountPercentage: 0,
                        originalPrice: 0,
                        discountedPrice: 0,
                        maxOccupancy: maxOccupancy,
                        remainingCapacity: maxOccupancy - currentParticipants,
                        currentParticipants: currentParticipants,
                        thumbnailImages: content.thumbnailImages.compactMap { $0.imageUrl },
                        contentImages: content.contentImages.compactMap { $0.imageUrl }
                    )
                    await send(.feature(.checkFetchDetailResponse(.success(result))))
                } catch {
                    await send(
                        .feature(.checkFetchDetailResponse(.failure(FetchError.networkError)))
                    )
                }
            }
        case .backButtonTapped:
            return .send(.delegate(.closeView))
        case .startButtonTapped:
            guard let content = state.content
            else { return .none }
            return
                .concatenate(
                    .cancel(id: CancelID.initialLoad),
                    .send(.delegate(.showPurchaseSheet(content)))
                )
        case .popupButtonTapped:
            state.isShowUnavailablePopup = false
            return .none
        }
    }
    // MARK: Feature
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case let .checkLogin(isLogin):
            state.isLogin = isLogin
            return .send(.feature(.fetchDetail))
        case .fetchDetail:
            return .run { [contentId = state.contentId] send in
                do {
                    let content = try await goalClient.fetchGoalDetail(goalId: contentId)
                    let today = Date()
                    let endDate = Calendar.current.date(
                        byAdding: .day, value: content.period ?? 0, to: today
                    ) ?? today
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
                    let maxOccupancy = content.participantsLimit ?? 0
                    let currentParticipants = content.currentParticipants ?? 0
                    let result: GoalContentDetail = .init(
                        id: content.id,
                        details: .init(
                            title: content.title ?? "",
                            goalSubject: content.topic ?? "",
                            mentor: content.mentorName ?? "",
                            period: "\(content.period ?? 0)",
                            startDate: dateFormatter.string(from: today),
                            endDate: dateFormatter.string(from: endDate),
                            goalDescription: "\"\(content.description ?? "")\"",
                            weeklyGoal: content.weeklyObjectives.map {
                                $0.description ?? ""
                            },
                            milestoneGoal: content.midObjectives.map {
                                $0.description ?? ""
                            }
                        ),
                        discountPercentage: 0,
                        originalPrice: 0,
                        discountedPrice: 0,
                        maxOccupancy: maxOccupancy,
                        remainingCapacity: maxOccupancy - currentParticipants,
                        currentParticipants: currentParticipants,
                        thumbnailImages: content.thumbnailImages.compactMap { $0.imageUrl },
                        contentImages: content.contentImages.compactMap { $0.imageUrl }
                    )
                    await send(.feature(.checkFetchDetailResponse(.success(result))))
                } catch {
                    await send(
                        .feature(.checkFetchDetailResponse(.failure(FetchError.networkError)))
                    )
                }
            }
        case let .checkFetchDetailResponse(result):
            switch result {
            case let .success(detail):
                state.content = detail
                state.isLoading = false
            case let .failure(error):
                state.isLoading = true
                state.didFailToLoad = true
            }
            return .none
        case let .showToast(message):
            state.toastState = .display(message)
            return .none
        default: return .none
        }
    }
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
