//
//  ForecastViewModel.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import Foundation
import YumemiWeather

@MainActor
protocol ForecastViewModel: ObservableObject {
    
    var weatherCondition: WeatherCondition? { get }

    func reload() -> Void
}

final class ForecastViewModelImpl: ForecastViewModel {
    
    @Published private (set) var weatherCondition: WeatherCondition?

    func reload() {
        let weatherConditionString: String = YumemiWeather.fetchWeatherCondition()

        self.weatherCondition = .from(string: weatherConditionString)
    }
}
