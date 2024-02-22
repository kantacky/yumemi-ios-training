//
//  YumemiWeatherError+.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import Foundation
import YumemiWeather

extension YumemiWeatherError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case YumemiWeatherError.invalidParameterError:
            return "Area was invalid."

        case YumemiWeatherError.unknownError:
            return "Unknown error has occured."
        }
    }
}
