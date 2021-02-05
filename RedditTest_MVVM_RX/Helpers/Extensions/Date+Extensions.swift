//
//  Date+Extensions.swift
//  TestWorkRaketa
//
//  Created by Vladimirus on 28.10.2020.
//

import Foundation


extension Date {
    func getString(format: String = "dd-MM-yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
