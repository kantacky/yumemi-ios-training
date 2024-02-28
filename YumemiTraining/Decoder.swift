//
//  WeatherDecoder.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/27.
//

import Dependencies
import Foundation

struct Decoder {
    private(set) var decodeWeatherResponse: @Sendable (String) throws -> Weather

    init(
        decodeWeatherResponse: @escaping @Sendable (String) throws -> Weather
    ) {
        self.decodeWeatherResponse = decodeWeatherResponse
    }
}

// swiftlint:disable trailing_closure
extension Decoder: DependencyKey {
    static let liveValue = Decoder(
        decodeWeatherResponse: { response in
            guard let data: Data = response.data(using: .utf8) else {
                throw WeatherError.decodeResponseError
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(Weather.self, from: data)
        }
    )

    static let testValue = liveValue
}
// swiftlint:enable trailing_closure
