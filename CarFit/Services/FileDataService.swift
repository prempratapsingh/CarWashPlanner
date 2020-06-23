//
//  FileDataService.swift
//  CarFit
//
//  Created by Prem Pratap Singh on 20/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

/**
FileDataService uses iOS API for loading content from a given file name and extencion.
It supports generic concept so that it could be used to load data from any given local file and parsing the loaded data
to any Codable object
*/
struct FileDataService {
	func getData<T: Codable>(for fileName: LocalDataFile,
							 fileExtension: LocalDataFileExtension,
							 responseHandler: @escaping ResponseHandler<T>) {
		
		guard let url = Bundle.main.url(forResource: fileName.value, withExtension: fileExtension.value) else {
			responseHandler(nil, FileDataServiceError.fileNotFound)
			return
		}
		
		do {
			let data = try Data(contentsOf: url)
			let decoder = JSONDecoder()
			let result = try decoder.decode(T.self, from: data)
			responseHandler(result, nil)
		} catch {
			responseHandler(nil, FileDataServiceError.dataParseError)
		}
	}
}

/**
Wrapper enumeration for errors specific to the file data service
*/
enum FileDataServiceError: String, CarFitError {
	case fileNotFound = "Couldn't find the given file"
	case dataParseError = "Unable to parse file data"
	
	var description: String {
		return self.rawValue
	}
}
