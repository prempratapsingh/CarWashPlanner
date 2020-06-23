//
//  CalendarDataService.swift
//  CarFit
//
//  Created by Prem Pratap Singh on 20/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

/**
Protocol of CalendarService
*/
protocol CalendarService {
	func getDetails(for monthOffset: Int, responseHandler: @escaping CalendarDetailsResponseHandler)
	func getDetails(for date: Date, responseHandler: DateDetailsResponseHandler)
	func isCurrentDate(date: Date) -> Bool
}

typealias CalendarDetailsResponseHandler = (CalendarDetails?, CalendarServiceError?) -> Void
typealias DateDetailsResponseHandler = (Int, String) -> Void

/**
CalendarService is the service class for providing calendar specific details like month dates, month name, week of day, year details, etc.
*/
class CFCalendarService: CalendarService {
	var currentDate: Date = {
		let date = Date()
		return date
	}()
	
	private lazy var calendar: Calendar = {
		var calendr = Calendar.current
		if let timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "") {
			calendr.timeZone = timeZone
		}
		return calendr
	}()
	
	// forMonthOffset is the target month distance from the current month. It can have both positive and negative values.
	// Example: If current month is June, month offset for Junly will be +1 and and it will be -1 for May month.
	func getDetails(for monthOffset: Int, responseHandler: @escaping CalendarDetailsResponseHandler) {
		let dateComponents = DateComponents(year: self.calendar.component(.year, from: self.currentDate),
											month: self.calendar.component(.month, from: self.currentDate))
		
		guard let date = self.calendar.date(from: dateComponents),
			let dateForTargetMonth = self.calendar.date(byAdding: .month, value: monthOffset, to: date),
			let range = self.calendar.range(of: .day, in: .month, for: dateForTargetMonth) else {
				responseHandler(nil, .internalError)
				return
		}
		
		let startDateOfMonth = self.calendar.date(from: self.calendar.dateComponents([.year, .month],
																					 from: self.calendar.startOfDay(for: dateForTargetMonth)))!
		
		let monthDates = self.getMonthDates(for: startDateOfMonth, range: range)
		let monthTitle = self.getMonthTitle(for: dateForTargetMonth)
		let yearTitle = self.getYearTitle(for: dateForTargetMonth)
		
		let calendarDetails = CalendarDetails(monthDates: monthDates,
											  monthTitle: monthTitle,
											  yearTitle: yearTitle,
											  currentDateIndex: self.getCurrentDateIndex(from: monthDates))
		responseHandler(calendarDetails, nil)
	}
	
	func getDetails(for date: Date, responseHandler: DateDetailsResponseHandler) {
		let dayOfWeek = self.getDayOfWeek(for: date)
		let dateNumber = self.getDateNumber(for: date)
		
		responseHandler(dateNumber, dayOfWeek)
	}
	
	func isCurrentDate(date: Date) -> Bool {
		let dateComponents = self.calendar.dateComponents([.day, .month, .year], from: date)
		let currentDateComponents = self.calendar.dateComponents([.day, .month, .year], from: self.currentDate)
		
		return dateComponents.day == currentDateComponents.day &&
			dateComponents.month == currentDateComponents.month &&
			dateComponents.year == currentDateComponents.year
	}
	
	private func getCurrentDateIndex(from dates:[Date]) -> Int? {
		let currentDateIndex = dates.firstIndex(where: {
			let dateComponents = self.calendar.dateComponents([.day, .month, .year], from: $0)
			let currentDateComponents = self.calendar.dateComponents([.day, .month, .year], from: self.currentDate)
			
			return dateComponents.day == currentDateComponents.day &&
				dateComponents.month == currentDateComponents.month &&
				dateComponents.year == currentDateComponents.year
		})
		return currentDateIndex
	}
	
	func getMonthDates(for date: Date, range: Range<Int>) -> [Date] {
		var monthDates = [date]
		for i in 1..<range.count {
			if let nextDate = self.calendar.date(byAdding: .day, value: i, to: date) {
				monthDates.append(nextDate)
			}
		}
		return monthDates
	}
	
	private func getMonthTitle(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
	
	private func getYearTitle(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: date)
    }
	
	private func getDayOfWeek(for date: Date) -> String {
		let weekDay = self.calendar.component(.weekday, from: date)
		switch weekDay {
		case 1: return "Sun"
		case 2: return "Mon"
		case 3: return "Tue"
		case 4: return "Wed"
		case 5: return "Thr"
		case 6: return "Fri"
		case 7: return "Sat"
		default: return ""
		}
    }
	
	private func getDateNumber(for date: Date) -> Int {
		let number = self.calendar.component(.day, from: date)
        return number
    }
}

struct CalendarDetails {
	let monthDates: [Date]
	let monthTitle: String
	let yearTitle: String
	let currentDateIndex: Int?
	
	init(monthDates: [Date], monthTitle: String, yearTitle: String, currentDateIndex: Int?) {
		self.monthDates = monthDates
		self.monthTitle = monthTitle
		self.yearTitle = yearTitle
		self.currentDateIndex = currentDateIndex
	}
}

enum CalendarServiceError: String, CarFitError {
	case internalError = "Unable to get calendar details"
	
	var description: String {
		return self.rawValue
	}
}
