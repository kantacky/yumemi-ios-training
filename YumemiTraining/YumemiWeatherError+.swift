//
//  YumemiWeatherError+.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import YumemiWeather

extension YumemiWeatherError {
    var localizedDescription: String {
        switch self {
        case YumemiWeatherError.invalidParameterError:
            return "Input was invalid."

        case YumemiWeatherError.unknownError:
            return "There was an error fetching the weather."
        }
    }
}
