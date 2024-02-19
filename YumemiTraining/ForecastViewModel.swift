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
            guard let requestString = request.jsonString else {
                alertMessage = "Failed to process request."
                return
            }

            let weatherString = try YumemiWeather.fetchWeather(requestString)

            guard let weather = Weather(jsonString: weatherString) else {
                alertMessage = "Failed to process server response."
                return
            }

            self.weather = weather
        } catch {
            self.handleError(error)
        }
    }
}

final class ForecastViewModelMock: ForecastViewModel {

    @Published private (set) var weather: Weather?
    @Published private (set) var errorMessage: String?

    func reload() {
        if let weather = self.weather {
            self.weather = .init(
                date: .now,
                weatherCondition: weather.weatherCondition.next,
                maxTemperature: 10,
                minTemperature: -10
            )
        } else {
            self.weather = .init(
                date: .now,
                weatherCondition: WeatherCondition.allCases[WeatherCondition.allCases.startIndex],
                maxTemperature: 10,
                minTemperature: -10
            )
        }
    }

    func reloadFailWithInvalidParameterError() {
        self.handleError(YumemiWeatherError.invalidParameterError)
    }

    func reloadFailWithUnknownError() {
        self.handleError(YumemiWeatherError.unknownError)
    }

    func dismissAlert() {
        self.errorMessage = nil
        self.reload()
    }
}

extension ForecastViewModelMock {

    private func handleError(_ error: Error) {
        debugPrint(error.localizedDescription)

        switch error {
        case YumemiWeatherError.invalidParameterError:
            self.errorMessage = "Input was invalid."

        case YumemiWeatherError.unknownError:
            self.errorMessage = "There was an error fetching the weather condition."

        default:
            self.errorMessage = "There was an error fetching the weather condition."
        }
    }
}
