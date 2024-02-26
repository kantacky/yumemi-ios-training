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
                    viewModel.weather.info.weatherCondition.image
                        .scaledToFit()
                        .aspectRatio(1, contentMode: .fit)
                        .containerRelativeFrame(
                            .horizontal,
                            count: 2,
                            spacing: .zero
                        )

                    TemperatureView(
                        maxTemperature: viewModel.weather.info.maxTemperature,
                        minTemperature: viewModel.weather.info.minTemperature
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
                        .disabled(viewModel.isLoading)
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
            isPresented: $viewModel.isAlertPresented,
            presenting: viewModel.alertMessage,
            actions: { _ in },
            message: Text.init
        )
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
        await viewModel.reload(date: .now)
    }
}

#Preview {
    ForecastView(
        viewModel: ForecastViewModel(
            weather: Weather(
                area: "Tokyo",
                info: WeatherInfo(
                    date: .now,
                    weatherCondition: .sunny,
                    maxTemperature: 20,
                    minTemperature: -10
                )
            )
        )
    )
}
