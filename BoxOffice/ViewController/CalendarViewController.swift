//
//  CalendarViewController.swift
//  BoxOffice
//
//  Created by Hemg on 2023/08/27.
//

import UIKit

protocol TargetDateDelegate:AnyObject {
    func setUpTargetDate(targetDate: String)
}

final class CalendarViewController: UIViewController {
    private var targetDate: String
    weak var delegate: TargetDateDelegate?
    
    private var calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        
        let gregorianCalendar = Calendar(identifier: .gregorian)
        calendarView.calendar = gregorianCalendar
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.fontDesign = .rounded
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()

    init(targetDate: String) {
        self.targetDate = targetDate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        showCalendarViewSelection()
        setUpCalendarViewLayout()
    }
    
    private func setUpCalendarViewLayout() {
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func showCalendarView(_ selectedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        targetDate = dateFormatter.string(from: selectedDate)
    }
    
    private func showCalendarViewSelection() {
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let selectedDate = dateComponents?.date {
            showCalendarView(selectedDate)
        }

        delegate?.setUpTargetDate(targetDate: targetDate)
        dismiss(animated: true)
    }
}
