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
    var weather: Weather? { get }
    var weatherCondition: WeatherCondition? { get }
    var alertMessage: String? { get }
    var isAlertPresented: Bool { get set }

    func reload() -> Void
}

@MainActor
final class ForecastViewModelImpl: ForecastViewModel {
    @Published private(set) var weather: Weather?
    @Published private(set) var weatherCondition: WeatherCondition?
    @Published private(set) var alertMessage: String?
    var isAlertPresented: Bool {
        get {
            alertMessage != nil
        }

        set(newValue) {
            if newValue == false {
                alertMessage = nil
            }
        }
    }

    func reload() {
        self.fetchWeather(request: .init(area: "tokyo", date: .now))
    }
}

extension ForecastViewModelImpl {
    private func handleError(_ error: Error) {
        switch error {
        case YumemiWeatherError.invalidParameterError:
            alertMessage = "Area is invalid."

        case YumemiWeatherError.unknownError:
            alertMessage = "Unknown error has occurred."

        default:
            alertMessage = "Unexpected error has occurred."
        }

        self.isAlertPresented = true
    }
}

extension ForecastViewModelImpl {
    private func fetchWeatherCondition() {
        let weatherConditionString: String = YumemiWeather.fetchWeatherCondition()

        self.weatherCondition = .init(rawValue: weatherConditionString)
    }

    private func fetchWeatherCondition(at area: String) {
        do {
            let weatherConditionString: String = try YumemiWeather.fetchWeatherCondition(at: area)

            self.weatherCondition = .init(rawValue: weatherConditionString)
        } catch {
            self.handleError(error)
        }
    }

    private func fetchWeather(request: WeatherRequest) {
        do {
            let weatherString: String = try YumemiWeather.fetchWeather(request.jsonString ?? "")

            guard let weather: Weather = .from(jsonString: weatherString) else {
                alertMessage = "Failed to process server response."
                return
            }

            self.weather = weather
        } catch {
            self.handleError(error)
        }
    }
}
