//
//  DayWeatherCell.swift
//  Barbara_WeatherGift
//
//  Created by Barbara on 3/27/18.
//  Copyright © 2018 Barbara. All rights reserved.
//

import UIKit

//only done once, privately within DayWeatherCell

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
}()

class DayWeatherCell: UITableViewCell {
    @IBOutlet weak var dayCellIcon: UIImageView!
    @IBOutlet weak var dayCellWeekday: UILabel!
    @IBOutlet weak var dayCellMaxTemp: UILabel!
    @IBOutlet weak var dayCellMinTemp: UILabel!
    @IBOutlet weak var dayCellSummary: UITextView!

 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func update(with dailyForcast: WeatherLocation.DailyForcast, timeZone: String){
        dayCellIcon.image = UIImage(named: dailyForcast.dailyIcon)
        dayCellSummary.text = dailyForcast.dailySummary
        dayCellMaxTemp.text = String(format: "%2.f", dailyForcast.dailyMaxTemp) + "°"
        dayCellMinTemp.text = String(format: "%2.f", dailyForcast.dailyMinTemp) + "°"
        
//    let usableDate = Date(timeIntervalSince1970: dailyForcast.dailyDate)
//        dateFormatter.timeZone = TimeZone(identifier: timeZone)
//        let dateString = dateFormatter.string(from: usableDate)
        
        let dateString = dailyForcast.dailyDate.format(timeZone: timeZone, dateFormatter: dateFormatter)
        dayCellWeekday.text = dateString
        
    }
    
}
