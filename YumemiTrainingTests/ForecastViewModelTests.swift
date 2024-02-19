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
        let expectedWeatherSunny: Weather = .sunny
        let expectedWeatherCloudy: Weather = .cloudy
        let expectedWeatherRainy: Weather = .rainy

        self.viewModel.reload()
        XCTAssertEqual(self.viewModel.errorMessage, "There was an error fetching the weather.")
        XCTAssertEqual(self.viewModel.weather, expectedWeatherSunny)

        self.viewModel.dismissAlert()
        XCTAssertEqual(self.viewModel.errorMessage, nil)
        XCTAssertEqual(self.viewModel.weather, expectedWeatherCloudy)

        self.viewModel.reload()
        XCTAssertEqual(self.viewModel.weather, expectedWeatherRainy)

        self.viewModel.reload()
        XCTAssertEqual(self.viewModel.weather, expectedWeatherSunny)
    }
}
