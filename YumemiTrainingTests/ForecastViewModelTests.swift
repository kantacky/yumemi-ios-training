//
//  ForecastViewModelTests.swift
//  YumemiTrainingTests
//
//  Created by 及川 寛太 on 2024/02/19.
//

import XCTest
import Dependencies
@testable import YumemiTraining

@MainActor
final class ForecastViewModelTests: XCTestCase {

    func testReloadSunny() {
        // Given
        let now = Date.now
        let expected = Weather(date: now, weatherCondition: .sunny, maxTemperature: 20, minTemperature: 0)
        let viewModel = withDependencies {
            $0.date.now = now
        } operation: {
            ForecastViewModel()
        }

        // When
        // After initialized

        // Then
        XCTAssertEqual(viewModel.weather, nil)
        XCTAssertEqual(viewModel.errorMessage, nil)

        // When
        viewModel.reload(area: "tokyo", date: now)

        // Then
        XCTAssertEqual(viewModel.weather, expected)
        XCTAssertEqual(viewModel.errorMessage, nil)
    }
}
