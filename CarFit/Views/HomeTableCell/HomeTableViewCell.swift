//
//  HomeTableViewCell.swift
//  Calendar
//
//  Test Project
//

import UIKit
import CoreLocation

class HomeTableViewCell: UITableViewCell {
	static let cellID = "HomeTableViewCell"
	
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var timeRequired: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10.0
        self.statusView.layer.cornerRadius = self.status.frame.height / 2.0
        self.statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
	
	/**
	Displays the car wash task details, as provided with CarWashVisit model object
	*/
	func update(with visitDetails: CarWashVisit) {
		self.statusView.backgroundColor = visitDetails.visitState.color
		self.status.text = visitDetails.visitState.value
		
		self.customer.text = "\(visitDetails.houseOwnerFirstName) \(visitDetails.houseOwnerLastName)"
		self.destination.text = "\(visitDetails.houseOwnerAddress) \(visitDetails.houseOwnerZip) \(visitDetails.houseOwnerCity)"
		
		var taskDescription = ""
		var totalTimeRequired = 0
		for (index, task) in visitDetails.tasks.enumerated() {
			if index == 0 {
				taskDescription = task.title
			} else {
				taskDescription = "\(taskDescription), \(task.title)"
			}
			totalTimeRequired += task.timesInMinutes
		}
		self.tasks.text = taskDescription
		self.timeRequired.text = "\(totalTimeRequired)"
		self.arrivalTime.text = visitDetails.expectedTime ?? ""
		self.distance.adjustsFontSizeToFitWidth = true
		self.distance.text = visitDetails.geoDistance > 0 ? "\(String(format: "%.2f", visitDetails.geoDistance)) Km" : "0 Km"
	}
}
