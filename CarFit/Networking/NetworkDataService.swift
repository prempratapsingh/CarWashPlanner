//
//  NetworkDataService.swift
//  CarFit
//
//  Created by Prem Pratap Singh on 19/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

/**
NetworkDataService calls a given backend API for loading the required data.
It supports generic concept so that it could be used to load data from any API and parsing the loaded data
to any Codable object
*/
struct NetworkDataService {
	
	static func getSereviceUrl(for endpoing: NetworkEndpoint, isTestMode: Bool = false) -> String {
		if isTestMode {
			return "\(NetworkEnvironment.test.value)\(endpoing.value)"
		}
		
		#if DEBUG
		return "\(NetworkEnvironment.development.value)\(endpoing.value)"
		#else
		return "\(NetworkEnvironment.production.value)\(endpoint.value)"
		#endif
	}
	
	func getData<T: Codable>(request: NetworkRequest, responseHandler: @escaping ResponseHandler<T>) {
		guard !request.url.isEmpty,
			var urlComponents = URLComponents(string: request.url) else {
			responseHandler(nil, NetworkError.internalError)
			return
		}
		
		if let parameters = request.parameters {
			var queryItems = [URLQueryItem]()
			for (key,value) in parameters {
				queryItems.append(URLQueryItem(name: key, value: value as? String ?? ""))
			}
			urlComponents.queryItems = queryItems
		}
		
		guard let url = urlComponents.url else {
			responseHandler(nil, NetworkError.internalError)
			return
		}
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.method.value
		urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
		
		let session = URLSession(configuration: .default)
		let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
			guard error == nil else {
				responseHandler(nil, NetworkError.serverError)
				return
			}
			
			guard let data = data else {
				responseHandler(nil, NetworkError.serverError)
				return
			}
			
			do {
				let decoder = JSONDecoder()
				let result = try decoder.decode(T.self, from: data)
				responseHandler(result, nil)
			} catch {
				responseHandler(nil, NetworkError.jsonParsingError)
			}
		}
		dataTask.resume()
	}
}

/**
Wrapper enumeration for API environments
*/
enum NetworkEnvironment: String {
	case development = "https://dev.carfit.com/services"
	case production = "https://carfit.com/services"
	
	//For testing purpose
	case test = "https://catfact.ninja"
	
	var value: String {
		return self.rawValue
	}
}

/**
Wrapper enumeration for API endpoints
*/
enum NetworkEndpoint: String {
	case carWashVisits = "/visits"
	
	//For testing purpose
	case testCatBreads = "/breeds"
	case testCatBreadsWrong = "/cat-breeds"
	
	var value: String {
		return self.rawValue
	}
}

/**
Wrapper object for for url requests
*/
struct NetworkRequest {
	let url: String
	let method: NetworkMethod
	let parameters: [String: Any]?
	
	init(url: String, method: NetworkMethod, parameters: [String: Any]? = nil) {
		self.url = url
		self.method = method
		self.parameters = parameters
	}
}

/**
Wrapper enumeration for url session methods
*/
enum NetworkMethod: String {
	case post
	case get
	case put
	case delete
	
	var value: String {
		return self.rawValue
	}
}

/**
Wrapper enumeration for errors specific to network service
*/
enum NetworkError: String, CarFitError {
	case internalError = "Network call failed due to some internal error"
	case serverError = "Error occurred while connecting to the server"
	case jsonParsingError = "Unable to parse JSON response"
	case nilResponseError = "Server didn't return any result"
	
	var description: String {
		return self.rawValue
	}
}
