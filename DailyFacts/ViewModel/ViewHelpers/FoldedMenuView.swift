//
//  FooldedMenuView.swift
//  DailyFacts
//
//  Created by Genadi C on 18/08/2023.
//

import SwiftUI

struct FoldedMenuView: View {
    var body: some View{
        VStack(spacing: 20) {
            FoldedMenuItems(imageName: "gear", title: "settings")
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    FoldedMenuView()
}
