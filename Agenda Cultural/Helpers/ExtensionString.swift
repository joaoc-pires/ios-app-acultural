//
//  ExtensionString.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 09/12/2021.
//

import Foundation

extension String {
    
    var fromDate: String {
        
        let year = String(self.prefix(4))
        let month = String(self.suffix(2))
        if let monthInt = Int(month) {
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "pt_PT")
            let monthName = formatter.monthSymbols[monthInt - 1]
            
            return "\(monthName.capitalized) \(year)"
        }
        else {
            return self
        }
    }
}
