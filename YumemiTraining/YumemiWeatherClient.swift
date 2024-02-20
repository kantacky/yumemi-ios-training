//
//  YumemiWeatherClient.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import Dependencies
import Foundation
import YumemiWeather

struct YumemiWeatherClient {
    private (set) var fetchWeatherCondition: @Sendable () -> WeatherCondition?
    private (set) var fetchThrowingWeatherCondition: @Sendable (String) throws -> WeatherCondition?
    private (set) var fetchThrowingWeather: @Sendable (String, Date) throws -> Weather?

    init(
        fetchWeatherCondition: @escaping @Sendable () -> WeatherCondition?,
        fetchThrowingWeatherCondition: @escaping @Sendable (String) throws -> WeatherCondition?,
        fetchThrowingWeather: @escaping @Sendable (String, Date) throws -> Weather?
    ) {
        self.fetchWeatherCondition = fetchWeatherCondition
        self.fetchThrowingWeatherCondition = fetchThrowingWeatherCondition
        self.fetchThrowingWeather = fetchThrowingWeather
    }
}

extension YumemiWeatherClient: DependencyKey {
    static let liveValue: Self = .init(
        fetchWeatherCondition: {
            WeatherCondition(rawValue: YumemiWeather.fetchWeatherCondition())
        },
        fetchThrowingWeatherCondition: { area in
            WeatherCondition(rawValue: try YumemiWeather.fetchWeatherCondition(at: area))
        },
        fetchThrowingWeather: { area, date in
            let request = WeatherRequest(area: area, date: date)
            let response = try YumemiWeather.fetchWeather(request.jsonString ?? "")
            return Weather(jsonString: response)
        }
    )
}

extension YumemiWeatherClient: TestDependencyKey {
    static let testValue: Self = .init(
        fetchWeatherCondition: {
            WeatherCondition.sunny
        },
        fetchThrowingWeatherCondition: { _ in
            WeatherCondition.sunny
        },
        fetchThrowingWeather: { _, date in
            Weather(date: date, weatherCondition: .sunny, maxTemperature: 20, minTemperature: 0)
        }
    )
}
