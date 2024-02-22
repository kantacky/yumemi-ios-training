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
    var alertState: AlertState { get }
    var isAlertPresented: Bool { get set }

    func reload() -> Void
}

@MainActor
final class ForecastViewModelImpl: ForecastViewModel {

    @Published private(set) var weatherCondition: WeatherCondition?
    @Published private(set) var alertState = AlertState.dismissed
    var isAlertPresented: Bool {
        get {
            switch alertState {
            case .dismissed:
                return false

            case .presented:
                return true
            }
        }

        set(newValue) {
            if newValue == false {
                alertState = .dismissed
            }
        }
    }

    func reload() {
        self.fetchWeatherCondition(at: "tokyo")
    }

    private func fetchWeatherCondition() {
        let weatherConditionString: String = YumemiWeather.fetchWeatherCondition()

        self.weatherCondition = .init(rawValue: weatherConditionString)
    }

    private func fetchWeatherCondition(at area: String) {
        do {
            let weatherConditionString: String = try YumemiWeather.fetchWeatherCondition(at: area)

            self.weatherCondition = .init(rawValue: weatherConditionString)
        } catch {
            debugPrint(error.localizedDescription)

            switch error {
            case YumemiWeatherError.invalidParameterError:
                alertState = .presented("Area is invalid.")

            case YumemiWeatherError.unknownError:
                alertState = .presented("Unknown error has occured.")

            default:
                alertState = .presented("Unexpected error has occured.")
            }

            self.isAlertPresented = true
        }
    }
}
