//
//  ViewController.swift
//  WeatherApp
//
//  Created by ChelseaAnne Castelli on 6/8/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var background: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    func getData() {
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?zip=10309,us&appid=f40963e13db745094d9c217cd5f38abb") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else { return }
                    guard let weatherDetails = json["weather"] as? [[String : Any]], let weatherMain = json["main"] as? [String : Any] else { return }
                    let tempKelvin = weatherMain["temp"]
                    let tempFahrenheit = self.convertToFahrenheit(kelvin: Double(tempKelvin as? Double ?? 0))
                    let description = (weatherDetails.first?["description"] as? String)?.capitalizingFirstLetter()
                    DispatchQueue.main.async {
                        self.setWeather(weather: weatherDetails.first?["main"] as? String, description: description, temp: Int(tempFahrenheit))
                    }
                } catch {
                    print("We had an error retrieving the weather data...")
                }
            }
        }
        task.resume()
    }
    
    func convertToFahrenheit(kelvin: Double) -> Int {
        let kelTemp = 1.8*(kelvin-273)+32
        return Int(kelTemp)
    }
    
    func setWeather(weather: String?, description: String?, temp: Int) {
        weatherDescriptionLabel.text = description ?? ".."
        tempLabel.text = "\(temp)°"
        
        if weather!.lowercased().contains("sun") || weather!.lowercased().contains("clear") {
            weatherImageView.image = UIImage(named: "sunny")
            background.backgroundColor = UIColor(red: 0.97, green: 0.78, blue: 0.35, alpha: 1.0)
        } else if weather!.lowercased().contains("rain") {
            weatherImageView.image = UIImage(named: "rainy")
            background.backgroundColor = UIColor(red: 0.42, green: 0.55, blue: 0.71, alpha: 1.0)
        } else if weather!.lowercased().contains("cloud") {
            weatherImageView.image = UIImage(named: "cloudy")
            background.backgroundColor = UIColor(red: 0.098, green: 0.5569, blue: 0.0353, alpha: 1.0)
        }
       
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

