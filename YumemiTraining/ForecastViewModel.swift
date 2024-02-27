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
@Observable final class ForecastViewModel {
    @ObservationIgnored @Dependency(YumemiWeatherClient.self) var weatherClient
    private(set) var weather: Weather?
    private(set) var isLoading = false
    private(set) var alertMessage: String?
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

    func reload(at area: String, date: Date) async {
        self.isLoading = true
        defer {
            self.isLoading = false
        }
        do {
            weather = try await weatherClient.fetchSyncThrowingWeather(area, date)
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}
