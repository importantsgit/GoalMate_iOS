//
//  MyGoalDetailView.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI

public struct MyGoalDetailView: View {
    @State var store: StoreOf<MyGoalDetailFeature>
    public init(store: StoreOf<MyGoalDetailFeature>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            //            YearMonthHeaderView(
            //                startDate: store.startDate,
            //                endDate: store.endDate,
            //                currentMonth: $store.currentMonth
            //            )
            //            HorizontalCalendarView(
            //                startDate: store.startDate,
            //                endDate: store.endDate,
            //                selectedDate: $store.selectedDate,
            //                currentMonth: $store.currentMonth
            //            )
            NavigationBar(
                leftContent: {
                    Button {
                        store.send(.backButtonTapped)
                    } label: {
                        Images.back
                            .resized(length: 24)
                            .frame(width: 48, height: 48)
                    }
                },
                centerContent: {
                    Text("다온과 함께하는 영어 완전 정복하기 Win")
                        .pretendard(.semiBold, size: 20, color: Colors.grey900)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(width: 300)
                }
            )
            ScrollView {
                Rectangle()
                    .fill(Colors.grey100)
                    .frame(height: 118)
                Spacer()
                    .frame(height: 44)
                VStack(spacing: 0) {
                    // 오늘 해야 할 일
                    VStack(spacing: 24) {
                        VStack(spacing: 15) {
                            HStack {
                                Text("오늘 해야 할 일")
                                    .pretendard(.semiBold, size: 16, color: Colors.grey900)
                                Spacer()
                                HStack(alignment: .bottom, spacing: 4) {
                                    Text("10:21:39")
                                        .pretendard(.semiBold, size: 14, color: Colors.grey700)
                                    Text("24h")
                                        .pretendard(.semiBold, size: 10, color: Colors.grey700)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Colors.grey50)
                                .clipShape(.rect(cornerRadius: 12))
                            }
                            SeparatorView(
                                height: 1,
                                color: Colors.grey100
                            )
                        }
                        VStack(spacing: 29) {
                            VStack(spacing: 16) {
                                let todo = [
                                    "영어 단어 외우기",
                                    "영어 문법 공부",
                                    "영어 듣기",
                                    "영어 단어 외우기",
                                    "영어 문법 공부",
                                    "영어 듣기"
                                ]
                                ForEach(todo, id: \.self) { content in
                                    Button {
                                    } label: {
                                        HStack(spacing: 10) {
                                            let isDone = Bool.random()
                                            Rectangle()
                                                .fill(isDone ? Colors.primary : Colors.grey200)
                                                .frame(width: 18, height: 18)
                                                .clipShape(.rect(cornerRadius: 4))
                                                .overlay {
                                                    if isDone {
                                                        Images.check
                                                            .resized(length: 12)
                                                    }
                                                }
                                            Text(content)
                                                .pretendardStyle(.regular, size: 17, color: Colors.grey900)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .frame(height: 32)
                                    }
                                }
                            }
                            SeparatorView(
                                height: 1,
                                color: Colors.grey100
                            )
                        }
                    }
                    Spacer()
                        .frame(height: 36)
                    // 오늘 진척율 / 전체 진척율
                    VStack(spacing: 29) {
                        VStack(spacing: 44) {
                            VStack(spacing: 24) {
                                VStack(spacing: 8) {
                                    Text("오늘 진척율")
                                        .pretendardStyle(.semiBold, size: 16, color: Colors.grey800)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    SemiCircleProgressView(
                                        progress: .constant(0.5),
                                        progressColor: Colors.secondaryY,
                                        backgroundColor: Colors.secondaryY50,
                                        lineWidth: 20
                                    )
                                    .frame(width: 200, height: 100)
                                }
                                Rectangle()
                                    .fill(.clear)
                                    .frame(height: 45)
                                    .background {
                                        Capsule()
                                            .stroke(Colors.grey100, lineWidth: 1)
                                    }
                                    .overlay {
                                        Text("수고했어요! 오늘의 목표를 완료했어요.")
                                            .pretendardStyle(.medium, size: 14)
                                    }
                            }
                            LinearProgressView(
                                title: "전체 진척율",
                                progress: .constant(20),
                                progressColor: Colors.primary,
                                backgroundColor: Colors.primary50,
                                lineWidth: 20
                            )
                        }
                        SeparatorView(
                            height: 1,
                            color: Colors.grey100
                        )
                    }
                    Spacer()
                        .frame(height: 44)
                    // 멘토 코멘트
                    VStack(spacing: 16) {
                        HStack {
                            Text("멘토 코멘트")
                                .pretendard(.semiBold, size: 16, color: Colors.grey900)
                            Spacer()
                            DetailButton(title: "자세히 보기") {
                                // action
                            }
                        }
                        VStack(spacing: 16) {
                            Text("이제 시작한지 얼마 안 됐는데, 척척 해내는 김골메이트님 너무 기특합니다!".splitCharacters())
                                .pretendardStyle(
                                    .regular,
                                    size: 16,
                                    color: Color(hex: "#344300")
                                )
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity)
                            VStack(alignment: .trailing) {
                                Text("2025년 01월 02일")
                                Text("from. 다온")
                            }
                            .pretendard(.regular, size: 12, color: Color(hex: "#344300"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .background(Color(hex: "#FBFFF6"))
                        .clipShape(.rect(cornerRadius: 16))
                    }
                    Spacer()
                        .frame(height: 44)
                    SeparatorView(height: 16)
                    Spacer()
                        .frame(height: 30)
                    // 목표 상세보기
                    VStack(spacing: 16) {
                        HStack {
                            Spacer()
                            DetailButton(title: "목표 상세보기") {
                                // action
                            }
                        }
                        VStack(spacing: 0) {
                            HStack(alignment: .top, spacing: 0) {
                                Text("목표명")
                                    .pretendardStyle(.medium, size: 14, color: Colors.grey500)
                                    .padding(.leading, 12)
                                    .frame(width: 60, alignment: .leading)
                                    .padding(.vertical, 8)
                                    
                                Rectangle()
                                    .fill(Colors.grey200)
                                    .frame(width: 1)
                                Text("다온과 함께하는 영어 완전 정복 30일 목표다온과 함께하는 영어 완전 정복 30일 목표".splitCharacters())
                                    .pretendardStyle(.medium, size: 14, color: Colors.grey600)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                            }
                            SeparatorView(
                                height: 1,
                                color: Colors.grey200
                            )
                            HStack(alignment: .top, spacing: 0) {
                                Text("멘토")
                                    .pretendardStyle(.medium, size: 14, color: Colors.grey500)
                                    .padding(.leading, 12)
                                    .frame(width: 60, alignment: .leading)
                                    .padding(.vertical, 8)
                                    
                                Rectangle()
                                    .fill(Colors.grey200)
                                    .frame(width: 1)
                                Text("다온")
                                    .pretendardStyle(.medium, size: 14, color: Colors.grey600)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Colors.grey100, lineWidth: 1)
                        }
                        
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
        }
    }
}

fileprivate struct DetailButton: View {
    let title: String
    let action: () -> Void
    init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
    }
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                Text(title)
                    .pretendardStyle(
                        .medium,
                        size: 14,
                        color: Colors.grey500
                    )
                Image(systemName: "chevron.right")
                    .renderingMode(.template)
                    .resized(length: 10)
                    .foregroundStyle(Colors.grey500)
            }
            .padding(.leading, 20)
            .padding(.vertical, 4)
        }
    }
}

/*
 struct YearMonthHeaderView: View {
 let startDate: Date
 let endDate: Date
 @Binding var currentMonth: Date
 
 private let calendar = Calendar.current
 private let dateFormatter: DateFormatter = {
 let formatter = DateFormatter()
 formatter.dateFormat = "yyyy년 M월"
 formatter.locale = Locale(identifier: "ko_KR")
 return formatter
 }()
 
 var body: some View {
 HStack(spacing: 8) {
 Button(action: moveToPreviousMonth) {
 Image(systemName: "chevron.left")
 .foregroundColor(canMovePreviousMonth ? .primary : .gray)
 }
 .disabled(!canMovePreviousMonth)
 
 Text(dateFormatter.string(from: currentMonth))
 .font(.system(size: 16, weight: .semibold))
 .frame(width: 100)
 
 Button(action: moveToNextMonth) {
 Image(systemName: "chevron.right")
 .foregroundColor(canMoveNextMonth ? .primary : .gray)
 }
 .disabled(!canMoveNextMonth)
 }
 .padding(.vertical, 8)
 }
 
 private var canMovePreviousMonth: Bool {
 let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
 let previousMonthStart = calendar.startOfMonth(for: previousMonth)
 return previousMonthStart >= startDate
 }
 
 private var canMoveNextMonth: Bool {
 let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
 let nextMonthStart = calendar.startOfMonth(for: nextMonth)
 return nextMonthStart <= endDate
 }
 
 private func moveToPreviousMonth() {
 if canMovePreviousMonth {
 currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
 }
 }
 
 private func moveToNextMonth() {
 if canMoveNextMonth {
 currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
 }
 }
 }
 
 struct HorizontalCalendarView: View {
 @State private var currentPage: Int = 0
 @Binding var selectedDate: Date
 @Binding var currentMonth: Date
 @State private var weekPages: [[Date]] = []
 
 let startDate: Date
 let endDate: Date
 let calendar = Calendar.current
 let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
 
 var body: some View {
 VStack(alignment: .center, spacing: 0) {
 HStack(spacing: 8) {
 ForEach(weekdays, id: \.self) { weekday in
 Text(weekday)
 .font(.caption)
 .foregroundColor(.gray)
 .frame(width: 40)
 }
 }
 .padding(.horizontal)
 
 TabView(selection: $currentPage) {
 ForEach(weekPages.indices, id: \.self) { index in
 WeekView(
 dates: weekPages[index],
 selectedDate: $selectedDate,
 startDate: startDate,
 endDate: endDate
 )
 .tag(index)
 }
 }
 .tabViewStyle(.page(indexDisplayMode: .never))
 .frame(height: 50)
 .onChange(of: currentMonth) { newMonth in
 let monthStart = calendar.startOfMonth(for: newMonth)
 moveToWeekContaining(date: monthStart)
 }
 .onChange(of: currentPage) { newPage in
 let visibleDates = weekPages[newPage]
 let midWeekDate = visibleDates[3]
 let newMonth = calendar.startOfMonth(for: midWeekDate)
 currentMonth = newMonth
 }
 }
 }
 
 private func moveToWeekContaining(date: Date) {
 if let weekIndex = weekPages.firstIndex(where: { week in
 week.contains { dayDate in
 calendar.isDate(dayDate, equalTo: date, toGranularity: .month)
 }
 }) {
 withAnimation {
 currentPage = weekIndex
 }
 }
 }
 
 init(startDate: Date, endDate: Date, selectedDate: Binding<Date>, currentMonth: Binding<Date>) {
 self.startDate = startDate
 self.endDate = endDate
 self._selectedDate = selectedDate
 self._currentMonth = currentMonth
 
 // 시작일부터 종료일까지의 모든 주 생성
 var weeks: [[Date]] = []
 var currentDate = calendar.startOfWeek(for: startDate)
 
 while currentDate <= endDate {
 var week: [Date] = []
 for dayOffset in 0..<7 {
 let nextDate = calendar.date(byAdding: .day, value: dayOffset, to: currentDate) ?? currentDate
 week.append(nextDate)
 }
 weeks.append(week)
 currentDate = calendar.date(byAdding: .day, value: 7, to: currentDate) ?? currentDate
 }
 
 _weekPages = State(initialValue: weeks)
 
 // 현재 날짜가 포함된 주의 인덱스 찾기
 let today = Date()
 let initialPage = weeks.firstIndex(where: { week in
 week.contains { date in
 calendar.isDate(date, inSameDayAs: today)
 }
 }) ?? 0
 
 _currentPage = State(initialValue: initialPage)
 }
 }
 
 struct WeekView: View {
 let dates: [Date]
 @Binding var selectedDate: Date
 let startDate: Date
 let endDate: Date
 
 private let calendar = Calendar.current
 
 var body: some View {
 HStack(spacing: 8) {
 ForEach(dates, id: \.self) { date in
 DateCell(
 date: date,
 isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
 isToday: calendar.isDateInToday(date),
 isInRange: isDateInRange(date)
 ) {
 if isDateInRange(date) {
 selectedDate = date
 }
 }
 }
 }
 .padding(.horizontal)
 }
 
 private func isDateInRange(_ date: Date) -> Bool {
 return (date >= startDate && date <= endDate)
 }
 }
 
 struct DateCell: View {
 let date: Date
 let isSelected: Bool
 let isToday: Bool
 let isInRange: Bool
 let onTap: () -> Void
 
 private let calendar = Calendar.current
 private let dateFormatter: DateFormatter = {
 let formatter = DateFormatter()
 formatter.dateFormat = "d"
 return formatter
 }()
 
 var body: some View {
 Text(dateFormatter.string(from: date))
 .font(.system(size: 16, weight: .medium))
 .foregroundColor(textColor)
 .frame(width: 40, height: 40)
 .background(
 Circle()
 .fill(backgroundColor)
 )
 .onTapGesture(perform: onTap)
 }
 
 private var backgroundColor: Color {
 if !isInRange {
 return .clear
 } else if isSelected {
 return .purple
 } else if isToday {
 return .gray.opacity(0.3)
 }
 return .clear
 }
 
 private var textColor: Color {
 if !isInRange {
 return .gray.opacity(0.3)
 } else if isSelected {
 return .white
 }
 return .primary
 }
 }
 
 extension Calendar {
 func startOfMonth(for date: Date) -> Date {
 let components = dateComponents([.year, .month], from: date)
 return self.date(from: components) ?? date
 }
 
 func startOfWeek(for date: Date) -> Date {
 let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
 return self.date(from: components) ?? date
 }
 }
 */
//@available(iOS 17.0, *)
//#Preview {
//    let calendar = Calendar.current
//    let today = Date()
//    let startDate = calendar.date(byAdding: .day, value: -50, to: today) ?? Date()
//    let endDate = calendar.date(byAdding: .day, value: 40, to: today) ?? Date()
//    
//    MyGoalDetailView(
//        store: .init(
//            initialState: .init(
//                id: 1,
//                startDate: startDate,
//                endDate: endDate
//            )
//        ) {
//            MyGoalDetailFeature()
//        }
//    )
//}
