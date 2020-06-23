//
//  DistanceCalculatorTests.swift
//  CarFitTests
//
//  Created by Prem Pratap Singh on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import XCTest
@testable import CarFit

class DistanceCalculatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDistanceCalculatorReturnsCorrectDistanceBetweenGeoLocations() throws {
		let geoLocationOne = GeoLocation(latitude: 55.778830, longitude: 12.521240)
		let geoLocationTwo = GeoLocation(latitude: 55.874530, longitude: 12.719670)
		let distanceBetweenGeoLocations = DistanceCalculator.getDistanceBetween(locationOne: geoLocationOne, locationTwo:geoLocationTwo)
		XCTAssert(distanceBetweenGeoLocations == 16.37632991878807, "Distance calculator returns wrong distance between the given two geo points")
    }
}
