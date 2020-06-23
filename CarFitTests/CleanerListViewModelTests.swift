//
//  CleanerListViewModelTests.swift
//  CarFitTests
//
//  Created by Prem Pratap Singh on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import XCTest
@testable import CarFit

class CleanerListViewModelTests: XCTestCase {
	private var cleanerListModel: CleanerListViewModel?
	
    override func setUpWithError() throws {
        let cleanerService = CleanerListFileDataService()
		self.cleanerListModel = CleanerListViewModel(cleanerService: cleanerService)
    }

    override func tearDownWithError() throws {
        self.cleanerListModel = nil
    }

    func testCleanerListViewModelLoadsTasksSuccessfully() throws {
        self.cleanerListModel?.getCarWashVisit { didLoadVisits in
			XCTAssertTrue(didLoadVisits, "CleanerListViewModel doesn't return car was task list")
		}
    }
	
	func testCleanerListViewModelSortsTasksSuccessfully() throws {
		self.cleanerListModel?.getCarWashVisit { didLoadVisits in
			if didLoadVisits {
				if let date = DateUtils.getDate(from: "2020-06-21T08:05:00") {
					self.cleanerListModel?.sortCarWashVisits(for: [date])
					XCTAssertTrue(self.cleanerListModel?.numberOfCarWashVisits == 2,
								  "CleanerListViewModel doesn't sort car wash task correctly")
				} else {
					XCTFail("Date util doesn't return valid date")
				}
			} else {
				XCTFail("CleanerListViewModel doesn't return car was task list")
			}
		}
	}
}
