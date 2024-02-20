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
    var errorMessage: String? { get }

    func reload() -> Void
    func dismissAlert() -> Void
}

@MainActor
final class ForecastViewModelImpl: ForecastViewModel {
    
    @Published private (set) var weatherCondition: WeatherCondition?
    @Published private (set) var errorMessage: String?

    func reload() {
        self.weatherCondition = nil
        self.fetchThrowingWeatherCondition(at: "tokyo")
    }
    
    func dismissAlert() {
        self.errorMessage = nil
        self.reload()
    }
    
    private func fetchWeatherCondition() {
        let weatherConditionString: String = YumemiWeather.fetchWeatherCondition()

        self.weatherCondition = .init(rawValue: weatherConditionString)
    }
    
    private func fetchThrowingWeatherCondition(at: String) {
        do {
            let weatherConditionString: String = try YumemiWeather.fetchWeatherCondition(at: at)
            
            self.weatherCondition = .init(rawValue: weatherConditionString)
        } catch {
            debugPrint(error.localizedDescription)

            switch error {
            case YumemiWeatherError.invalidParameterError:
                self.errorMessage = "Area was invalid."
                
            case YumemiWeatherError.unknownError:
                self.errorMessage = "There was an error fetching the weather condition."
                
            default:
                self.errorMessage = "There was an error fetching the weather condition."
            }
        }
    }
}
