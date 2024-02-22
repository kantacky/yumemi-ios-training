//
//  ForecastView.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import SwiftUI

struct ForecastView<ViewModel: ForecastViewModel>: View {
    @StateObject var viewModel: ViewModel
    @State private var buttonsSize: CGSize = .zero

    var body: some View {
        VStack(spacing: .init(80)) {
            VStack {
                // Image
                Group {
                    if let weatherCondition = self.viewModel.weatherCondition {
                        weatherCondition.image
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

                // Labels
                HStack(spacing: .zero) {
                    Text("--")
                        .foregroundStyle(.blue)
                        .containerRelativeFrame(
                            .horizontal,
                            count: 4,
                            spacing: .zero
                        )

                    Text("--")
                        .foregroundStyle(.red)
                        .containerRelativeFrame(
                            .horizontal,
                            count: 4,
                            spacing: .zero
                        )
                }
            }

            // Buttons
            HStack(spacing: 0) {
                Button {
                    // TODO: Close Action
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
                    self.viewModel.reload()
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
            viewModel.reload()
        }
        .alert(
            "There was an Error Retrieving Weather.",
            isPresented: $viewModel.isAlertPresented
        ) {} message: {
            if let message = viewModel.alertMessage {
                Text(message)
            }
        }

    }
}

#Preview {
    ForecastView(viewModel: ForecastViewModelImpl())
}
