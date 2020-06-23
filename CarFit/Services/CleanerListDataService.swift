//
//  CleanerListDataService.swift
//  CarFit
//
//  Created by Prem Pratap Singh on 19/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

/**
Protocol for car wash list services
*/
protocol CleanerListService {
	func getCarWashVisits(responseHandler: @escaping WashVisitsResponseHandler)
}

typealias CarWashVisitResponseHandler = (CarWashVisitResult?, CarFitError?) -> Void

/**
CleanerListNetworkDataService is a service class for getting car wash list by making calls to network services via the NetworkService
*/
class CleanerListNetworkDataService: CleanerListService {
	func getCarWashVisits(responseHandler: @escaping WashVisitsResponseHandler) {
		self.getVisits { result, error in
			guard let result = result, error == nil else {
				responseHandler(nil)
				return
			}
			responseHandler(result.data)
		}
	}
	
	/**
	Calls NetworkDataService for getting list of assigned car wash tasks from a backend service
	*/
	private func getVisits(responseHandler: @escaping CarWashVisitResponseHandler) {
		let url = NetworkDataService.getSereviceUrl(for: .carWashVisits)
		let networkRequest = NetworkRequest(url: url, method: .get)
		let networkDataService = NetworkDataService()
		networkDataService.getData(request: networkRequest, responseHandler: responseHandler)
	}
}

/**
CleanerListFileDataService is the service class for getting car wash list from a given local data file
*/
class CleanerListFileDataService: CleanerListService {
	func getCarWashVisits(responseHandler: @escaping WashVisitsResponseHandler) {
		self.getVisits { result, error in
			guard let result = result, error == nil else {
				responseHandler(nil)
				return
			}
			responseHandler(result.data)
		}
	}
	
	/**
	Calls FileDataService for getting list of assigned car wash tasks from a local data file
	*/
	private func getVisits(responseHandler: @escaping CarWashVisitResponseHandler) {
		let fileDataService = FileDataService()
		fileDataService.getData(for: LocalDataFile.carVisits,
								fileExtension: LocalDataFileExtension.json,
								responseHandler: responseHandler)
	}
}
