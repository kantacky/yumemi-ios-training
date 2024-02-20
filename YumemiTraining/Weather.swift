//
//  Weather.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import Foundation

struct Weather: Equatable, Decodable, Hashable {
    var area: String
    var info: WeatherInfo
}
