//
//  ForecastViewModel.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import Dependencies
import Foundation
import Observation
import YumemiWeather

@MainActor
@Observable final class ForecastViewModel {
    @ObservationIgnored @Dependency(YumemiWeatherClient.self) private var weatherClient
    private(set) var weather: Weather
    private(set) var isLoading = false
    private(set) var alertMessage: String?
    var isAlertPresented: Bool {
        get { alertMessage != nil }
        set {
            if newValue == false {
                alertMessage = nil
            }
        }
    }

    init(weather: Weather) {
        self.weather = weather
    }

    func reload(date: Date) async {
        self.isLoading = true
        defer {
            self.isLoading = false
        }
        do {
            let weatherInfo = try await weatherClient.fetchWeather(weather.area, date)
            weather = Weather(area: weather.area, info: weatherInfo)
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}
