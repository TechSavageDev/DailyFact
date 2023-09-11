//
//  ProgressView.swift
//  DailyFacts
//
//  Created by Genadi C on 02/09/2023.
//

import SwiftUI

// Linear ProgressBar View
struct ProgressBar: View {
    @Binding var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                withAnimation(.linear(duration: 0.5)) {
                    Rectangle()
                        .frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                        .foregroundColor(Color("TabColor"))
                }
            }
            .cornerRadius(5.0)
        }
    }
}
