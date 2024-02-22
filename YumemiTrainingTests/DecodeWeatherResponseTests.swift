//
//  DecodeWeatherResponseTests.swift
//  YumemiTrainingTests
//
//  Created by 及川 寛太 on 2024/02/21.
//

import XCTest
@testable import YumemiTraining

@MainActor
final class DecodeWeatherResponseTests: XCTestCase {
    func testDecodeWeatherResponse() throws {
        // Given
        let now = try XCTUnwrap(ISO8601DateFormatter().date(from: "2020-04-01T12:00:00+09:00"))
        let response = """
{
    "max_temperature": 20,
    "date": "2020-04-01T12:00:00+09:00",
    "min_temperature": 0,
    "weather_condition": "sunny"
}
"""
        let expected = Weather(date: now, weatherCondition: .sunny, maxTemperature: 20, minTemperature: 0)

        // When
        let decoded = try Weather.decode(from: response)

        // Then
        XCTAssertEqual(decoded, expected)
    }
}
