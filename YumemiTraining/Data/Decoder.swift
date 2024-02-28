//
//  WeatherDecoder.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/27.
//

import Dependencies
import Foundation

struct Decoder {
    private(set) var decodeWeatherInfoResponse: @Sendable (String) throws -> WeatherInfo
    private(set) var decodeWeatherListResponse: @Sendable (String) throws -> [Weather]

    init(
        decodeWeatherInfoResponse: @escaping @Sendable (String) throws -> WeatherInfo,
        decodeWeatherListResponse: @escaping @Sendable (String) throws -> [Weather]
    ) {
        self.decodeWeatherInfoResponse = decodeWeatherInfoResponse
        self.decodeWeatherListResponse = decodeWeatherListResponse
    }
}

extension Decoder: DependencyKey {
    static let liveValue = Decoder(
        decodeWeatherInfoResponse: { response in
            guard let data: Data = response.data(using: .utf8) else {
                throw WeatherError.decodeResponseError
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(WeatherInfo.self, from: data)
        },
        decodeWeatherListResponse: { response in
            guard let data: Data = response.data(using: .utf8) else {
                throw WeatherError.decodeResponseError
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Weather].self, from: data)
        }
    )

    static let testValue = liveValue
}
