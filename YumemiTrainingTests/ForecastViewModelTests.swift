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

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testReloadSunny() {
        let now: Date = .now
        let expected: Weather = .init(date: now, weatherCondition: .sunny, maxTemperature: 20, minTemperature: 0)

        let viewModel: ForecastViewModel = withDependencies {
            $0.date.now = now
            $0.yumemiWeatherClient = .init(
                fetchWeatherCondition: unimplemented(),
                fetchThrowingWeatherCondition: unimplemented(),
                fetchThrowingWeather: { _, date in
                    .init(date: date, weatherCondition: .sunny, maxTemperature: 20, minTemperature: 0)
                }
            )
        } operation: {
            .init()
        }

        viewModel.reload()
        XCTAssertEqual(viewModel.weather, expected)
    }

    func testReloadCloudy() {
        let now: Date = .now
        let expected: Weather = .init(date: now, weatherCondition: .cloudy, maxTemperature: 15, minTemperature: -5)

        let viewModel: ForecastViewModel = withDependencies {
            $0.date.now = now
            $0.yumemiWeatherClient = .init(
                fetchWeatherCondition: unimplemented(),
                fetchThrowingWeatherCondition: unimplemented(),
                fetchThrowingWeather: { _, date in
                    .init(date: date, weatherCondition: .cloudy, maxTemperature: 15, minTemperature: -5)
                }
            )
        } operation: {
            .init()
        }

        viewModel.reload()
        XCTAssertEqual(viewModel.weather, expected)
    }

    func testReloadRainy() {
        let now: Date = .now
        let expected: Weather = .init(date: now, weatherCondition: .rainy, maxTemperature: 10, minTemperature: -10)

        let viewModel: ForecastViewModel = withDependencies {
            $0.date.now = now
            $0.yumemiWeatherClient = .init(
                fetchWeatherCondition: unimplemented(),
                fetchThrowingWeatherCondition: unimplemented(),
                fetchThrowingWeather: { _, date in
                    .init(date: date, weatherCondition: .rainy, maxTemperature: 10, minTemperature: -10)
                }
            )
        } operation: {
            .init()
        }

        viewModel.reload()
        XCTAssertEqual(viewModel.weather, expected)
    }
}
