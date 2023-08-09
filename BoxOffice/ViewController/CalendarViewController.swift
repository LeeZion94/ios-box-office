//
//  CalendarViewController.swift
//  BoxOffice
//
//  Created by Hyungmin Lee on 2023/08/09.
//

import UIKit

protocol CalendarViewControllerDelegate: AnyObject {
    func didSelectedTargetDate(_ targetDate: String)
}

final class CalendarViewController: UIViewController {
    private let targetDate: String
    weak var delegate: CalendarViewControllerDelegate?
    
    private let calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    
    init(_ targetDate: String) {
        self.targetDate = targetDate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("deinit - CalendarViewController")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        setUpViewController()
        setUpCalendarViewContents()
    }
    
    private func setUpLayout() {
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
    }
    
    private func setUpCalendarViewContents() {
        let targetDate = targetDate.components(separatedBy: "-")
        guard let targetYear  = Int(targetDate.first ?? ""), let targetMonth = Int(targetDate[1]),
              let targetDay  = Int(targetDate.last ?? "") else { return }
        
        let today = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDateString = formatter.string(from: today)
        
        let todayDate = todayDateString.components(separatedBy: "-")
        guard let todayYear  = Int(todayDate.first ?? ""), let todayMonth = Int(todayDate[1]),
              let todayDay  = Int(todayDate.last ?? "") else { return }
        
        let calendar = Calendar(identifier: .gregorian)
        let fromDateComponents = DateComponents(calendar: calendar, year: 2022, month: 1, day: 1)
        let toDateComponents = DateComponents(calendar: calendar, year: todayYear, month: todayMonth, day: todayDay)
        let todayDateComponents = DateComponents(calendar: calendar, year: targetYear, month: targetMonth, day: targetDay)
        let fromDate = fromDateComponents.date ?? Date()
        let toDate = toDateComponents.date ?? Date()
        let calendarViewDateRange = DateInterval(start: fromDate, end: toDate)
        let dateSelction = UICalendarSelectionSingleDate(delegate: self)
        
        dateSelction.selectedDate = todayDateComponents
        calendarView.calendar = calendar
        calendarView.locale = Locale(identifier: "ko-KR")
        calendarView.availableDateRange = calendarViewDateRange
        calendarView.selectionBehavior = dateSelction
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate
extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let targetYear = dateComponents?.year, let targetMonth = dateComponents?.month,
              let targetDay = dateComponents?.day else { return }
        
        let targetDateString = "\(targetYear)-\(targetMonth)-\(targetDay)"
        let dateFormmater = DateFormatter()
        
        dateFormmater.dateFormat = "yyyy-M-d"
        
        let targetDate = dateFormmater.date(from: targetDateString) ?? Date()
        
        dateFormmater.dateFormat = "yyyy-MM-dd"
        
        let formattedTargetDate = dateFormmater.string(from: targetDate)
        
        delegate?.didSelectedTargetDate(formattedTargetDate)
        dismiss(animated: true)
    }
}
