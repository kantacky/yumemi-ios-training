//
//  WeatherListViewModel.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import Dependencies
import Foundation

@MainActor
final class WeatherListViewModel: ObservableObject {
    @Dependency(YumemiWeatherClient.self) var weatherClient
    @Published private(set) var weatherList: [Weather] = []
    @Published private(set) var isLoading = false
    @Published private(set) var alertMessage: String?
    var isAlertPresented: Bool {
        get { alertMessage != nil }
        set(newValue) {
            if newValue == false {
                alertMessage = nil
            }
        }
    }

    func reload(areas: [String], date: Date) async {
        self.isLoading = true
        defer {
            self.isLoading = false
        }
        do {
            weatherList = try await weatherClient.fetchWeatherList(areas, date)
        } catch {
            alertMessage = error.localizedDescription
        }
    }

    func dismissAlert() {
        alertMessage = nil
    }
}
