//
//  CalendarView.swift
//  Calendar
//
//  Test Project
//

import UIKit

protocol CalendarDelegate: class {
    func getSelectedDates(_ dates: [Date])
}

class CalendarView: UIView {

    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    weak var delegate: CalendarDelegate?
	
	/**
	View model for the calendar view for getting month dates, name and year for the months selected by user
	*/
	var viewModel: CalendarViewModel!

    //MARK:- Initialize calendar
	private func initialize(with viewModel: CalendarViewModel) {
		self.viewModel = viewModel
		
        let nib = UINib(nibName: DayCell.cellID, bundle: nil)
        self.daysCollectionView.register(nib, forCellWithReuseIdentifier: DayCell.cellID)
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
		self.daysCollectionView.allowsMultipleSelection = true
		
		self.showCalendarDetails(for: .currentMonth)
    }
	
	/**
	Calls view model for for getting details (dates, month name, etc) for the current, next and previous months as the user
	taps on the next/previous butons for months
	*/
	private func showCalendarDetails(for month: CalendarViewModel.CalendarMonth) {
		self.viewModel.getDetails(for: month) { details, error in
			guard let details = details, error == nil else {
				print(error!)
				return
			}
			self.update(with: details)
		}
	}
	
	/**
	Displays the selected month details like dates, month name, year
	*/
	private func update(with details: CalendarDetails) {
		self.monthAndYear.text = "\(details.monthTitle) \(details.yearTitle)"
		self.daysCollectionView.reloadData()
		
		// Auto scroll to and selects the current date
		if let currentDateIndex = details.currentDateIndex {
			let indexPath = IndexPath(row: currentDateIndex, section: 0)
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				self.daysCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
			}
		}
	}
    
    //MARK:- Change month when left and right arrow button tapped
    @IBAction func arrowTapped(_ sender: UIButton) {
		let targetMonth: CalendarViewModel.CalendarMonth = sender == rightBtn ? .nextMonth : .previousMonth
		self.showCalendarDetails(for: targetMonth)
    }
}

//MARK:- Calendar collection view delegate and datasource methods
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.viewModel.numberOfDatesInMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.cellID, for: indexPath) as! DayCell
		if let date = self.viewModel.getDate(for: indexPath.row) {
			
			// Get details about the date (day number, week of day) from the view model
			self.viewModel.getDetails(for: date) { dateNumber, dayOfWeek in
				cell.update(with: dateNumber, weekDay: dayOfWeek)
				
				// Select item if it represents the current date and any other date isn't selected
				if !cell.isSelected, self.viewModel.isCurrentDate(date: date) {
					cell.isSelected = true
					self.viewModel.addDateToSelection(index: indexPath.row)
					self.delegate?.getSelectedDates(self.viewModel.selectedDates)
				}
			}
		}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) as? DayCell else { return }
		if cell.isSelected {
			self.viewModel.addDateToSelection(index: indexPath.row)
			delegate?.getSelectedDates(self.viewModel.selectedDates)
		} else {
			cell.isSelected = false
			self.viewModel.removeDateFromSelection(index: indexPath.row)
			delegate?.getSelectedDates(self.viewModel.selectedDates)
		}
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		self.viewModel.removeDateFromSelection(index: indexPath.row)
		delegate?.getSelectedDates(self.viewModel.selectedDates)
    }
}

//MARK:- Add calendar to the view
extension CalendarView {
    
    public class func addCalendar(_ superView: UIView) -> CalendarView? {
        var calendarView: CalendarView?
        if calendarView == nil {
            calendarView = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: self, options: nil).last as? CalendarView
            guard let calenderView = calendarView else { return nil }
            calendarView?.frame = CGRect(x: 0, y: 0, width: superView.bounds.size.width, height: superView.bounds.size.height)
            superView.addSubview(calenderView)
			
			/**
			Initializes CalendarView with the required CalendarViewModel view model
			*/
			let calendarService = CFCalendarService()
			let viewModel = CalendarViewModel(calendarService: calendarService)
			calenderView.initialize(with: viewModel)
            return calenderView
        }
        return nil
    }
    
}
