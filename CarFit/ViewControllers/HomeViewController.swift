//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit

class HomeViewController: UIViewController, AlertDisplayer {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var calendarView: UIView!
    @IBOutlet weak var calendar: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var workOrderTableView: UITableView!
	@IBOutlet weak var calendarViewTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var workOrderTableViewTopConstraint: NSLayoutConstraint!
	
	var viewModel: CleanerListViewModel!
	private var isCalendarHidden = true
	
	private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
		tapGestureRecognizer.numberOfTapsRequired = 1
		return tapGestureRecognizer
	}()
	
	private lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(self.refreshCarWashList(_:)), for: .valueChanged)
		return refreshControl
	}()
    
	/**
	Instantiates HomeViewController with the CleanerListViewModel passed to it as a required dependancy for
	getting assigned car wash task list and other related data specific jobs.
	
	HomeViewController doesn't pick the view model on it's own, rather it uses the one passed to it via the viewModel parameter
	*/
	static func getInstance(with viewModel: CleanerListViewModel) -> HomeViewController? {
		let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let homwViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return nil }
		homwViewController.viewModel = viewModel
		return homwViewController
	}
	
	//MARK:- Lifecycle methods
	deinit {
		self.workOrderTableView.removeGestureRecognizer(tapGestureRecognizer)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
        self.setupUI()
		self.addCalendar()
		self.setupGestureRecognizer()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.getCarWashVisits()
	}
	
    //MARK:- UI setups
    private func setupUI() {
        self.navBar.transparentNavigationBar()
		self.setupTableView()
		self.setupRefreshControl()
    }
	
	private func setupTableView() {
		let nib = UINib(nibName: HomeTableViewCell.cellID, bundle: nil)
        self.workOrderTableView.register(nib, forCellReuseIdentifier: HomeTableViewCell.cellID)
        self.workOrderTableView.rowHeight = UITableView.automaticDimension
        self.workOrderTableView.estimatedRowHeight = 170
		self.workOrderTableView.dataSource = self
		self.workOrderTableView.delegate = self
	}
	
	private func setupRefreshControl() {
		if #available(iOS 10.0, *) {
			 self.workOrderTableView.refreshControl = refreshControl
		} else {
			 self.workOrderTableView.addSubview(refreshControl)
		}
	}
	
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar) {
			calendar.delegate = self
			calendarViewTopConstraint.constant = -self.calendarView.frame.height
			workOrderTableViewTopConstraint.constant -= 90
        }
    }
	
	private func setupGestureRecognizer() {
		self.workOrderTableView.addGestureRecognizer(tapGestureRecognizer)
	}
	
	/**
	Toggles visibility of the Calendar view with a subtle animation effect
	*/
	private func toggleCalendarViewVisibility() {
		let calendarYPositionToAnimate: CGFloat = isCalendarHidden ? 0 : -calendarView.frame.height
		let tableViewYPositionToAnimate: CGFloat = isCalendarHidden ? 120 : self.workOrderTableViewTopConstraint.constant - 90
		self.calendarViewTopConstraint.constant = calendarYPositionToAnimate
		self.workOrderTableViewTopConstraint.constant = tableViewYPositionToAnimate
		
		UIView.animate(withDuration: 0.25,
					   animations: {
						self.view.layoutIfNeeded()
		},
					   completion: { didComplete in
						self.isCalendarHidden = !self.isCalendarHidden
		})
	}
	
	/**
	Calls view model to get the list of assigned car washes
	*/
	private func getCarWashVisits() {
		self.viewModel.getCarWashVisit { [weak self] didLoadVisits in
			guard let strongSelf = self else { return }
			DispatchQueue.main.async {
				strongSelf.refreshControl.endRefreshing()
				if !didLoadVisits {
					let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
					strongSelf.displayAlert(with: "Error",
											message: "Oops! Couldn't load car wash list, please try again later.",
											actions: [alertAction])
				}
			}
		}
	}
	
	/**
	Calls view model to sort the list of assigned cars washes based on the dates selected by the user from the calendar view
	Calls the table view to render the sorted car wash list after the view model is done with sorting the wash list
	*/
	private func sortCarWashVisits(for dates: [Date]) {
		self.viewModel.sortCarWashVisits(for: dates)
		self.workOrderTableView.reloadData()
	}
	
	/**
	Sets the navigation bar title with the date labels (Ex 22 Jun, 12 Jul, etc) of the dates selected by user from the calendar view
	*/
	private func setTitle(for dates: [Date]) {
		let sortedDates = dates.sorted(by: {$0.timeIntervalSince1970 < $1.timeIntervalSince1970})
		var title = ""
		
		for (index, date) in sortedDates.enumerated() {
			let dateTitle = self.viewModel.getTitle(for: date)
			if index == 0 {
				title = "\(dateTitle)"
			} else {
				title = "\(title), \(dateTitle)"
			}
		}
		
		self.navBar.topItem?.title = title
	}
    
	@IBAction func calendarTapped(_ sender: UIBarButtonItem) {
		self.toggleCalendarViewVisibility()
    }
	
	@objc func didTapOnView() {
		guard !self.isCalendarHidden else { return }
		self.toggleCalendarViewVisibility()
	}
	
	@objc private func refreshCarWashList(_ sender: Any) {
		self.getCarWashVisits()
	}
}


//MARK:- Tableview delegate and datasource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.numberOfCarWashVisits
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.cellID, for: indexPath) as? HomeTableViewCell,
			let visitDetails = self.viewModel.getCarWashVisit(for: indexPath.row) else { return HomeTableViewCell() }
		cell.update(with: visitDetails)
        return cell
    }
    
}

//MARK:- Get selected calendar date
extension HomeViewController: CalendarDelegate {
	
	/**
	This delegate method is called by the calendar view when user selects or deselects any of the calendar date.
	It calls the workflow to sort the assigned car wash tasks based on the user selected datea and than render the same
	sorted task list in the table view
	*/
    func getSelectedDates(_ dates: [Date]) {
		guard !dates.isEmpty else { return }
		self.setTitle(for: dates)
		self.sortCarWashVisits(for: dates)
    }
}
