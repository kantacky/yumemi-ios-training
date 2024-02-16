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
    @Published private (set) var weather: Weather?
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
        self.fetchThrowingWeather(request: .init(area: "tokyo", date: .now))
    }
}

extension ForecastViewModelImpl {
    private func handleError(_ error: Error) {
        debugPrint(error.localizedDescription)

        switch error {
        case YumemiWeatherError.invalidParameterError:
            alert = Alert(title: Text("There was an Error Retrieving Weather."), message: Text("Area is invalid."))

        case YumemiWeatherError.unknownError:
            alert = Alert(title: Text("There was an Error Retrieving Weather."), message: Text("Unknown error has occured."))

        default:
            alert = Alert(title: Text("There was an Error Retrieving Weather."), message: Text("Unexpected error has occured."))
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
                alert = Alert(title: Text("There was an Error Retrieving Weather."), message: Text("Failed to process server response."))
                return
            }

            self.weather = weather
        } catch {
            self.handleError(error)
        }
    }
}
