//
//  CalendarViewModel.swift
//  CarFit
//
//  Created by Prem Pratap Singh on 20/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

typealias CalendarResponseHandler = (CalendarDetails?, String?) -> Void

/**
View model class for the Calendar view.
*/
class CalendarViewModel {
	enum CalendarMonth: Int {
		case currentMonth = 0
		case nextMonth = 1
		case previousMonth = -1
		
		var offset: Int {
			return self.rawValue
		}
	}
	
	var selectedDates = [Date]()
	
	/**
	CalendarService is a required dependancy for getting the calendar details like month dates, month name, year, etc
	*/
	private let calendarService: CalendarService
	
	/**
	CalendarDetails contains details for a used selected month like month dates, month name, year, etc.
	*/
	private var calendarDetails: CalendarDetails?
	
	/**
	monthOffset represents the distance of user selected month from the current month. monthOffset fo the current calendar month is zero.
	For example: If the current month is June (offset = 0), offset for July month will be +1, offset for May month will be -1 and so on.
	*/
	private var monthOffset = 0
	
	var numberOfDatesInMonth: Int {
		guard let details = calendarDetails else { return 0 }
		return details.monthDates.count
	}
	
	init(calendarService: CalendarService) {
		self.calendarService = calendarService
	}
	
	/**
	Calls CalendarService to get CalendarDetails for a calendar month represented with monthOffset value
	*/
	func getDetails(for month: CalendarMonth, responseHandler: @escaping CalendarResponseHandler) {
		self.monthOffset += month.offset
		self.calendarService.getDetails(for: monthOffset) { details, error in
			guard let details = details, error == nil else {
				let errorDescription = "Oops, unable to get details for the selected month"
				responseHandler(nil, errorDescription)
				return
			}
			
			self.calendarDetails = details
			responseHandler(details, nil)
		}
	}
	
	/**
	Returns date objects to table view for its `cellForRowAt` lifecycle method
	*/
	func getDate(for index: Int) -> Date? {
		guard let details = self.calendarDetails,
			index < details.monthDates.count else { return nil }
		return details.monthDates[index]
	}
	
	
	/**
	Calls CalendarService to get details for a given date like date number, day of week (Mon, Tue, Wed, etc.)
	*/
	func getDetails(for date: Date, responseHandler: DateDetailsResponseHandler) {
		self.calendarService.getDetails(for: date, responseHandler: responseHandler)
	}
	
	/**
	Calls CalendarService to check if a given date is the current calendar date
	*/
	func isCurrentDate(date: Date) -> Bool {
		return self.calendarService.isCurrentDate(date: date)
	}
	
	/**
	If user taps on a calendar collection view cell, this method adds  (if not added already) the selected date to the list of user selected list
	*/
	func addDateToSelection(index: Int) {
		guard let details = self.calendarDetails,
			index < details.monthDates.count else { return }
		
		let date = details.monthDates[index]
		if !isDateAlreadySelected(date: date) {
			self.selectedDates.append(date)
		}
	}
	
	/**
	If user taps on a calendar collection view cell, this method removes (if it was added) the selected date to the list of user selected list
	*/
	func removeDateFromSelection(index: Int) {
		guard let details = self.calendarDetails,
			let dateIndex = self.selectedDates.firstIndex(of: details.monthDates[index]) else { return }
		self.selectedDates.remove(at: dateIndex)
	}
	
	/**
	Checks if a date is already added to the user selected list of dates so that we prevent adding duplicate dates
	*/
	private func isDateAlreadySelected(date: Date) -> Bool {
		var isSelected = false
		for selectedDate in self.selectedDates {
			let selectedDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: selectedDate)
			let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
			isSelected = selectedDateComponents.day == dateComponents.day && selectedDateComponents.month == dateComponents.month && selectedDateComponents.year == dateComponents.year
			
			if isSelected {
				return true
			}
		}
		return isSelected
	}
}
