//
//  LoadingView.swift
//  BreezeDemoApp
//
//  Created by Andrea Scuderi on 27/05/2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            ProgressView()
                .scaleEffect(1.5)
                .frame(width: 100, height: 100)
                .background(.white.opacity(0.9))
                .cornerRadius(15.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.75))
    }
}

#Preview {
    ZStack {
        Text("Something below the view")
        LoadingView()
    }
}
