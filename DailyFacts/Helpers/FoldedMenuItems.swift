//
//  FooldedMenuItem.swift
//  DailyFacts
//
//  Created by Genadi C on 18/08/2023.
//

import SwiftUI

struct FoldedMenuItems: View {
    let imageName: String
    let title: String
    var body: some View {
        HStack{
            Image(systemName: imageName)
                .font(.title2)
            Text(title)
                .font(.headline)
        }
        .foregroundColor(.black)
    }
}
