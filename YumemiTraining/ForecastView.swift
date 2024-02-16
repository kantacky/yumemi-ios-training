//
//  ContentView.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import SwiftUI

struct ForecastView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 80) {
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(.gray)
                        
                        Text("Image")
                            .foregroundStyle(.white)
                    }
                    .frame(
                        width: geometry.size.width / 2,
                        height: geometry.size.width / 2
                    )
                    
                    HStack(spacing: 0) {
                        Text("--")
                            .foregroundStyle(.blue)
                            .frame(width: geometry.size.width / 4)
                        
                        Text("--")
                            .foregroundStyle(.red)
                            .frame(width: geometry.size.width / 4)
                    }
                }
                
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
            }
            .position(
                x: geometry.frame(in: .local).midX,
                y: geometry.frame(in: .local).midY
            )
        }
    }
}

#Preview {
    ForecastView()
}
