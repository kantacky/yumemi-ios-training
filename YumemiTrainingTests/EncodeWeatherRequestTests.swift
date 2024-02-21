//
//  EncodeWeatherRequestTests.swift
//  YumemiTrainingTests
//
//  Created by 及川 寛太 on 2024/02/21.
//

import XCTest
@testable import YumemiTraining

@MainActor
final class EncodeWeatherRequestTests: XCTestCase {
    func testEncodeWeatherRequest() throws {
        // Given
        guard let now = ISO8601DateFormatter().date(from: "2020-04-01T12:00:00+09:00") else {
            return
        }
        let request = WeatherRequest(area: "Tokyo", date: now)
        let expected = "{\"area\":\"Tokyo\",\"date\":\"2020-04-01T03:00:00Z\"}"

        // When
        let encoded = try request.encode()

        // Then
        XCTAssertEqual(encoded, expected)
    }
}
