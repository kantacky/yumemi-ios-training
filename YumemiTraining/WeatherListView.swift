//
//  WeatherListView.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/20.
//

import SwiftUI
import YumemiWeather

struct WeatherListView: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var viewModel: WeatherListViewModel

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
                .refreshable {
                    await viewModel.reload(
                        areas: Area.allCases.map(\.rawValue),
                        date: .now
                    )
                }
            }
        }
        .alert(
            "There was an Error Retrieving Weather.",
            isPresented: $viewModel.isAlertPresented,
            presenting: viewModel.alertMessage,
            actions: { _ in },
            message: Text.init
        )
        .task {
            await viewModel.reload(
                areas: Area.allCases.map(\.rawValue),
                date: .now
            )
        }
        .onChange(of: scenePhase) { _, newValue in
            switch newValue {
            case .active:
                Task {
                    await viewModel.reload(areas: Area.allCases.map { $0.rawValue }, date: .now)
                }

            default:
                return
            }
        }
    }
}

#Preview {
    WeatherListView(viewModel: WeatherListViewModel())
}
