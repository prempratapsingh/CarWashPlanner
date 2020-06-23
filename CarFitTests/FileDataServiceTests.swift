//
//  FileDataServiceTests.swift
//  CarFitTests
//
//  Created by Prem Pratap Singh on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import XCTest
@testable import CarFit

class FileDataServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFileDataServiceReturnsCarWashListSucessfully() throws {
		self.getVisits(for: .carVisits) { result, error in
			XCTAssertNil(error, "File data service returns error")
			XCTAssertNotNil(result, "File data service fails to return result")
			
			if let result = result {
				let visits = result.data
				XCTAssertTrue(visits.count == 7, "Network data service returns incomplete result")
			}
		}
    }
	
	func testFileDataServiceFailsWithWrongFile() throws {
		self.getVisits(for: .carVisitsWrong) { result, error in
			XCTAssertNotNil(error, "File data service returns error")
			XCTAssertNil(result, "File data service fails to return result")
		}
    }
	
	private func getVisits(for file: LocalDataFile, responseHandler: @escaping CarWashVisitResponseHandler) {
		let fileDataService = FileDataService()
		fileDataService.getData(for: file,
								fileExtension: LocalDataFileExtension.json,
								responseHandler: responseHandler)
	}

}
