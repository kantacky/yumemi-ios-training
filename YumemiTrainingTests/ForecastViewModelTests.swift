//
//  ForecastViewModelTests.swift
//  YumemiTrainingTests
//
//  Created by 及川 寛太 on 2024/02/19.
//

import Dependencies
import YumemiWeather
import XCTest
@testable import YumemiTraining

@MainActor
final class ForecastViewModelTests: XCTestCase {
    func testReloadSunny() {
        // Given
        let now = Date.now
        let expected = Weather(date: now, weatherCondition: .sunny, maxTemperature: 20, minTemperature: 0)
        let viewModel = withDependencies {
            $0[YumemiWeatherClient.self] = YumemiWeatherClient(
                fetchWeatherCondition: unimplemented(),
                fetchThrowingWeatherCondition: unimplemented(),
                fetchThrowingWeather: { _, date in
                    Weather(date: date, weatherCondition: .sunny, maxTemperature: 20, minTemperature: 0)
                }
            )
        } operation: {
            ForecastViewModel()
        }

        // When
        // After initialized

        // Then
        XCTAssertNil(viewModel.weather)
        XCTAssertNil(viewModel.alertMessage)
        XCTAssertFalse(viewModel.isAlertPresented)

        // When
        viewModel.reload(at: "Tokyo", date: now)

        // Then
        XCTAssertEqual(viewModel.weather, expected)
        XCTAssertNil(viewModel.alertMessage)
        XCTAssertFalse(viewModel.isAlertPresented)
    }

    func testReloadFailure() {
        // Given
        let now = Date.now
        let viewModel = withDependencies {
            $0[YumemiWeatherClient.self] = YumemiWeatherClient(
                fetchWeatherCondition: unimplemented(),
                fetchThrowingWeatherCondition: unimplemented(),
                fetchThrowingWeather: { _, date in
                    throw YumemiWeatherError.unknownError
                }
            )
        } operation: {
            ForecastViewModel()
        }

        // When
        // After initialized

        // Then
        XCTAssertNil(viewModel.weather)
        XCTAssertNil(viewModel.alertMessage)
        XCTAssertFalse(viewModel.isAlertPresented)

        // When
        viewModel.reload(at: "Tokyo", date: now)

        // Then
        XCTAssertNil(viewModel.weather)
        XCTAssertEqual(viewModel.alertMessage, "Unknown error has occurred.")
        XCTAssertTrue(viewModel.isAlertPresented)

        // When
        viewModel.isAlertPresented = false

        // Then
        XCTAssertNil(viewModel.alertMessage)
        XCTAssertFalse(viewModel.isAlertPresented)
    }
}
