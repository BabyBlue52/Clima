//
//  WeatherData.swift
//  Clima
//
//  Created by Chris Hennemann on 8/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}
// Nested values require seperate structs
struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
