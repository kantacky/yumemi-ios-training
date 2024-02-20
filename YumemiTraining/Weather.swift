//
//  Weather.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import Foundation

struct Weather: Equatable, Decodable {
    var date: Date
    var weatherCondition: WeatherCondition
    var maxTemperature: Int
    var minTemperature: Int
}

struct WeatherRequest {
    var area: String
    var date: Date
}

extension WeatherRequest: Encodable {
    var jsonString: String? {
        let encoder: JSONEncoder = .init()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted

        guard
            let data: Data = try? encoder.encode(self),
            let jsonString: String = .init(data: data, encoding: .utf8)
        else {
            return nil
        }

        return jsonString
    }
}

typealias WeatherResponse = Weather

extension WeatherResponse {
    init?(jsonString: String) {
        guard
            let data: Data = jsonString.data(using: .utf8),
            let weather: Self = .init(data: data)
        else {
            return nil
        }

        self = weather
    }

    init?(data: Data) {
        let decoder: JSONDecoder = .init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        do {
            let weather: Self = try decoder.decode(Weather.self, from: data)
            self = weather
        } catch {
            return nil
        }
    }
}

enum WeatherError: LocalizedError {
    case encodeRequestError
    case decodeResponseError

    var localizedDescription: String {
        switch self {
        case .encodeRequestError:
            return "Failed to encode request"

        case .decodeResponseError:
            return "Failed to decode response"
        }
    }
}
