//
//  ForecastViewModel.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import Dependencies
import Foundation
import YumemiWeather

@MainActor
final class ForecastViewModel: ObservableObject {
    @Dependency(\.date.now) var now
    @Dependency(YumemiWeatherClient.self) var weatherClient
    @Published private(set) var weather: Weather?
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
        do {
            self.weather = try self.weatherClient.fetchThrowingWeather("tokyo", self.now)
        } catch {
            alertMessage = error.localizedDescription
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
            alertMessage = error.localizedDescription
        }
    }
}
