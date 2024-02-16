//
//  NewView.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import SwiftUI

struct NewView: View {
    @State var isPresented: Bool = false

    var body: some View {
        EmptyView()
            .onAppear {
                self.isPresented = true
            }
            .fullScreenCover(isPresented: $isPresented) {
                self.isPresented = true
            } content: {
                ForecastView(
                    viewModel: ForecastViewModelImpl()
                )
            }
    }
}

#Preview {
    NewView()
}
