//
//  CalendarViewModelTests.swift
//  CarFitTests
//
//  Created by Prem Pratap Singh on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import XCTest
@testable import CarFit

class CalendarViewModelTests: XCTestCase {
	private var calendarViewModel: CalendarViewModel?
	
    override func setUpWithError() throws {
        let calendarService = CFCalendarService()
		self.calendarViewModel = CalendarViewModel(calendarService: calendarService)
    }

    override func tearDownWithError() throws {
		self.calendarViewModel = nil
    }

    func testCalendarViewModuleReturnsMonthDetailsSuccessfully() throws {
		self.calendarViewModel?.getDetails(for: .currentMonth) { details, error in
			XCTAssertNil(error, "CalendarViewModel returns error for getting month details")
			XCTAssertNotNil(details, "CalendarViewModel doesn't return month details")
		}
    }
}
