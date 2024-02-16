//
//  WeatherCondition.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import Foundation
import SwiftUI

enum WeatherCondition {
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
    
    static func from(string: String) -> Self? {
        switch string {
        case "sunny":
            return .sunny
            
        case "cloudy":
            return .cloudy
            
        case "rainy":
            return .rainy
            
        default:
            return nil
        }
    }
}
