//
//  CustomBar.swift
//  DailyFacts
//
//  Created by Genadi C on 10/09/2023.
//

import SwiftUI

struct CustomBar: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            switch selectedIndex {
            case 0:
                // Your home view
                FactView()
//            case 1:
                // Your search view
//                AddView()
            case 1:
                // Your profile view
                FavouriteView()
//            case 3:
//                UploadJSON()
            default:
                EmptyView()
            }
            CustomTabBar(selectedIndex: $selectedIndex)
            
        }
    }
}
