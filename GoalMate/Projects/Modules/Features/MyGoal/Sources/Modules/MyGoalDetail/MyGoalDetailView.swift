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
            Rectangle()
                .fill(Colors.grey50)
                .frame(maxWidth: .infinity)
                .frame(height: 24)
            Spacer()
                .frame(height: 30)
            VStack {
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
                VStack {
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
                                Images.check
                                    .resized(length: 24)
                                Text(content)
                                    .pretendardStyle(.regular, size: 17, color: Colors.grey900)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(height: 32)
                        }
                    }
                }
                Spacer()
                    .frame(height: 30)
                Rectangle()
                    .fill(Colors.grey50)
                    .frame(maxWidth: .infinity)
                    .frame(height: 24)
                Spacer()
                    .frame(height: 30)
                VStack {
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
                VStack {
                    LinearProgressView(
                        title: "전체 진척율",
                        progress: .constant(20),
                        progressColor: Colors.primary,
                        backgroundColor: Colors.primary50,
                        lineWidth: 20
                    )
                }
            }
            Spacer()
                .frame(height: 30)
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
@available(iOS 17.0, *)
#Preview {
    let calendar = Calendar.current
    let today = Date()
    let startDate = calendar.date(byAdding: .day, value: -50, to: today) ?? Date()
    let endDate = calendar.date(byAdding: .day, value: 40, to: today) ?? Date()

    MyGoalDetailView(
        store: .init(
            initialState: .init(
                id: 1,
                startDate: startDate,
                endDate: endDate
            )
        ) {
            MyGoalDetailFeature()
        }
    )
}
