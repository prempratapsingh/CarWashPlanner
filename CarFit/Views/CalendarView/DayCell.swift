//
//  DayCell.swift
//  Calendar
//
//  Test Project
//

import UIKit

class DayCell: UICollectionViewCell {
	
	static let cellID = "DayCell"
    
	@IBOutlet weak var dayView: UIView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weekday: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dayView.layer.cornerRadius = self.dayView.frame.width / 2.0
        self.dayView.backgroundColor = .clear
    }
	
	override var isSelected: Bool {
		didSet {
			if isSelected {
				drawSelectionIndicator()
			} else {
				removeSelectionIndicator()
			}
		}
	}
	
	func update(with date: Int, weekDay: String) {
		self.day.text = "\(date)"
		self.weekday.text = weekDay
	}
	
	private func drawSelectionIndicator() {
		self.dayView.backgroundColor = UIColor.daySelected
		self.dayView.layer.cornerRadius = self.dayView.frame.width * 0.5
	}
	
	private func removeSelectionIndicator() {
		self.dayView.backgroundColor = .clear
	}
}
