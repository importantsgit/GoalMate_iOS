//
//  MyGoalListView.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI
import Utils

public struct MyGoalListView: View {
    @State var store: StoreOf<MyGoalListFeature>
    public init(store: StoreOf<MyGoalListFeature>) {
        self.store = store
    }
    public var body: some View {
        VStack {
            NavigationBar(
                leftContent: {
                    Images.logoSub
                        .resized(size: .init(width: 84, height: 32))
                }
            )
            List {
                ForEach(store.myGoalList, id: \.id) { content in
                    WithPerceptionTracking {
                        MyGoalContentItem(content: content)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .listStyle(.plain)
            .background(Color.clear)
            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal, 20)
        .onAppear {
            // store.send(.onAppear)
        }
    }
}

fileprivate struct MyGoalContentItem: View {
    let content: MyGoalContent
    init(content: MyGoalContent) {
        self.content = content
    }
    var body: some View {
        let isExpired = content.isExpired
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 24)
            HStack(spacing: 4) {
                Text(isExpired ? "진행완료" : "진행중")
                    .pretendardStyle(
                        .medium,
                        size: 13,
                        color: isExpired ? Colors.grey500 : Colors.grey900
                    )
                Text(isExpired ? "done" : "D+\(calculateDplus(fromDate: content.startDate))")
                    .pretendardStyle(
                        .semiBold,
                        size: 12,
                        color: isExpired ? .white : Colors.grey800
                    )
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(isExpired ? Colors.secondaryP : Colors.secondaryY)
                    .clipShape(.rect(cornerRadius: 4))
                Spacer()
            }
            Spacer()
                .frame(height: 14)
            HStack(spacing: 10) {
                CachedImageView(url: content.imageURL)
                    .frame(width: 120, height: 90)
                    .overlay {
                        if isExpired {
                            ZStack {
                                Colors.grey200.opacity(0.5)
                                Images.goalCompleted
                            }
                        }
                    }
                    .clipShape(.rect(cornerRadius: 4))
                VStack(alignment: .leading) {
                    Text("다온과 함께하는 영어 완전 정복 30일 목표".splitCharacters())
                        .pretendard(.medium, size: 16, color: isExpired ? Colors.grey500 : Colors.grey900)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    HStack(alignment: .top, spacing: 10) {
                        if isExpired {
                            Images.calendarCompleted
                                .resized(length: 16)
                        }
                        else {
                            Images.calendarP
                                .resized(length: 16)
                        }
                        Text("\(content.startDate.getString()) 부터\n\(content.endDate.getString()) 까지")
                            .pretendard(.medium, size: 11, color: isExpired ? Colors.grey500 : Colors.grey600)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Colors.grey50)
                    .clipShape(.rect(cornerRadius: 6))
                }
            }
            Spacer()
                .frame(height: 16)
            HStack(alignment: .top, spacing: 6) {
                HStack(spacing: 0) {
                    Text("전체 진척율")
                        .pretendardStyle(.semiBold, size: 13, color: Colors.grey500)
                    if isExpired {
                        Images.flag
                            .resized(length: 16)
                    } else {
                        Images.progress
                            .resized(length: 16)
                    }
                }
                LinearProgressView(
                    progress: .constant(content.progress),
                    progressColor: isExpired ? Colors.grey400 : Colors.primary,
                    backgroundColor: isExpired ? Colors.grey100 : Colors.primary50,
                    lineWidth: 14
                )
            }
            Spacer()
                .frame(height: 16)
            if isExpired {
                HStack(spacing: 12) {
                    RoundedButton(
                        buttonType: BorderStyle(
                            borderConfig: .init(
                                color: Colors.grey300,
                                width: 2
                            ),
                            backgroundColor: .white
                        ),
                        height: 44,
                        buttonTapped: {},
                        label: {
                            Text("진행하기")
                                .pretendardStyle(.regular, size: 16)
                        }
                    )
                    RoundedButton(
                        buttonType: FilledStyle(backgroundColor: Colors.primary),
                        height: 44,
                        buttonTapped: {},
                        label: {
                            Text("진행하기")
                                .pretendardStyle(.regular, size: 16)
                        }
                    )
                }
            }
            else {
                RoundedButton(
                    buttonType: FilledStyle(backgroundColor: Colors.primary),
                    height: 44,
                    buttonTapped: {},
                    label: {
                        Text("진행하기")
                            .pretendardStyle(.regular, size: 16)
                    }
                )
            }

            Spacer()
                .frame(height: 30)
            Rectangle()
                .fill(Colors.grey50)
                .frame(height: 16)
        }
    }
    
    func calculateDplus(fromDate: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let startDate = calendar.startOfDay(for: fromDate)
        
        let components = calendar.dateComponents([.day], from: startDate, to: currentDate)
        return components.day ?? 0
    }
}

@available(iOS 17.0, *)
#Preview {
    MyGoalListView(
        store: .init(
            initialState: .init(
                myGoalList: MyGoalContent.dummies
            )
        ) {
            MyGoalListFeature()
        }
    )
}
