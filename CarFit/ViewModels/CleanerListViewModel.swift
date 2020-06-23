//
//  CleanerListViewModel.swift
//  CarFit
//
//  Created by Prem Pratap Singh on 19/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

/**
View model class for the Home view.
*/
class CleanerListViewModel {
	
	/**
	This is a required dependancy for getting the list of assigned car wash tasks
	*/
	private var cleanerService: CleanerListService
	
	var numberOfCarWashVisits: Int {
		return  self.sortedVisits.count
	}
	
	private var visits = [CarWashVisit]()
	private var sortedVisits = [CarWashVisit]()
	
	init(cleanerService: CleanerListService) {
		self.cleanerService = cleanerService
	}
	
	/**
	Calls CleanerListService to get the list of assigned car wash tasks
	*/
	func getCarWashVisit(responseHandler: @escaping BoolResponseHandler) {
		self.cleanerService.getCarWashVisits { visits in
			guard let visits = visits else {
				responseHandler(false)
				return
			}
			self.visits = visits
			responseHandler(true)
		}
	}
	
	/**
	Returns a car wash task to the table view `cellForRowAt` lifecycle method
	*/
	func getCarWashVisit(for index: Int) -> CarWashVisit? {
		guard index < self.sortedVisits.count else { return nil }
		return  self.sortedVisits[index]
	}
	
	/**
	Sorts the list of assigned car wash tasks based on the given list of user selected dates
	*/
	func sortCarWashVisits(for dates: [Date]) {
		self.sortedVisits.removeAll()
		
		for date in dates {
			let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
			for visit in self.visits {
				if let visitDate = visit.visitDate {
					let visitDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: visitDate)
					if  visitDateComponents.day == dateComponents.day,
						visitDateComponents.month == dateComponents.month,
						visitDateComponents.year == dateComponents.year {
						self.sortedVisits.append(visit)
					}
				}
			}
		}
		
		self.setDistanceBetween(visits: &self.sortedVisits)
	}
	
	/**
	Returns date label (Ex. 22 Jun, 12 Jul, etc) for a given date object
	*/
	func getTitle(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        return dateFormatter.string(from: date)
    }
	
	/**
	Uses DistanceCalculator utility to calculate distance between two car wash task's geo location
	The calculated distance is used for the sorted task list so that the table view displays the distance in correct sequence
	*/
	private func setDistanceBetween(visits: inout [CarWashVisit]) {
		guard !visits.isEmpty else { return }
		for index in 1..<visits.count {
			let currentVisit = visits[index]
			let previousVisit = visits[index - 1]
			
			let distanceBetweenVisits = DistanceCalculator.getDistanceBetween(
				locationOne: GeoLocation(latitude: currentVisit.houseOwnerLatitude, longitude: currentVisit.houseOwnerLongitude),
				locationTwo: GeoLocation(latitude: previousVisit.houseOwnerLatitude, longitude: previousVisit.houseOwnerLongitude))
			visits[index].geoDistance = distanceBetweenVisits
		}
	}
}
