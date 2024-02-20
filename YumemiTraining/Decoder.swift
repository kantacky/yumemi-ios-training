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

    init(
        decodeWeatherInfoResponse: @escaping @Sendable (String) throws -> WeatherInfo
    ) {
        self.decodeWeatherInfoResponse = decodeWeatherInfoResponse
    }
}

// swiftlint:disable trailing_closure
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
        }
    )

    static let testValue = liveValue
}
// swiftlint:enable trailing_closure
