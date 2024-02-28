//
//  WeatherError.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import Foundation

enum WeatherError: LocalizedError {
    case decodeResponseError
    case encodeRequestError

    var errorDescription: String? {
        switch self {
        case .decodeResponseError:
            return "Failed to decode response"

        case .encodeRequestError:
            return "Failed to encode response"
        }
    }
}
