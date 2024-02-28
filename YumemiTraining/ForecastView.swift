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
    @Bindable var viewModel: ForecastViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 80) {
                VStack {
                    Group {
                        if let weather = viewModel.weather {
                            weather.weatherCondition.image
                                .scaledToFit()
                        } else {
                            Color.clear
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
                    Button("Close", action: dismiss.callAsFunction)
                        .containerRelativeFrame(
                            .horizontal,
                            count: 4,
                            span: 1,
                            spacing: .zero,
                            alignment: .center
                        )

                    Button("Reload", action: reload)
                        .containerRelativeFrame(
                            .horizontal,
                            count: 4,
                            span: 1,
                            spacing: .zero,
                            alignment: .center
                        )
                }
            }

            if viewModel.isLoading {
                ProgressView()
                    .offset(y: 100)
            }
        }
        .task { await reload() }
        .alert(
            "There was an Error Retrieving Weather.",
            isPresented: $viewModel.isAlertPresented
        ) {} message: {
            if let message = viewModel.alertMessage {
                Text(message)
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            switch (oldValue, newValue) {
            case (.background, .inactive):
                viewModel.isAlertPresented = false
                reload()

            default:
                return
            }
        }
        // MARK: Alternative
        // .onReceive(NotificationCenter.default.publisher(
        //     for: UIApplication.willEnterForegroundNotification
        // )) { _ in
        //     viewModel.reload()
        // }
    }
}

private extension ForecastView {
    func reload() {
        Task { await reload() }
    }

    func reload() async {
        await viewModel.reload(at: "tokyo", date: .now)
    }
}

#Preview {
    ForecastView(viewModel: ForecastViewModel())
}
