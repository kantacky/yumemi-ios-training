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
            let weatherConditionString: String = YumemiWeather.fetchWeatherCondition()
            let weatherCondition: WeatherCondition? = .init(rawValue: weatherConditionString)
            return weatherCondition
        },
        fetchThrowingWeatherCondition: { area in
            let weatherConditionString: String = try YumemiWeather.fetchWeatherCondition(at: area)
            let weatherCondition: WeatherCondition? = .init(rawValue: weatherConditionString)
            return weatherCondition
        },
        fetchThrowingWeather: { area, date in
            let request: WeatherRequest = .init(area: area, date: date)
            let weatherString: String = try YumemiWeather.fetchWeather(request.jsonString ?? "")
            let weather = Weather(jsonString: weatherString)
            return weather
        }
    )
}

enum YumemiWeatherClientKey: DependencyKey {
    static let liveValue: YumemiWeatherClient = .liveValue
}

extension DependencyValues {
    var yumemiWeatherClient: YumemiWeatherClient {
        get { self[YumemiWeatherClientKey.self] }
        set { self[YumemiWeatherClientKey.self] = newValue }
    }
}
