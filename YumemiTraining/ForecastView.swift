//
//  ContentView.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import SwiftUI

struct ForecastView: View {
    @State private var labelHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Image
                Image("")
                    .frame(
                        width: geometry.size.width / 2,
                        height: geometry.size.width / 2
                    )
                    .border(Color.black)
                
                // Labels
                HStack(spacing: 0) {
                    Text("--")
                        .foregroundStyle(.blue)
                        .frame(width: geometry.size.width / 4)
                    
                    Text("--")
                        .foregroundStyle(.red)
                        .frame(width: geometry.size.width / 4)
                }
                .background {
                    GeometryReader { labelGeometry in
                        Path { _ in
                            Task {
                                self.labelHeight = labelGeometry.size.height
                            }
                        }
                    }
                }
            }
            .position(
                x: geometry.frame(in: .local).midX,
                y: geometry.frame(in: .local).midY
            )

            // Buttons
            HStack(spacing: 0) {
                Button {
                    // TODO: Close Action
                } label: {
                    Text("Close")
                }
                .frame(width: geometry.size.width / 4)
                
                Button {
                    // TODO: Reload Action
                } label: {
                    Text("Reload")
                }
                .frame(width: geometry.size.width / 4)
            }
            .position(
                x: geometry.frame(in: .local).midX,
                y: geometry.frame(in: .local).midY + geometry.size.width / 4 + labelHeight + 8 + 80
            )
        }
    }
}

#Preview {
    ForecastView()
}
