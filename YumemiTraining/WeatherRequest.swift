//
//  WeatherRequest.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import Foundation

struct WeatherRequest: Encodable {
    var area: String
    var date: Date

    func jsonString() throws -> String {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(.iso8601Full)
        encoder.outputFormatting = .prettyPrinted

        let data = try encoder.encode(self)

        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw WeatherError.encodeRequestError
        }

        return jsonString
    }
}
