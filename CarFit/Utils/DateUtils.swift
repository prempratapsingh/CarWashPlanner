//
//  DateUtils.swift
//  CarFit
//
//  Created by Prem Pratap Singh on 22/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

class DateUtils {
	
	/**
	Returns Date object for a given UTC time stamp (Ex:  `2020-06-21T08:05:00`)
	*/
	static func getDate(from utcDateString: String) -> Date? {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		let date = formatter.date(from: utcDateString)
		return date
	}
}

