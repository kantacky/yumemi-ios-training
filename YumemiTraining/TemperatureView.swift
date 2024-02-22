//
//  TemperatureView.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/21.
//

import SwiftUI

struct TemperatureView: View {
    let maxTemperature: Int?
    let minTemperature: Int?

    func string(temperature: Int?) -> String {
        if let temperature = temperature {
            return "\(temperature)"
        }
        return "--"
    }

    var body: some View {
        HStack(spacing: .zero) {
            Text(string(temperature: minTemperature))
                .foregroundStyle(.blue)
                .containerRelativeFrame(
                    .horizontal,
                    count: 4,
                    spacing: .zero
                )

            Text(string(temperature: maxTemperature))
                .foregroundStyle(.red)
                .containerRelativeFrame(
                    .horizontal,
                    count: 4,
                    spacing: .zero
                )
        }
        .fontDesign(.monospaced)
    }
}

#Preview {
    VStack {
        TemperatureView(maxTemperature: 12, minTemperature: 7)

        TemperatureView(maxTemperature: nil, minTemperature: nil)
    }
}