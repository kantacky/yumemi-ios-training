//
//  Weather.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import Foundation

struct Weather: Equatable, Decodable {
    var date: Date
    var weatherCondition: WeatherCondition
    var maxTemperature: Int
    var minTemperature: Int

    init(
        date: Date,
        weatherCondition: WeatherCondition,
        maxTemperature: Int,
        minTemperature: Int
    ) {
        self.date = date
        self.weatherCondition = weatherCondition
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
    }

    init?(from jsonString: String) {
        do {
            self = try Self.decode(from: jsonString)
        } catch {
            return nil
        }
    }

    static func decode(from jsonString: String) throws -> Self {
        guard let data: Data = jsonString.data(using: .utf8) else {
            throw WeatherError.decodeResponseError
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Self.self, from: data)
    }
}
