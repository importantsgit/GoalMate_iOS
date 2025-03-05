//
//  MyGoalDetailView.swift
//  FeatureCommon
//
//  Created by 이재훈 on 1/21/25.
//

import ComposableArchitecture
import Data
import Foundation
import SwiftUI
import Utils

public struct MyGoalDetailView: View {
    @State var store: StoreOf<MyGoalDetailFeature>
    public init(store: StoreOf<MyGoalDetailFeature>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                VStack(spacing: 0) {
                    NavigationBar(
                        leftContent: {
                            Button {
                                store.send(.view(.backButtonTapped))
                            } label: {
                                Images.back
                                    .resized(length: 24)
                                    .padding(.all, 12)
                            }
                        },
                        centerContent: {
                            Text(store.content?.title ?? "목표")
                                .pretendard(.semiBold, size: 20, color: Colors.grey900)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(width: 300)
                        }
                    )
                    .frame(height: 52)
                    .padding(.horizontal, 4)
                    let isShowContent = store.content != nil
                    ZStack(alignment: .bottom) {
                        if isShowContent {
                            ScrollView {
                                Spacer()
                                    .frame(height: 16)
                                calendarView
                                    .frame(height: 118)
                                Spacer()
                                    .frame(height: 56)
                                if store.isContentLoading == false {
                                    VStack(spacing: 0) {
                                        Group {
                                            if store.todos.isEmpty == false {
                                                todoView
                                                    .padding(.vertical, 30)
                                                    .padding(.horizontal, 20)
                                            } else {
                                                Text("오늘은 쉬는 날이에요!")
                                                    .pretendard(
                                                        .semiBold,
                                                        size: 16,
                                                        color: Colors.grey900)
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.vertical, 51)
                                            }
                                        }
                                        .background(Colors.grey50)
                                        .overlay {
                                            if store.isTodoLoading {
                                                ZStack {
                                                    Colors.grey100
                                                        .opacity(0.3)
                                                    ProgressView()
                                                        .progressViewStyle(.circular)
                                                }
                                            }
                                        }
                                        .animation(
                                            .easeInOut(duration: 0.2),
                                            value: store.isTodoLoading)
                                        .animation(
                                            .easeInOut(duration: 0.2),
                                            value: store.todos)
                                        VStack(spacing: 0) {
                                            // 오늘 해야 할 일
                                            Spacer()
                                                .frame(height: 36)
                                            // 오늘 진척율 / 전체 진척율
                                            goalProgressView
                                            Spacer()
                                                .frame(height: 44)
                                            SeparatorView(height: 16)
                                            Spacer()
                                                .frame(height: 30)
                                            // 목표 상세보기
                                            goalDetailInfoView
                                            Spacer()
                                                .frame(height: 150)
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                } else {
                                    skeletonView
                                }
                            }
                            .scrollIndicators(.hidden)
                            bottomButtomView
                        } else {
                            skeletonView
                                .transition(.opacity)
                        }
                    }
                    .loadingFailure(didFailToLoad: store.didFailToLoad) {
                        store.send(.view(.retryButtonTapped))
                    }
                    .animation(
                        .easeInOut(duration: 0.1),
                        value: isShowContent)
                    .animation(
                        .easeInOut(duration: 0.1),
                        value: store.isLoadingWhenDayTapped)
                }
            }
            .toast(state: $store.toastState, position: .bottom)
            .hideWithScreenshot()
            .overlay {
                CustomPopup(
                    isPresented: $store.isShowPopup.sending(\.dismissCapturePopup),
                    leftButtonTitle: nil,
                    rightButtonTitle: "확인했어요",
                    leftAction: nil,
                    rightAction: {
                        print("Right button tapped")
                    }
                ) {
                    let isCapture = store.isShowCapturePopup
                    let text = isCapture ?
                    "멘토의 정성이 담긴 계획은\n공유할 수 없어요." :
                    "오늘이 아닌 날짜는\n완료 표시할 수 없어요 :("
                    VStack {
                        if isCapture {
                            Images.warning
                                .resized(length: 24)
                            Spacer()
                                .frame(height: 10)
                            Text("화면 캡처 금지")
                                .pretendardStyle(
                                    .semiBold,
                                    size: 18,
                                    color: Colors.grey800
                                )
                            Spacer()
                                .frame(height: 10)
                        }

                        Text(text)
                            .multilineTextAlignment(.center)
                            .pretendard(
                                .semiBold,
                                size: 16,
                                color: Colors.grey600
                            )
                    }
                }
                .ignoresSafeArea()
            }
            .task {
                store.send(.viewCycling(.onAppear))
            }
            .onDisappear {
                store.send(.viewCycling(.onDisappear))
            }
        }
    }

    @ViewBuilder
    var skeletonView: some View {
        VStack {
            if store.isLoadingWhenDayTapped == false {
                Spacer()
                    .frame(height: 16)
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Colors.grey200)
                        .frame(width: 100, height: 20)
                    Spacer()
                }
                Spacer()
                    .frame(height: 20)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(height: 118)
                Spacer()
                    .frame(height: 56)
            }
            Spacer()
                .frame(height: 30)
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(width: 100, height: 20)
                Spacer()
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(width: 100, height: 30)
            }
            RoundedRectangle(cornerRadius: 8)
                .fill(Colors.grey200)
                .frame(height: 150)
            Spacer()
                .frame(height: 20)
            RoundedRectangle(cornerRadius: 8)
                .fill(Colors.grey200)
                .frame(height: 118)
            Spacer()
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    var calendarView: some View {
        if let menteeGoal = store.content,
           let startDate = menteeGoal.startDate?.toDate(),
           let endDate = menteeGoal.endDate?.toDate() {
            VStack(alignment: .leading, spacing: 20) {
                Text(store.selectedDate.getString(format: "yyyy년 M월 dd일"))
                    .pretendardStyle(
                        .medium,
                        size: 15,
                        color: Colors.grey700
                    )
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Colors.grey200)
                    .clipShape(.rect(cornerRadius: 6))
                    .padding(.leading, 20)
                HorizontalCalendarView(
                    startDate: startDate,
                    endDate: endDate,
                    weeklyProgress: store.weeklyProgress,
                    selectedDate: $store.selectedDate.sending(\.dateButtonTapped)
                ) { date in
                    store.send(.calendar(.onSwipe(date)))
                }
                .onAppear {
                    store.send(.calendar(.onAppear))
                }
            }
        } else {
            RoundedRectangle(cornerRadius: 8)
                .fill(Colors.grey200)
        }
    }

    @ViewBuilder
    var todoView: some View {
        WithPerceptionTracking {
            let selectedDate = store.selectedDate
            let isToday = Calendar.current.isDateInToday(selectedDate)
            let dateString = isToday ? "오늘" : selectedDate.getString(format: "M월 dd일")
            VStack(spacing: 24) {
                VStack(spacing: 15) {
                    HStack {
                        Text("\(dateString) 해야 할 일")
                            .pretendard(.semiBold, size: 16, color: Colors.grey900)
                            .padding(.vertical, 6)
                        Spacer()
                        // 과거가 아니라면 타이머 노출
                        if store.isContentLoading == false,
                           Calendar.current.compare(
                            store.selectedDate,
                            to: Date(),
                            toGranularity: .day
                        ) != .orderedDescending {
                            let isTimeOver = Calendar.current.isDateInToday(
                                                store.selectedDate) == false ||
                                            store.remainingTime <= 0
                            HStack(spacing: 4) {
                                Text(isTimeOver ?
                                        "time over" :
                                        store.remainingTime.formattedRemainingTime())
                                    .pretendard(
                                        .semiBold,
                                        size: 14,
                                        color:
                                            store.remainingTime <= 30 * 60 &&
                                            isTimeOver == false ?
                                            Colors.error :
                                            Colors.grey700
                                    )
                                if isTimeOver == false {
                                    Text("남았어요")
                                        .pretendard(
                                            .regular,
                                            size: 12,
                                            color:
                                                store.remainingTime <= 30 * 60 &&
                                                isTimeOver == false ?
                                                Colors.error :
                                                Colors.grey700
                                        )
                                }
                            }
                            .monospacedDigit()
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                store.remainingTime <= 30 * 60 &&
                                isTimeOver == false ?
                                    Color(hex: "FFEAE9") :
                                    Color.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        store.remainingTime <= 30 * 60 &&
                                        isTimeOver == false ?
                                            Colors.error :
                                            Colors.grey200,
                                        lineWidth: 1)
                            }
                        }
                    }
                }
                VStack(spacing: 29) {
                    VStack(spacing: 16) {
                        ForEach(store.todos, id: \.id) { todo in
                            VStack(alignment: .leading, spacing: 6) {
                                Button {
                                    store.send(.view(
                                        .todoButtonTapped(todo.id, todo.todoStatus)))
                                } label: {
                                    HStack(alignment: .top, spacing: 10) {
                                        let isDone = todo.todoStatus == .completed
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
                                            .padding(.top, 2)
                                        Text((todo.description ?? "").splitCharacters())
                                            .multilineTextAlignment(.leading)
                                            .lineSpacing(4)
                                            .pretendard(
                                                .regular,
                                                size: 17,
                                                color: Colors.grey900
                                            )
                                            .fixedSize(
                                                horizontal: false,
                                                vertical: true
                                            )
                                        Spacer()
                                    }
                                }
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(todo.estimatedMinutes ?? 0)분")
                                            .pretendardStyle(
                                                .regular,
                                                size: 14,
                                                color: Colors.grey500
                                            )
                                        if let mentorTip = todo.mentorTip,
                                           mentorTip.isEmpty == false {
                                            Rectangle()
                                                .fill(Colors.grey300)
                                                .frame(width: 1, height: 12)
                                            Button {
                                                store.send(.view(.todoTipButtonTapped(todo.id)))
                                            } label: {
                                                HStack {
                                                    Text("멘토 TIP")
                                                        .pretendardStyle(
                                                            .semiBold,
                                                            size: 12,
                                                            color: Colors.grey800
                                                        )
                                                    Path { path in
                                                        path.move(
                                                            to: CGPoint(x: 0, y: 0))
                                                        path.addLine(
                                                            to: CGPoint(x: 4, y: 4))
                                                        path.addLine(
                                                            to: CGPoint(x: 8, y: 0))
                                                        path.closeSubpath()
                                                    }
                                                    .fill(Colors.grey800)
                                                    .frame(width: 8, height: 4)
                                                    .scaleEffect(x: 1, y: todo.isShowTip ? -1 : 1)
                                                }
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Colors.grey200)
                                                .clipShape(.rect(cornerRadius: 6))
                                            }
                                        }
                                    }
                                    if todo.isShowTip {
                                        Text(todo.mentorTip ?? "")
                                            .pretendard(
                                                .medium,
                                                size: 14,
                                                color: Colors.grey800
                                            )
                                            .lineSpacing(4)
                                            .frame(
                                                maxWidth: .infinity,
                                                minHeight: 14,
                                                alignment: .leading
                                            )
                                            .padding(12)
                                            .background(.white)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(
                                                        Colors.grey200,
                                                        lineWidth: 1
                                                    )
                                            }
                                    }
                                }
                                .padding(.leading, 28)
                            }
                            .animation(
                                .easeInOut(duration: 0.1),
                                value: todo.isShowTip
                            )
                        }
                    }
                    SeparatorView(
                        height: 1,
                        color: Colors.grey100
                    )
                }
            }
        }
    }

    // 오늘 진척율 / 전체 진척율
    @ViewBuilder
    var goalProgressView: some View {
        WithPerceptionTracking {
            let selectedDate = store.selectedDate
            let isToday = Calendar.current.isDateInToday(selectedDate)
            let dateString = isToday ? "오늘" : selectedDate.getString(format: "M월 dd일")
            if let menteeGoal = store.content {
                VStack(spacing: 29) {
                    VStack(spacing: 44) {
                        if store.todos.isEmpty == false {
                            VStack(spacing: 24) {
                                VStack(spacing: 8) {
                                    Text("\(dateString) 진척율")
                                        .pretendardStyle(
                                            .semiBold,
                                            size: 16,
                                            color: Colors.grey800
                                        )
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    let progress = (Double(menteeGoal.todayCompletedCount) /
                                                    Double(menteeGoal.todayTodoCount))
                                    SemiCircleProgressView(
                                        progress: progress,
                                        progressColor: Colors.secondaryY,
                                        backgroundColor: Colors.secondaryY50,
                                        lineWidth: 20
                                    )
                                }
                            }
                        }
                        LinearProgressView(
                            title: "전체 진척율",
                            progress:
                                Double(menteeGoal.totalCompletedCount) /
                                Double(menteeGoal.totalTodoCount),
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
            }
        }
    }

    @ViewBuilder
    var goalDetailInfoView: some View {
        WithPerceptionTracking {
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    DetailButton(title: "목표 상세보기") {
                        store.send(.view(.showGoalDetail))
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
                        Text(
                            (store.content?.title ?? "")
                                .splitCharacters())
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
                        Text(store.content?.mentorName ?? "")
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
    }

    @ViewBuilder
    var bottomButtomView: some View {
        VStack {
            Spacer()
            Button {
                store.send(.view(.showCommentButtonTapped))
            } label: {
                Text("멘토 코멘트 받으러 가기")
                    .pretendardStyle(
                        .medium,
                        size: 16,
                        color: .black
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Colors.primary)
                    .clipShape(.capsule)
            }
            .padding(.horizontal, 20)
            Spacer()
                .frame(height: 16)
        }
        .frame(height: 112)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.white.opacity(0), .white, .white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
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

struct HorizontalCalendarView: View {
    @State private var currentPage: Int = 0
    @Binding var selectedDate: Date
    @State private var weekPages: [[Date]] = []
    let startDate: Date
    let endDate: Date
    let weeklyProgress: IdentifiedArrayOf<DailyProgress>
    let calendar = Calendar.current
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    let onSwipe: (Date) -> Void

    init(
        startDate: Date,
        endDate: Date,
        weeklyProgress: IdentifiedArrayOf<DailyProgress>,
        selectedDate: Binding<Date>,
        onSwipe: @escaping (Date) -> Void
    ) {
        self.startDate = startDate
        self.endDate = endDate
        self.weeklyProgress = weeklyProgress
        self._selectedDate = selectedDate
        self.onSwipe = onSwipe

        var weeks: [[Date]] = []
        var currentDate = calendar.startOfWeek(for: startDate)

        while currentDate <= endDate {
            var week: [Date] = []
            for dayOffset in 0..<7 {
                let nextDate = calendar.date(
                    byAdding: .day,
                    value: dayOffset,
                    to: currentDate) ?? currentDate
                week.append(nextDate)
            }
            weeks.append(week)
            currentDate = calendar.date(byAdding: .day, value: 7, to: currentDate) ?? currentDate
        }

        _weekPages = State(initialValue: weeks)
        let today = Date()
        let initialPage = weeks.firstIndex(where: { week in
            week.contains { date in
                calendar.isDate(date, inSameDayAs: today)
            }
        }) ?? 0
        _currentPage = State(initialValue: initialPage)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                }
            }
            .padding(.horizontal, 30)
            TabView(selection: $currentPage) {
                ForEach(weekPages.indices, id: \.self) { index in
                    WeekView(
                        dates: weekPages[index],
                        selectedDate: $selectedDate,
                        startDate: startDate,
                        endDate: endDate,
                        weeklyProgress: weeklyProgress
                    )
                    .padding(.horizontal, 30)
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 60)
            .onChange(of: currentPage) { newValue in
                // 스와이프가 완료된 후 해당 주의 수요일 날짜를 찾아서 API 호출
                if let wednesday = getWednesdayForWeek(at: newValue) {
                    onSwipe(wednesday)
                }
            }
        }
    }

    private func getWednesdayForWeek(at index: Int) -> Date? {
        guard index >= 0, index < weekPages.count else { return nil }
        let week = weekPages[index]
        // 수요일은 인덱스 3 (일요일이 0부터 시작)
        if week.count > 3 {
            return week[3]  // 수요일은 인덱스 3 (일요일이 0부터 시작)
        }
        return nil
    }
}

struct WeekView: View {
    let dates: [Date]
    @Binding var selectedDate: Date
    let startDate: Date
    let endDate: Date
    let weeklyProgress: IdentifiedArrayOf<DailyProgress>

    private let calendar = Calendar.current
    var body: some View {
        HStack(spacing: 8) {
            ForEach(dates, id: \.self) { date in
                let progress = weeklyProgress[
                    id: date.getString(format: "yyyy-MM-dd")]
                DateCell(
                    date: date,
                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                    isToday: calendar.isDateInToday(date),
                    isInRange: isDateInRange(date),
                    progress: progress
                ) {
                    if isDateInRange(date) {
                        selectedDate = date
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
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
    let progress: DailyProgress?
    let onTap: () -> Void

    var body: some View {
        ZStack {
            Text(date.getString(format: "d"))
                .pretendardStyle(.medium, size: 15, color: textColor)
            if isInRange,
               isSelected == false,
               let progress = progress,
               progress.dailyTodoCount > 0,
               Calendar.current.compare(
                date,
                to: Date(),
                toGranularity: .day
               ) == .orderedAscending {
                CircularProgressView(
                    progress:
                        (Double(progress.completedDailyTodoCount) /
                         Double(progress.dailyTodoCount)),
                    progressColor: Colors.primary,
                    backgroundColor: Colors.primary100
                )
            }
        }
        .frame(width: 30, height: 40)
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
            return isToday ? Colors.secondaryY : Colors.secondaryP
        } else if isToday {
            return .gray.opacity(0.3)
        }
        return .clear
    }

    private var textColor: Color {
        if !isInRange {
            return .gray.opacity(0.3)
        } else if isSelected {
            return isToday ? .black : .white
        }
        return Colors.grey700
    }

    private var progressTextColor: Color {
        if !isInRange {
            return .gray.opacity(0.3)
        }
        return Colors.primary
    }
}

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components) ?? date
    }
}

extension TimeInterval {
    func formattedRemainingTime() -> String {
         let hours = Int(self) / 3600
         let minutes = Int(self) / 60 % 60
         let seconds = Int(self) % 60
         return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
     }
}
@available(iOS 17.0, *)
#Preview {
    MyGoalDetailView(
        store: .init(initialState: .init(menteeGoalId: 1)) {
            withDependencies {
                $0.authClient = .previewValue
                $0.menteeClient = .previewValue
                $0.date.now = {
                    let calendar = Calendar.current
                    let currentDate = "2025-02-27".toDate()
                    let targetComponents = DateComponents(
                        year: calendar.component(.year, from: currentDate),
                        month: calendar.component(.month, from: currentDate),
                        day: calendar.component(.day, from: currentDate),
                        hour: 23,
                        minute: 58,
                        second: 01
                    )
                    return calendar.date(from: targetComponents)!
                }()
            } operation: {
                MyGoalDetailFeature()
            }
        }
    )
}
