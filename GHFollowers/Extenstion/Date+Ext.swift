//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by M.Ali Sabouni on 16.12.2022.
//

import Foundation

extension Date {
  func convertToMonthYearFormatter() -> String {
    return formatted(.dateTime.month().year())
  }
}
