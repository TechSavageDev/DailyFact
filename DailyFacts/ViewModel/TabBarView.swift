//
//  TabBarView.swift
//  DailyFacts
//
//  Created by Genadi C on 15/08/2023.
//

import SwiftUI
import FirebaseAuth

struct TabBarView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedTab: Tab = .facts
    
    enum Tab {
        case facts
        case add
        case user
    }

    var body: some View {
        TabView {
            
            FactView()
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("Facts")
                }
                .tag(Tab.facts)
            
            AddView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add") 
                }
                .tag(Tab.add)
            
            FavouriteView()
                .tabItem{
                    Image(systemName: "heart.circle")
                    Text("Favourite")
                }
                .tag(Tab.user)
            
            UploadJSON()
                .tabItem{
                    
                    Image(systemName: "externaldrive.fill.badge.plus")
                    Text("Upload")
                }
        }
        .accentColor(colorScheme == .light ? Color("LText") : .white)
    }
}

#Preview {
    TabBarView()
}
