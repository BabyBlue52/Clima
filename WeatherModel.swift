//
//  WeatherModel.swift
//  Clima
//
//  Created by Chris Hennemann on 8/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var fahrenheit: String {
        return String(format: "%.0f", temperature)
    }
    // Compouted Property
    // calculates what the property is
    var conditionName: String {
      switch conditionId{
        case 201...232: // Ranges
            return "cloud.bolt.rain"
        case 301...321:
            return "cloud.drizzle"
        case 501...531:
            return "cloud.rain"
        case 601...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "sun.min"
        }
    }
}
