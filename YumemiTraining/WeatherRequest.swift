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

    var jsonString: String? {
        do {
            return try self.encode()
        } catch {
            return nil
        }
    }

    func encode() throws -> String {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(self)
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw WeatherError.encodeRequestError
        }
        return jsonString
    }
}
