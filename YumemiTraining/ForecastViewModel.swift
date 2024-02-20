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
    @Dependency(YumemiWeatherClient.self) var weatherClient
    @Published private(set) var weather: Weather?
    @Published private(set) var isLoading = false
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
