//
//  WeatherListView.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import SwiftUI

struct WeatherListView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Bindable var viewModel: WeatherListViewModel

    var body: some View {
        NavigationStack {
            if viewModel.weatherList.isEmpty && viewModel.isLoading {
                ProgressView()
            } else {
                List(viewModel.weatherList, id: \.self) { weather in
                    NavigationLink(value: weather) {
                        HStack {
                            HStack {
                                weather.info.weatherCondition.image
                                    .scaledToFit()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(height: 24)

                                Text(weather.area)
                            }

                            Spacer()

                            HStack {
                                Text("\(weather.info.minTemperature)")
                                    .foregroundStyle(.blue)
                                Text("/")
                                    .foregroundStyle(.secondary)
                                Text("\(weather.info.maxTemperature)")
                                    .foregroundStyle(.red)
                            }
                            .fontDesign(.monospaced)
                        }
                    }
                }
                .navigationDestination(for: Weather.self) { weather in
                    ForecastView(viewModel: ForecastViewModel(weather: weather))
                        .navigationTitle(weather.area)
                }
                .refreshable { await reload() }
            }
        }
        .alert(
            "There was an Error Retrieving Weather.",
            isPresented: $viewModel.isAlertPresented,
            presenting: viewModel.alertMessage,
            actions: { _ in },
            message: Text.init
        )
        .task { await viewModel.reload(date: .now) }
        .onChange(of: scenePhase) { oldValue, newValue in
            switch (oldValue, newValue) {
            case (.background, .inactive):
                viewModel.isAlertPresented = false
                reload()

            default:
                return
            }
        }
    }
}

private extension WeatherListView {
    func reload() {
        Task { await reload() }
    }

    func reload() async {
        await viewModel.reload(date: .now)
    }
}

#Preview {
    WeatherListView(viewModel: WeatherListViewModel())
}
