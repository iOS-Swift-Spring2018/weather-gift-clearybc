//
//  TimeInterval+format.swift .swift
//  Barbara_WeatherGift
//
//  Created by Barbara on 3/27/18.
//  Copyright © 2018 Barbara. All rights reserved.
//

import Foundation


extension TimeInterval {
    
    func format(timeZone: String, dateFormatter: DateFormatter) -> String {
        let usableDate = Date(timeIntervalSince1970: self)
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        let dateString = dateFormatter.string(from: usableDate)
        return dateString
    }
    
}
