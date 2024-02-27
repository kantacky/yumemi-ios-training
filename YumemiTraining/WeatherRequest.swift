//
//  WeatherRequest.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import Foundation

struct WeatherRequest: Encodable {
    let area: String
    let date: Date
}
