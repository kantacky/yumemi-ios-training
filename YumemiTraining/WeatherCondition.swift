//
//  WeatherCondition.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import Foundation
import SwiftUI

enum WeatherCondition: String, Decodable {
    case cloudy
    case rainy
    case sunny

    var image: some View {
        switch self {
        case .sunny:
            return Image(.sunny)
                .resizable()
                .foregroundStyle(.red)

        case .cloudy:
            return Image(.cloudy)
                .resizable()
                .foregroundStyle(.gray)

        case .rainy:
            return Image(.rainy)
                .resizable()
                .foregroundStyle(.blue)
        }
    }
}
