//
//  DataManager.swift
//  WeatherFun
//
//  Created by iraniya on 19/08/20.
//  Copyright © 2020 iraniya. All rights reserved.
//

import Foundation

final class DataManager {
    
    //MARK: - Type Aliases
    
    typealias WeatherDataResult = (Result<WeatherData, WeatherDataError>) -> ()
    
    //MARK: - Requesting Data
    
    func weatherDataForLocation(latitude: Double, longitude: Double, completion: @escaping WeatherDataResult) {
        //Create URL
        let url = WeatherServiceRequest(latitude: latitude, longitude: longitude).url
        
        //Create Data Task
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                self.didFetchWeatherData(data: data, response: response, error: error, completion:completion)
            }
        }.resume()
    }
    
    //MARK: - Helper Method
    
    private func didFetchWeatherData(data: Data?, response:  URLResponse?, error: Error?, completion: WeatherDataResult) {
        if let error = error {
            completion(.failure(.failedRequest))
            print("Unabele to fetch weather data, \(error)")
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    //Create JSON Decoder
                    let decoder = JSONDecoder()
                    
                    //Configure JSON Decoder
                    decoder.dateDecodingStrategy  = .secondsSince1970
                    
                    //Decode JSON
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    
                    //Invoke completion handler
                    completion(.success(weatherData))
                } catch {
                    completion(.failure(.invalidResponse))
                    print("Unable to decode response, \(error)")
                }
            } else {
                completion(.failure(.unkown))
            }
        }
    }
}
