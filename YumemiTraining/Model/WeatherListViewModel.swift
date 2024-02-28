//
//  WeatherListViewModel.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import Dependencies
import Foundation

@MainActor
@Observable final class WeatherListViewModel {
    @ObservationIgnored @Dependency(YumemiWeatherClient.self) var weatherClient
    private(set) var weatherList: [Weather] = []
    private(set) var isLoading = false
    private(set) var alertMessage: String?
    var isAlertPresented: Bool {
        get { alertMessage != nil }
        set(newValue) {
            if newValue == false {
                alertMessage = nil
            }
        }
    }

    func reload(date: Date) async {
        self.isLoading = true
        defer {
            self.isLoading = false
        }
        do {
            weatherList = try await weatherClient.fetchWeatherList(date)
        } catch {
            alertMessage = error.localizedDescription
        }
    }

    func dismissAlert() {
        alertMessage = nil
    }
}
