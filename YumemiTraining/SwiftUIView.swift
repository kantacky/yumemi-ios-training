//
//  SwiftUIView.swift
//  YumemiTraining
//
//  Created by 及川 寛太 on 2024/02/16.
//

import SwiftUI

struct SwiftUIView: View {
    var items: [Int] = [0, 1, 2, 3]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10.0) {
                ForEach(items, id: \.self) { item in
                    Rectangle()
                        .fill(.purple)
                        .aspectRatio(3.0 / 2.0, contentMode: .fit)
                        .containerRelativeFrame(
                            .horizontal, count: 4, span: 3, spacing: 10.0)
                }
            }
        }
        .safeAreaPadding(.horizontal, 20.0)
    }
}

#Preview {
    SwiftUIView()
}
