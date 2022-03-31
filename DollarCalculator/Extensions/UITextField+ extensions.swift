//
//  UITextField+ extensions.swift
//  DollarCalculator
//
//  Created by YANA on 24/03/2022.
//

import UIKit

extension UITextField {
    
    func addDoneButton() {
        let screenWidth = UIScreen.main.bounds.width
        let doneToolBar: UIToolbar = UIToolbar(frame: .init(x: 0, y: 0, width: screenWidth, height: 50))
        doneToolBar.barStyle = .default
        let flexSpace = UIBarButtonItem(systemItem: .flexibleSpace, primaryAction: nil, menu: nil)
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyBoard))
        let items = [flexSpace, doneBarButtonItem]
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        inputAccessoryView = doneToolBar
    }
    
    @objc private func dismissKeyBoard() {
        resignFirstResponder()
    }
}
