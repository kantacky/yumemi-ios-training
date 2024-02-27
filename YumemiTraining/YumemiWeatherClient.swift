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
    private(set) var fetchWeatherCondition: @Sendable () -> WeatherCondition?
    private(set) var fetchThrowingWeatherCondition: @Sendable (String) throws -> WeatherCondition?
    private(set) var fetchThrowingWeather: @Sendable (String, Date) throws -> Weather?
    private(set) var fetchSyncThrowingWeather: @Sendable (String, Date) async throws -> Weather?

    init(
        fetchWeatherCondition: @escaping @Sendable () -> WeatherCondition?,
        fetchThrowingWeatherCondition: @escaping @Sendable (String) throws -> WeatherCondition?,
        fetchThrowingWeather: @escaping @Sendable (String, Date) throws -> Weather?,
        fetchSyncThrowingWeather: @escaping @Sendable (String, Date) async throws -> Weather?
    ) {
        self.fetchWeatherCondition = fetchWeatherCondition
        self.fetchThrowingWeatherCondition = fetchThrowingWeatherCondition
        self.fetchThrowingWeather = fetchThrowingWeather
        self.fetchSyncThrowingWeather = fetchSyncThrowingWeather
    }
}

extension YumemiWeatherClient: DependencyKey {
    static let liveValue = YumemiWeatherClient(
        fetchWeatherCondition: {
            WeatherCondition(rawValue: YumemiWeather.fetchWeatherCondition())
        },
        fetchThrowingWeatherCondition: { area in
            WeatherCondition(rawValue: try YumemiWeather.fetchWeatherCondition(at: area))
        },
        fetchThrowingWeather: { area, date in
            @Dependency(Encoder.self) var weatherEncoder
            @Dependency(Decoder.self) var weatherDecoder

            let request = WeatherRequest(area: area, date: date)
            let response = try YumemiWeather.fetchWeather(try weatherEncoder.encodeWeatherRequest(request))
            return try weatherDecoder.decodeWeatherResponse(response)
        },
        fetchSyncThrowingWeather: { area, date in
            @Dependency(Encoder.self) var weatherEncoder
            @Dependency(Decoder.self) var weatherDecoder

            let request = WeatherRequest(area: area, date: date)
            let response = try YumemiWeather.syncFetchWeather(try weatherEncoder.encodeWeatherRequest(request))
            return try weatherDecoder.decodeWeatherResponse(response)
        }
    )
}
