//
//  WeatherInfo.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import Foundation

struct WeatherInfo: Equatable, Decodable {
    let date: Date
    let weatherCondition: WeatherCondition
    let maxTemperature: Int
    let minTemperature: Int
}
