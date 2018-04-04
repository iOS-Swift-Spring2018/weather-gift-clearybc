//
//  WeatherLocation.swift
//  Barbara_WeatherGift
//
//  Created by Barbara on 3/23/18.
//  Copyright © 2018 Barbara. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation {
    
    struct DailyForcast{
        var dailyMaxTemp: Double
        var dailyMinTemp: Double
        var dailySummary: String
        var dailyDate: Double
        var dailyIcon: String
    }
    
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    var currentSummary = "--"
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    var dailyForcastArray = [DailyForcast]()
    

    func getWeather(completed: @escaping () -> ()){
        let weatherURL = urlBase + urlAPIKey + coordinates 
        
        Alamofire.request(weatherURL).responseJSON{ response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json ["currently"]["temperature"].double{
                    print("*** temp = \(temperature)")
                    let roundedTemp = String(format: "%3.f", temperature)
                    self.currentTemp = roundedTemp + "°"
                } else {
                    print("did not return a temp")
                }
                if let summary = json ["minutely"]["summary"].string {
                    print("summary = \(summary)")
                    self.currentSummary = summary
                }else {
                    print("did not return summary")
                }
                if let icon = json ["currently"]["icon"].string {
                    self.currentIcon = icon
                }else {
                    print("did not return an icon")
                }
                if let timeZone = json ["timezone"].string {
                     print("Time zone for \(self.name) is \(timeZone)")
                    self.timeZone = timeZone
                }else {
                    print("did not return an timeZone")
                }
                if let time = json ["currently"]["time"].double {
                    print("Time for \(self.name) is \(time)")
                    self.currentTime = time
                }else {
                    print("did not return an time")
                }
                
                let dailyDataArray = json["daily"]["data"]
                self.dailyForcastArray = []
                for day in 1...dailyDataArray.count - 1 {
                    let maxTemp = json["daily"]["data"][day]["temperatureHigh"].doubleValue
                    let minTemp = json["daily"]["data"][day]["temperatureLow"].doubleValue
                    let dateValue = json["daily"]["data"][day]["time"].doubleValue
                    let icon = json["daily"]["data"][day]["icon"].stringValue
                    let dailySummary = json["daily"]["data"][day]["summary"].stringValue
                    let newDailyForcast = DailyForcast(dailyMaxTemp: maxTemp, dailyMinTemp: minTemp, dailySummary: dailySummary, dailyDate: dateValue, dailyIcon: icon)
                    self.dailyForcastArray.append(newDailyForcast)
                }
                
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
