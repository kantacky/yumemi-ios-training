//
//  WeatherListRequest.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import Foundation

struct WeatherListRequest: Encodable {
    var areas: [String]
    var date: Date

    func jsonString() throws -> String {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted

        let data = try encoder.encode(self)

        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw WeatherError.encodeRequestError
        }

        return jsonString
    }
}
