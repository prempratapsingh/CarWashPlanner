//
//  CarWashVisit.swift
//  CarFit
//
//  Created by Prem Pratap Singh on 19/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import UIKit

/**
Codable model objects for car wash tasks
*/

struct CarWashVisitResult: Codable {
	let success: Bool
	let message: String
	let data: [CarWashVisit]
	let code: Int
}

struct CarWashVisit: Codable {
	let visitId: String
	let homeBobEmployeeId: String
	let houseOwnerId: String
	let startTimeUtc: String
	let endTimeUtc: String
	let title: String
	let isManual: Bool
	let visitTimeUsed: Int
	let houseOwnerFirstName: String
	let houseOwnerLastName: String
	let houseOwnerMobilePhone: String
	let houseOwnerAddress: String
	let houseOwnerZip: String
	let houseOwnerCity: String
	let houseOwnerLatitude: Double
	let houseOwnerLongitude: Double
	let isSubscriber: Bool
	let visitState: VisitState
	let stateOrder: Int
	let expectedTime: String?
	let tasks: [CarWashTask]
	
	var geoDistance: Double = 0
	
	var visitDate: Date? {
		return DateUtils.getDate(from: self.startTimeUtc)
    }
	
	private enum CodingKeys: String, CodingKey {
		case visitId, homeBobEmployeeId, houseOwnerId, startTimeUtc, endTimeUtc, title, isManual,
			visitTimeUsed, houseOwnerFirstName, houseOwnerLastName, houseOwnerMobilePhone, houseOwnerAddress,
			houseOwnerZip, houseOwnerCity, houseOwnerLatitude, houseOwnerLongitude, isSubscriber, visitState,
			stateOrder, expectedTime, tasks
	}
}

struct CarWashTask: Codable {
	let taskId: String
	let title: String
	let isTemplate: Bool
	let timesInMinutes: Int
	let price: Double
	let paymentTypeId: String
	let createDateUtc: String
	let lastUpdateDateUtc: String
}

enum VisitState: String, Codable {
	case done = "Done"
	case inProgress = "InProgress"
	case todo = "ToDo"
	case rejected = "Rejected"
	
	var value: String {
		switch self {
		case .done: return "Done"
		case .inProgress: return "In Progress"
		case .todo: return "To Do"
		case .rejected: return "Rejected"
		}
	}
	
	var color: UIColor {
		switch self {
		case .done:
			return UIColor.doneOption
		case .inProgress:
			return UIColor.inProgressOption
		case .rejected:
			return UIColor.rejectedOption
		case .todo:
			return UIColor.todoOption
		}
	}
}

struct CatBreedsResult: Codable {
	let data: [CatBreed]
}

struct CatBreed: Codable {
	let breed: String
	let country: String
	let origin: String
	let coat: String
	let pattern: String
}
