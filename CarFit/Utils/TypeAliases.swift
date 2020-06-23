//
//  TypeAliases.swift
//  CarFit
//
//  Created by Prem Pratap Singh on 19/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

typealias BoolResponseHandler = (Bool) -> Void
typealias WashVisitsResponseHandler = ([CarWashVisit]?) -> Void
typealias ResponseHandler<T: Codable> = (T?, CarFitError?) -> Void
