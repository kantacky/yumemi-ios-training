//
//  WeatherEncoder.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/27.
//

import Dependencies
import Foundation

struct Encoder {
    private(set) var encodeWeatherRequest: @Sendable (WeatherRequest) throws -> String

    init(
        encodeWeatherRequest: @escaping @Sendable (WeatherRequest) throws -> String
    ) {
        self.encodeWeatherRequest = encodeWeatherRequest
    }
}

// swiftlint:disable trailing_closure
extension Encoder: DependencyKey {
    static let liveValue = Encoder(
        encodeWeatherRequest: { request in
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
// swiftlint:enable trailing_closure
