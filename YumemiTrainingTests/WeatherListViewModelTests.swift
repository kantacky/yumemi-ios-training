//
//  WeatherListViewModelTests.swift
//  YumemiTrainingTests
//
//  Created by 及川 寛太 on 2024/02/20.
//

import Dependencies
import XCTest
@testable import YumemiTraining

@MainActor
final class WeatherListViewModelTests: XCTestCase {
    func testReload() async throws {
        // Given
        let now = Date.now
        let expected = [
            Weather(
                area: "Sapporo",
                info: WeatherInfo(
                    date: now,
                    weatherCondition: .cloudy,
                    maxTemperature: 10,
                    minTemperature: -10
                )
            ),
            Weather(
                area: "Tokyo",
                info: WeatherInfo(
                    date: now,
                    weatherCondition: .rainy,
                    maxTemperature: 15,
                    minTemperature: -5
                )
            )
        ]
        let viewModel = withDependencies {
            $0[YumemiWeatherClient.self] = YumemiWeatherClient(
                fetchWeather: unimplemented(),
                fetchWeatherList: { date in
                    [
                        Weather(
                            area: "Sapporo",
                            info: WeatherInfo(
                                date: date,
                                weatherCondition: .cloudy,
                                maxTemperature: 10,
                                minTemperature: -10
                            )
                        ),
                        Weather(
                            area: "Tokyo",
                            info: WeatherInfo(
                                date: date,
                                weatherCondition: .rainy,
                                maxTemperature: 15,
                                minTemperature: -5
                            )
                        )
                    ]
                }
            )
        } operation: {
            WeatherListViewModel()
        }

        // When
        // After initialized

        // Then
        XCTAssertTrue(viewModel.weatherList.isEmpty)
        XCTAssertNil(viewModel.alertMessage)

        // When
        await viewModel.reload(date: now)

        // Then
        XCTAssertEqual(viewModel.weatherList, expected)
        XCTAssertNil(viewModel.alertMessage)
    }
}
