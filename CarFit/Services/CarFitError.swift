//
//  CarFitError.swift
//  CarFit
//
//  Created by Prem Pratap Singh on 20/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

protocol CarFitError: Error {
	var description: String { get }
}
