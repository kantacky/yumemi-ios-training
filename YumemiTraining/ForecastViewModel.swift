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
    private(set) var weather: WeatherInfo?
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

    func reload(at area: String, date: Date) async {
        self.isLoading = true
        defer {
            self.isLoading = false
        }
        do {
            weather = try await weatherClient.fetchWeather(area, date)
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}
