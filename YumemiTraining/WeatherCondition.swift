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
    
    var image: Image {
        switch self {
        case .sunny:
            return .init(.sunny)
            
        case .cloudy:
            return .init(.cloudy)
            
        case .rainy:
            return .init(.rainy)
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
