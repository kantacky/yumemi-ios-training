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
    private(set) var fetchWeather: @Sendable (String, Date) async throws -> WeatherInfo

    init(
        fetchWeather: @escaping @Sendable (String, Date) async throws -> WeatherInfo
    ) {
        self.fetchWeather = fetchWeather
    }
}

extension YumemiWeatherClient: DependencyKey {
    static let liveValue = YumemiWeatherClient(
        fetchWeather: { area, date in
            @Dependency(Encoder.self) var weatherEncoder
            @Dependency(Decoder.self) var weatherDecoder
            let request = WeatherRequest(area: area, date: date)
            let response = try YumemiWeather.syncFetchWeather(try weatherEncoder.encodeWeatherRequest(request))
            return try weatherDecoder.decodeWeatherInfoResponse(response)
        }
    )
}
