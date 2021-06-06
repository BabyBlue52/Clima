//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

// Becomes weather manger
class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    // Load instance of Struct
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self // Must come before requests
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self // WeatherManager prop != nil :D
        searchTextField.delegate = self
       
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
        @IBAction func searchPressed(_ sender: UIButton) {
           searchTextField.endEditing(true)
       }
       
       // text field hanldes return press
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           searchTextField.endEditing(true)
           return true // must be true to trigger
           
       }
       
       // Clear text field, or add placeholder message
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           if textField.text != "" {
               return true
           } else {
               textField.placeholder = "Type Something"
               return false
           }
       }
       
       func textFieldDidEndEditing(_ textField: UITextField) {
           // optional string
           if let city = searchTextField.text {
               weatherManager.fetchAPI(cityName: city)
              
           } else {
               //Do nothing
           }
           
           searchTextField.text = ""
       }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    //function reqiured by protocol (CLASS)
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.fahrenheit
            self.cityLabel.text = weather.cityName
            //System
            if #available(iOS 13.0, *) {
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    //function reqiured by protocol (CLASS)
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - LocationDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    @IBAction func getCurrentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
 
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation() // Halt the device from seraching locations
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchCoordinate(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
