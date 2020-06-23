//
//  CalendarServiceTests.swift
//  CarFitTests
//
//  Created by Prem Pratap Singh on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import XCTest
@testable import CarFit

class CalendarServiceTests: XCTestCase {
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
	
	private var calendarService = CFCalendarService()
	private var currentMonthDates: [Date]?
	
    override func setUpWithError() throws {
       let dateComponents = DateComponents(year: self.calendar.component(.year, from: self.currentDate),
											month: self.calendar.component(.month, from: self.currentDate))
		
		guard let date = self.calendar.date(from: dateComponents),
			let dateForTargetMonth = self.calendar.date(byAdding: .month, value: 0, to: date),
			let range = self.calendar.range(of: .day, in: .month, for: dateForTargetMonth) else {
				return
		}
		
		let startDateOfMonth = self.calendar.date(from: self.calendar.dateComponents([.year, .month],
																					 from: self.calendar.startOfDay(for: dateForTargetMonth)))!
		
		self.currentMonthDates = self.calendarService.getMonthDates(for: startDateOfMonth, range: range)
    }

    override func tearDownWithError() throws {
		self.currentMonthDates?.removeAll()
		self.currentMonthDates = nil
    }

    func testCalendarServiceReturnsMonthDetailsSuccessfully() throws {
		self.calendarService.getDetails(for: 0) { details, error in
			XCTAssertNil(error, "Calendar service returns error")
			XCTAssertNotNil(details, "Calendar service fails to return month details")
			
			if let details = details, let currentMonthDates = self.currentMonthDates {
				XCTAssert(details.monthDates.count == currentMonthDates.count,
						  "Calendar service fails to return correct month details")
			}
		}
    }
}
