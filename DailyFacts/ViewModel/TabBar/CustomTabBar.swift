//
//  CustomTabBar.swift
//  DailyFacts
//
//  Created by Genadi C on 02/09/2023.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedIndex: Int
    
    private let tabs: [Tab] = [.home, .profile]
    
    enum Tab: String {
        case home = "newspaper"
        case add = "plus"
        case profile = "heart"
        case upload = "externaldrive.badge.plus"
    }
    
    var body: some View {
        HStack {
            ForEach(tabs.indices) { index in
                TabBarItem(tab: tabs[index], index: index, selectedIndex: $selectedIndex)
            }
        }
        .frame(height: 60)
        .background(Color("LText").opacity(0.8))
        .cornerRadius(30)
        .padding(.horizontal, 20)
        .shadow(radius: 5)
    }
}

