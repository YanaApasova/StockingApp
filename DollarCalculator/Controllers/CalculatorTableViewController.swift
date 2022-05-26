//
//  CalculatorTableViewController.swift
//  DollarCalculator
//
//  Created by YANA on 22/03/2022.
//

import Foundation
import UIKit
import Combine

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingTextField: UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var investamentAmountCurrencyLable: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var dateSlider: UISlider!
    
    var asset: Asset?
    @Published private var initialDateOfInvestment: Int?
    
    private var subscribers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextFields()
        setuoDateSlider()
        observeForm()
    }
    
    private func setupViews(){
        symbolLabel.text = asset?.searchResult.symbol
        assetNameLabel.text = asset?.searchResult.name
        investamentAmountCurrencyLable.text = asset?.searchResult.currency
        currencyLabels.forEach { (label) in
            label.text = asset?.searchResult.currency.addBrackets()
        }
    }
    
    private func setupTextFields(){
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDollarCostAveragingTextField.addDoneButton()
        initialDateOfInvestmentTextField.delegate = self
    }
    
    private func setupDateSlider(){
        if let count = asset?.timeSeriesMonthlyAdjusted.getMonthInfos().count {
            let dateSliderCount = count - 1
            dateSlider.maximumValue = dateSliderCount.floatValue
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDateSelection",
           let dateSelectionViewController = segue.destination as? DateSelectionViewController,
           let timeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted {
            dateSelectionViewController.timeSeriesMonthlyAdjusted = timeSeriesMonthlyAdjusted
            dateSelectionViewController.selectedIndex = initialDateOfInvestment
            dateSelectionViewController.didSelectDate = { [weak self] index in
                self?.handleDateSelection(at: index)
            }
        }
    }
    
    private func handleDateSelection(at index: Int) {
        guard navigationController?.visibleViewController is DateSelectionViewController else {return}
        navigationController?.popViewController(animated: true)
        if let monthInfos = asset?.timeSeriesMonthlyAdjusted.getMonthInfos() {
            initialDateOfInvestment = index
            let monthInfo = monthInfos[index]
            let datesString = monthInfo.date.MMYYFormat
            initialDateOfInvestmentTextField.text = datesString
        }
    }
    
    
    @IBAction func didChangeDateSlider(_ sender: UISlider) {
        initialDateOfInvestment = Int(sender.value)
    }
    
    private func observeForm(){
        $initialDateOfInvestment.sink { [weak self] (index) in
            guard let index = index else {return}
            self?.dateSlider.value = index.floatValue
            if let dateString = self?.asset?.timeSeriesMonthlyAdjusted.getMonthInfos()[index].date.MMYYFormat {
                self?.initialDateOfInvestmentTextField.text = dateString
            }
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestmentAmountTextField).compactMap ({ ($0.object as? UITextField)?.text
        }).sink { (text) in
            print(text)
        }.store(in: &subscribers)
    }
}

extension CalculatorTableViewController:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialDateOfInvestmentTextField{
            performSegue(withIdentifier: "showDateSelection", sender: asset?.timeSeriesMonthlyAdjusted)
            return false
        }
        return true
    }
}
