//
//  ForecastViewModelTests.swift
//  YumemiTrainingTests
//
//  Created by 及川 寛太 on 2024/02/19.
//

import Dependencies
import XCTest
@testable import YumemiTraining

@MainActor
final class ForecastViewModelTests: XCTestCase {
    func testReloadSunny() {
        // Given
        let now = Date.now
        let expected = Weather(date: now, weatherCondition: .sunny, maxTemperature: 20, minTemperature: 0)
        let viewModel = withDependencies {
            $0[YumemiWeatherClient.self] = .init(
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

        // When
        viewModel.reload(at: "tokyo", date: now)

        // Then
        XCTAssertEqual(viewModel.weather, expected)
        XCTAssertNil(viewModel.alertMessage)
    }
}
