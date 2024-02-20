//
//  WeatherListRequest.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import Foundation

struct WeatherListRequest: Encodable {
    let areas: [String]
    let date: Date
}
