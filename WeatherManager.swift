//
//  WeatherManager.swift
//  Clima
//
//  Created by Chris Hennemann on 8/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) //reqiurements
    func didFailWithError(error: Error)
}

// Reusable struct w/ delegate
struct WeatherManager {
    // API should be handled in the struct
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ec029d7f87f2fe8e4a711d0b8fb84d37&units=imperial"
    
    // sets itself as the delegate
    var delegate: WeatherManagerDelegate?
    
    func fetchAPI(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchCoordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=ec029d7f87f2fe8e4a711d0b8fb84d37&units=imperial"
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String) {
        // 1. Create a URL
                            // Optional URL
        if let url = URL(string: urlString) {
            
            // 2. Create URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give URLSession a task                 //Anonymous func
            let task = session.dataTask(with: url){ (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                          return // exit function
                      }
                      
                      if let safeData = data { // weather is now an optional
                        if let weather = self.parseJSON(safeData){
                            // Properly introduce delegate in closure
                            self.delegate?.didUpdateWeather(self, weather:weather)
                            // Optional?chain and is not nil
                        }
                      }
            }
            
            // 4. Start task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
