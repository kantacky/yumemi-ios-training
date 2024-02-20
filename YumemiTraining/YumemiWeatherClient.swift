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
    private(set) var fetchWeatherList: @Sendable ([String], Date) async throws -> [Weather]

    init(
        fetchWeather: @escaping @Sendable (String, Date) async throws -> WeatherInfo,
        fetchWeatherList: @escaping @Sendable ([String], Date) async throws -> [Weather]
    ) {
        self.fetchWeather = fetchWeather
        self.fetchWeatherList = fetchWeatherList
    }
}

extension YumemiWeatherClient: DependencyKey {
    static let liveValue = YumemiWeatherClient(
        fetchWeather: { area, date in
            @Dependency(Encoder.self) var weatherEncoder
            @Dependency(Decoder.self) var weatherDecoder
            let request = WeatherRequest(area: area, date: date)
            let response = try YumemiWeather.syncFetchWeather(try weatherEncoder.encodeWeatherInfoRequest(request))
            return try weatherDecoder.decodeWeatherInfoResponse(response)
        },
        fetchWeatherList: { areas, date in
            @Dependency(Encoder.self) var weatherEncoder
            @Dependency(Decoder.self) var weatherDecoder
            let request = WeatherListRequest(areas: areas, date: date)
            let response = try YumemiWeather.fetchWeatherList(try weatherEncoder.encodeWeatherListRequest(request))
            return try weatherDecoder.decodeWeatherListResponse(response)
        }
    )
}
