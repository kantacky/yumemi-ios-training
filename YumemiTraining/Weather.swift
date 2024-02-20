//
//  Weather.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import Foundation

struct Weather: Equatable, Decodable, Hashable {
    var area: String
    var info: WeatherInfo

    static func listFrom(jsonString: String) throws -> [Self] {
        guard let data: Data = jsonString.data(using: .utf8) else {
            throw WeatherError.decodeResponseError
        }

        return try listFrom(data: data)
    }

    static func listFrom(data: Data) throws -> [Self] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Self].self, from: data)
    }
}
