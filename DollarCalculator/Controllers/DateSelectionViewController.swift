//
//  DateSelectionViewController.swift
//  DollarCalculator
//
//  Created by YANA on 28/03/2022.
//

import UIKit

class DateSelectionViewController: UITableViewController {
    
    var timeSeriesMonthlyAdjusted:TimeSeriesMonthlyAdjusted?
    private var monthInfos: [MonthInfo] = []
    var didSelectDate: ((Int) -> Void)?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
    }
    
    private func setupNavigation(){
        title = "Select date"
    }
    
    private func setupView() {
        monthInfos = timeSeriesMonthlyAdjusted?.getMonthInfos() ?? []
    }
    
}

extension DateSelectionViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthInfos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let monthInfo = monthInfos[indexPath.item]
        let index = indexPath.item
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DateSelectionTableViewCell
        let isSelected = index == selectedIndex
        cell.configure(with: monthInfo, index: index, isSelected: isSelected)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectDate?(indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class DateSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!
    
    func configure(with monthInfo: MonthInfo, index: Int, isSelected: Bool) {
        dateLabel.text = monthInfo.date.MMYYFormat
        accessoryType = isSelected ? .checkmark : .none
        if index == 1 {
            monthsAgoLabel.text = " 1 month ago"
        }
        else if index > 1 {
            monthsAgoLabel.text = "\(index) months"
        } else {
            monthsAgoLabel.text = "Just invested"
        }
    }
}
