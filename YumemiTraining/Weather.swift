//
//  Weather.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import Foundation

struct Weather: Decodable {
    var date: Date
    var weatherCondition: WeatherCondition
    var maxTemperature: Int
    var minTemperature: Int
    
    static func from(jsonString: String) -> Self? {
        guard
            let data: Data = jsonString.data(using: .utf8),
            let weather: Self = self.from(data: data)
        else {
            return nil
        }

        return weather
    }
    
    static func from(data: Data) -> Self? {
        guard let weather: Self = try? JSONDecoder().decode(Weather.self, from: data) else {
            return nil
        }

        return weather
    }
}

struct WeatherRequest: Encodable {
    var area: String
    var date: Date
    
    var jsonString: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        guard
            let data: Data = try? JSONEncoder().encode(self),
            let jsonString: String = .init(data: data, encoding: .utf8)
        else {
            return nil
        }

        return jsonString
    }
}

typealias WeatherResponse = Weather