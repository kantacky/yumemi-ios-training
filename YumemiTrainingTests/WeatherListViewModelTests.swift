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
                fetchWeatherList: { areas, date in
                    var weathers: [Weather] = []

                    areas.enumerated().forEach { index, area in
                        weathers.append(
                            Weather(
                                area: area,
                                info: WeatherInfo(
                                    date: date,
                                    weatherCondition: .allCases[index % 3],
                                    maxTemperature: index * 5 + 10,
                                    minTemperature: index * 5 - 10
                                )
                            )
                        )
                    }

                    return weathers
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
        await viewModel.reload(areas: ["Sapporo", "Tokyo"], date: now)

        // Then
        XCTAssertEqual(viewModel.weatherList, expected)
        XCTAssertNil(viewModel.alertMessage)
    }
}
