//
//  Date+extensions.swift
//  DollarCalculator
//
//  Created by YANA on 31/03/2022.
//

import Foundation

extension Date {
    
    var MMYYFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
}
