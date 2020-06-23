//
//  NetworkDataServiceTests.swift
//  CarFitTests
//
//  Test Project
//

import XCTest
@testable import CarFit

typealias CatBreedsResponseHandler = (CatBreedsResponse?, CarFitError?) -> Void

struct CatBreedsResponse: Codable {
	let current_page: Int
	let data: [CatBreed]
}

struct CatBreed: Codable {
	let breed: String
	let country: String
	let origin: String
	let coat: String
	let pattern: String
}

class NetworkDataServiceTests: XCTestCase {
	private var result: CatBreedsResponse?
	private var error: CarFitError?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetworkDataServiceReturnsCatBreadsSuccessfully() throws {
		let expectation = self.expectation(description: "Loading cat breeds data")
		let url = NetworkDataService.getSereviceUrl(for: .testCatBreads, isTestMode: true)
		self.callService(with: url, expectation: expectation)
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNil(error, "Network data service returns error")
		XCTAssertNotNil(result, "Network data service fails to return result")
		
		if let result = self.result {
			let visits = result.data
			XCTAssertTrue(visits.count == 10, "Network data service returns incomplete result")
		}
    }
	
	func testNetworkDataServiceFailsWithWrongURL() throws {
		let expectation = self.expectation(description: "Loading cat breeds data")
		let url = NetworkDataService.getSereviceUrl(for: .testCatBreadsWrong, isTestMode: true)
		self.callService(with: url, expectation: expectation)
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(error, "Network data service doesn't return error for wrong service url")
		XCTAssertNil(result, "Network data service returns result for wrong service url")
    }
	
	private func callService(with url: String, expectation: XCTestExpectation) {
		self.getVisits(url: url) { result, error in
			self.result = result
			self.error = error
			expectation.fulfill()
		}
	}
	
	private func getVisits(url: String, responseHandler: @escaping CatBreedsResponseHandler) {
		let parameters = ["limit": "10"]
		let networkRequest = NetworkRequest(url: url, method: .get, parameters: parameters)
		let networkDataService = NetworkDataService()
		networkDataService.getData(request: networkRequest, responseHandler: responseHandler)
	}

}
