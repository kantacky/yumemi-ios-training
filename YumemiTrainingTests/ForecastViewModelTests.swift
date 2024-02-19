//
//  ForecastViewModelTests.swift
//  YumemiTrainingTests
//
//  Created by 及川 寛太 on 2024/02/19.
//

import XCTest
@testable import YumemiTraining

@MainActor
final class ForecastViewModelTests: XCTestCase {

    let viewModel: any ForecastViewModel = ForecastViewModelMock()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testReload() {
        let expectedWeatherCloudy: Weather = .init(
            date: .now,
            weatherCondition: .cloudy,
            maxTemperature: 10,
            minTemperature: -10
        )

        let expectedWeatherSunny: Weather = .init(
            date: .now,
            weatherCondition: .sunny,
            maxTemperature: 10,
            minTemperature: -10
        )

        let expectedWeatherRainy: Weather = .init(
            date: .now,
            weatherCondition: .rainy,
            maxTemperature: 10,
            minTemperature: -10
        )

        self.viewModel.reload()
        XCTAssertEqual(self.viewModel.errorMessage, "There was an error fetching the weather.")
        XCTAssertEqual(self.viewModel.weather?.weatherCondition, expectedWeatherSunny.weatherCondition)
        XCTAssertEqual(self.viewModel.weather?.maxTemperature, expectedWeatherSunny.maxTemperature)
        XCTAssertEqual(self.viewModel.weather?.minTemperature, expectedWeatherSunny.minTemperature)

        self.viewModel.dismissAlert()
        XCTAssertEqual(self.viewModel.errorMessage, nil)
        XCTAssertEqual(self.viewModel.weather?.weatherCondition, expectedWeatherCloudy.weatherCondition)
        XCTAssertEqual(self.viewModel.weather?.maxTemperature, expectedWeatherCloudy.maxTemperature)
        XCTAssertEqual(self.viewModel.weather?.minTemperature, expectedWeatherCloudy.minTemperature)

        self.viewModel.reload()
        XCTAssertEqual(self.viewModel.weather?.weatherCondition, expectedWeatherRainy.weatherCondition)
        XCTAssertEqual(self.viewModel.weather?.maxTemperature, expectedWeatherRainy.maxTemperature)
        XCTAssertEqual(self.viewModel.weather?.minTemperature, expectedWeatherRainy.minTemperature)

        self.viewModel.reload()
        XCTAssertEqual(self.viewModel.weather?.weatherCondition, expectedWeatherSunny.weatherCondition)
        XCTAssertEqual(self.viewModel.weather?.maxTemperature, expectedWeatherSunny.maxTemperature)
        XCTAssertEqual(self.viewModel.weather?.minTemperature, expectedWeatherSunny.minTemperature)
    }
}
