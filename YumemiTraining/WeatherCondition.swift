//
//  WeatherCondition.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import Foundation
import SwiftUI

enum WeatherCondition: String, Decodable, CaseIterable {
    case sunny
    case cloudy
    case rainy
    
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

    var next: Self {
        guard let index = Self.allCases.firstIndex(of: self) else {
            return .sunny
        }
        if index >= Self.allCases.count - 1 {
            return .sunny
        }
        return Self.allCases[index + 1]
    }
}
