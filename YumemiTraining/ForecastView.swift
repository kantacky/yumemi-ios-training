//
//  ForecastView.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import SwiftUI

struct ForecastView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ForecastViewModel
    @State private var buttonsSize = CGSize.zero

    var body: some View {
        VStack(spacing: 80) {
            VStack {
                Group {
                    if let weather = self.viewModel.weather {
                        weather.weatherCondition.image
                            .scaledToFit()
                    } else {
                        Color.gray
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .containerRelativeFrame(
                    .horizontal,
                    count: 2,
                    spacing: .zero
                )

                TemperatureView(
                    maxTemperature: viewModel.weather?.maxTemperature,
                    minTemperature: viewModel.weather?.minTemperature
                )
            }

            HStack(spacing: 0) {
                Button {
                    self.dismiss()
                } label: {
                    Text("Close")
                }
                .containerRelativeFrame(
                    .horizontal,
                    count: 4,
                    span: 1,
                    spacing: .zero,
                    alignment: .center
                )

                Button {
                    // Reload Action
                    self.viewModel.reload(area: "tokyo", date: .now)
                } label: {
                    Text("Reload")
                }
                .containerRelativeFrame(
                    .horizontal,
                    count: 4,
                    span: 1,
                    spacing: .zero,
                    alignment: .center
                )
            }
            .readSize { size in
                self.buttonsSize = size
            }
        }
        .offset(.init(width: 0, height: (self.buttonsSize.height + 80) / 2))
        .onAppear {
            viewModel.reload(area: "tokyo", date: .now)
        }
        .alert(
            "There was an Error Retrieving Weather.",
            isPresented: $viewModel.isAlertPresented
        ) {} message: {
            if let message = viewModel.alertMessage {
                Text(message)
            }
        }
        .onChange(of: self.scenePhase, { oldValue, newValue in
            switch (oldValue, newValue) {
            case (.background, .inactive):
                viewModel.isAlertPresented = false
                viewModel.reload(area: "tokyo", date: .now)

            default:
                return
            }
        })
        // MARK: Alternative
        // .onReceive(NotificationCenter.default.publisher(
        //     for: UIApplication.willEnterForegroundNotification
        // )) { _ in
        //     self.viewModel.reload()
        // }
    }
}

#Preview {
    ForecastView(viewModel: ForecastViewModel())
}
