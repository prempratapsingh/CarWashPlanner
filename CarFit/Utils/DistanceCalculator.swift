//
//  DistanceCalculator.swift
//  CarFit
//
//  Created by Prem Pratap Singh on 20/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
import CoreLocation

/**
Data object for geo location details like latitude and longitude
*/
struct GeoLocation {
	let latitude: Double
	let longitude: Double
	
	init(latitude: Double, longitude: Double) {
		self.latitude = latitude
		self.longitude = longitude
	}
}

struct DistanceCalculator {
	
	/**
	Uses CoreLocation API for calculating distance between given geo locations and returns the distance as kilometers
	*/
	static func getDistanceBetween(locationOne: GeoLocation, locationTwo: GeoLocation) -> Double {
		let locationOneCoordinate = CLLocation(latitude: locationOne.latitude, longitude: locationOne.longitude)
		let locationTwoCoordinate = CLLocation(latitude: locationTwo.latitude, longitude: locationTwo.longitude)
		let distanceInMeters = locationOneCoordinate.distance(from: locationTwoCoordinate)
		let distanceInKilometers = distanceInMeters/1000 //1 KM = 1000 meter
		return distanceInKilometers
	}
}
