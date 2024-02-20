//
//  NewView.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import SwiftUI

struct NewView: View {
    @State private var isPresented = true

    var body: some View {
        EmptyView()
            .onAppear {
                self.isPresented = true
            }
            .fullScreenCover(isPresented: $isPresented) {
                ForecastView(
                    viewModel: ForecastViewModel()
                )
                .onDisappear {
                    self.isPresented = true
                }
            }
    }
}

#Preview {
    NewView()
}
