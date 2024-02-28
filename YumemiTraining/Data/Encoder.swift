//
//  WeatherEncoder.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/27.
//

import Dependencies
import Foundation

struct Encoder {
    private(set) var encodeWeatherInfoRequest: @Sendable (WeatherRequest) throws -> String
    private(set) var encodeWeatherListRequest: @Sendable (WeatherListRequest) throws -> String

    init(
        encodeWeatherInfoRequest: @escaping @Sendable (WeatherRequest) throws -> String,
        encodeWeatherListRequest: @escaping @Sendable (WeatherListRequest) throws -> String
    ) {
        self.encodeWeatherInfoRequest = encodeWeatherInfoRequest
        self.encodeWeatherListRequest = encodeWeatherListRequest
    }
}

extension Encoder: DependencyKey {
    static let liveValue = Encoder(
        encodeWeatherInfoRequest: { request in
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .sortedKeys
            let data = try encoder.encode(request)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                throw WeatherError.encodeRequestError
            }
            return jsonString
        },
        encodeWeatherListRequest: { request in
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .sortedKeys
            let data = try encoder.encode(request)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                throw WeatherError.encodeRequestError
            }
            return jsonString
        }
    )

    static let testValue = liveValue
}
