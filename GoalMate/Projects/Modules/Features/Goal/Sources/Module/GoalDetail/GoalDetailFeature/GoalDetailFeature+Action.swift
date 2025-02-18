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
            return .merge(
                .send(.feature(.checkLogin)),
                .send(.feature(.fetchDetail))
            )
            .cancellable(id: CancelID.initialLoad)
        }
    }
    // MARK: View
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
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
        case .backButtonTapped:
            return .cancel(id: CancelID.initialLoad)
        case .startButtonTapped:
            guard let content = state.content
            else { return .none }
            return
                .concatenate(
                    .cancel(id: CancelID.initialLoad),
                    .send(.feature(.showPurchaseSheet(content)))
                )
        case .popupButtonTapped:
            state.isShowUnavailablePopup = false
            return .none
        default: return .none
        }
    }
    // MARK: Feature
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .checkLogin:
            return .run { send in
                do {
                    let loginState = try await authClient.checkLoginStatus()
                    await send(.feature(.checkLoginResponss(loginState)))
                } catch {
                    await send(.feature(.checkLoginResponss(false)))
                }

            }
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
        case let .checkLoginResponss(isLogin):
            state.isLogin = isLogin
            return .none
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
}
