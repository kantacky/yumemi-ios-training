//
//  ForecastViewModelTests.swift
//  YumemiTrainingTests
//
//  Created by 及川 寛太 on 2024/02/19.
//

import Dependencies
import XCTest
@testable import YumemiTraining
import YumemiWeather

@MainActor
final class ForecastViewModelTests: XCTestCase {
    func testReload() async throws {
        // Given
        let now = Date.now
        let initialWeather = Weather(
            area: "Tokyo",
            info: WeatherInfo(
                date: now,
                weatherCondition: .cloudy,
                maxTemperature: 10,
                minTemperature: -10
            )
        )
        let expected = Weather(
            area: "Tokyo",
            info: WeatherInfo(
                date: now,
                weatherCondition: .sunny,
                maxTemperature: 20,
                minTemperature: 0
            )
        )
        let viewModel = withDependencies {
            $0[YumemiWeatherClient.self] = YumemiWeatherClient(
                fetchWeather: { _, date in
                    WeatherInfo(date: date, weatherCondition: .sunny, maxTemperature: 20, minTemperature: 0)
                },
                fetchWeatherList: unimplemented()
            )
        } operation: {
            ForecastViewModel(weather: initialWeather)
        }

        // When
        // After initialized

        // Then
        XCTAssertEqual(viewModel.weather, initialWeather)
        XCTAssertNil(viewModel.alertMessage)
        XCTAssertFalse(viewModel.isAlertPresented)

        // When
        await viewModel.reload(date: now)

        // Then
        XCTAssertEqual(viewModel.weather, expected)
        XCTAssertNil(viewModel.alertMessage)
        XCTAssertFalse(viewModel.isAlertPresented)
    }

    func testReloadFailure() async throws {
        // Given
        let now = Date.now
        let initialWeather = Weather(
            area: "Tokyo",
            info: WeatherInfo(
                date: now,
                weatherCondition: .cloudy,
                maxTemperature: 10,
                minTemperature: -10
            )
        )
        let viewModel = withDependencies {
            $0[YumemiWeatherClient.self] = YumemiWeatherClient(
                fetchWeather: { _, _ in
                    throw YumemiWeatherError.unknownError
                },
                fetchWeatherList: unimplemented()
            )
        } operation: {
            ForecastViewModel(weather: initialWeather)
        }

        // When
        // After initialized

        // Then
        XCTAssertEqual(viewModel.weather, initialWeather)
        XCTAssertNil(viewModel.alertMessage)
        XCTAssertFalse(viewModel.isAlertPresented)

        // When
        await viewModel.reload(date: now)

        // Then
        XCTAssertEqual(viewModel.weather, initialWeather)
        XCTAssertEqual(viewModel.alertMessage, "Unknown error has occurred.")
        XCTAssertTrue(viewModel.isAlertPresented)

        // When
        viewModel.isAlertPresented = false

        // Then
        XCTAssertNil(viewModel.alertMessage)
        XCTAssertFalse(viewModel.isAlertPresented)
    }
}
