//
//  HabitStore.swift
//  MyHabits
//
//  Created by beshssg on 01.08.2021.
//

import UIKit

/// Класс для хранения данных о привычке.
public final class Habit: Codable {
    
    /// Название привычки / The name of the habit
    public var name: String
    
    /// Время выполнения привычки / Time to do the habit
    public var date: Date
    
    /// Даты выполнения привычки / Dates of fulfillment of the habit
    public var trackDates: [Date]
    
    /// Цвет привычки для выделения в списке / The color of the habit to highlight in the list
    public var color: UIColor {
        get {
            return .init(red: r, green: g, blue: b, alpha: a)
        }
        set {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            newValue.getRed(&r, green: &g, blue: &b, alpha: &a)
            self.r = r
            self.g = g
            self.b = b
            self.a = a
        }
    }
    
    /// Описание времени выполнения привычки / Description of the time to perform the habit
    public var dateString: String {
        "Каждый день в " + dateFormatter.string(from: date)
    }
    
    /// Показывает, была ли сегодня добавлена привычка / Indicates if a habit has been added today
    public var isAlreadyTakenToday: Bool {
        guard let lastTrackDate = trackDates.last else {
            return false
        }
        return calendar.isDateInToday(lastTrackDate)
    }
    
    private var r: CGFloat
    private var g: CGFloat
    private var b: CGFloat
    private var a: CGFloat
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeStyle = .short
        return formatter
    }()
    
    private lazy var calendar: Calendar = .current
    
    public init(name: String, date: Date, trackDates: [Date] = [], color: UIColor) {
        self.name = name
        self.date = date
        self.trackDates = trackDates
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
}

extension Habit: Equatable {
    
    public static func == (lhs: Habit, rhs: Habit) -> Bool {
        lhs.name == rhs.name &&
        lhs.date == rhs.date &&
        lhs.trackDates == rhs.trackDates &&
        lhs.r == rhs.r &&
        lhs.g == rhs.g &&
        lhs.b == rhs.b &&
        lhs.a == rhs.a
    }
}

/// Класс для сохранения и изменения привычек пользователя / A class for saving and changing user habits
public final class HabitsStore {
    
    /// Синглтон для изменения состояния привычек из разных модулей / Singleton to change the state of habits from different modules.
    public static let shared: HabitsStore = .init()
    
    /// Список привычек, добавленных пользователем. Добавленные привычки сохраняются в UserDefaults и доступны после перезагрузки приложения / A list of habits added by the user. Added habits are saved to UserDefaults and are available after restarting the application
    public var habits: [Habit] = [] {
        didSet {
            save()
        }
    }
    
    /// Даты с момента установки приложения с разницей в один день / Dates from the time the app was installed one day apart
    public var dates: [Date] {
        guard let startDate = userDefaults.object(forKey: "start_date") as? Date else {
            return []
        }
        return Date.dates(from: startDate, to: .init())
    }
    
    /// Возвращает значение от 0 до 1 / Returns a value from 0 to 1
    public var todayProgress: Float {
        guard habits.isEmpty == false else {
            return 0
        }
        let takenTodayHabits = habits.filter { $0.isAlreadyTakenToday }
        return Float(takenTodayHabits.count) / Float(habits.count)
    }
    
    private lazy var userDefaults: UserDefaults = .standard
    
    private lazy var decoder: JSONDecoder = .init()
    
    private lazy var encoder: JSONEncoder = .init()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ru_RU")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    private lazy var calendar: Calendar = .current
    
    // MARK: - Lifecycle
    
    /// Сохраняет все изменения в привычках в UserDefaults / Saves all changes in habits in UserDefaults
    public func save() {
        do {
            let data = try encoder.encode(habits)
            userDefaults.setValue(data, forKey: "habits")
        }
        catch {
            print("Ошибка кодирования привычек для сохранения", error)
        }
    }
    
    /// Добавляет текущую дату в trackDates для переданной привычки / Adds the current date to trackDates for the passed habit
    /// - Parameter habit: Привычка, в которую добавится новая дата / Habit, in which a new date will be added
    public func track(_ habit: Habit) {
        habit.trackDates.append(.init())
        save()
    }
    
    /// Возвращает отформатированное время для даты / Returns the formatted time for the date
    /// - Parameter index: Индекс в массиве dates / The index in the dates array
    public func trackDateString(forIndex index: Int) -> String? {
        guard index < dates.count else {
            return nil
        }
        return dateFormatter.string(from: dates[index])
    }
    
    /// Показывает, была ли затрекана привычка в переданную дату / Shows whether the habit was picked up on the transmitted date
    /// - Parameters:
    ///   - habit: Привычка, у которой проверяются затреканные даты / The habit that has the treasured dates checked
    ///   - date: Дата, для которой проверяется, была ли затрекана привычка / The date for which it is checked whether the habit has been traced
    /// - Returns: Возвращает true, если привычка была затрекана в переданную дату / Returns true if the habit was tracked on the passed date
    public func habit(_ habit: Habit, isTrackedIn date: Date) -> Bool {
        habit.trackDates.contains { trackDate in
            calendar.isDate(date, equalTo: trackDate, toGranularity: .day)
        }
    }
    
    // MARK: - Private
    
    private init() {
        if userDefaults.value(forKey: "start_date") == nil {
            let startDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) ?? Date()
            userDefaults.setValue(startDate, forKey: "start_date")
        }
        guard let data = userDefaults.data(forKey: "habits") else {
            return
        }
        do {
            habits = try decoder.decode([Habit].self, from: data)
        }
        catch {
            print("Ошибка декодирования сохранённых привычек", error)
        }
    }
}

private extension Date {
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate

        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else {
                break
            }
            date = newDate
        }
        return dates
    }
}

