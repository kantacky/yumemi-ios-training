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
    func testReloadSunny() async throws {
        // Given
        let now = Date.now
        let expected = Weather(date: now, weatherCondition: .sunny, maxTemperature: 20, minTemperature: 0)
        // swiftlint:disable trailing_closure
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
        // swiftlint:enable trailing_closure

        // When
        // After initialized

        // Then
        XCTAssertNil(viewModel.weather)
        XCTAssertNil(viewModel.alertMessage)
        XCTAssertFalse(viewModel.isAlertPresented)

        // When
        await viewModel.reload(area: "tokyo", date: now)

        // Then
        XCTAssertEqual(viewModel.weather, expected)
        XCTAssertNil(viewModel.alertMessage)
        XCTAssertFalse(viewModel.isAlertPresented)
    }

    func testReloadFailure() {
        // Given
        let now = Date.now
        // swiftlint:disable trailing_closure
        let viewModel = withDependencies {
            $0[YumemiWeatherClient.self] = YumemiWeatherClient(
                fetchWeatherCondition: unimplemented(),
                fetchThrowingWeatherCondition: unimplemented(),
                fetchThrowingWeather: { _, _ in
                    throw YumemiWeatherError.unknownError
                }
            )
        } operation: {
            ForecastViewModel()
        }
        // swiftlint:enable trailing_closure

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
