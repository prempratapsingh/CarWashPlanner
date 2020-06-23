//
//  LocalDataFile.swift
//  CarFit
//
//  Created by Prem Pratap Singh on 19/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

/**
Wrapper enumaration for local data file names
*/
enum LocalDataFile: String {
	case carVisits = "carfit"
	
	//for testing
	case carVisitsWrong = "carFitWrong"
	
	var value: String {
		return self.rawValue
	}
}

/**
Wrapper enumaration for local data file extensions
*/
enum LocalDataFileExtension: String {
	case json = "json"
	case xml = "xml"
	
	var value: String {
		return self.rawValue
	}
}
