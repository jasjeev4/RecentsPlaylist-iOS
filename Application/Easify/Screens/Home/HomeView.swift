//
//  HomeView.swift
//  Easify
//
//  Created by Muhammed Said Özcan on 18/05/2020.
//  Copyright © 2020 Muhammed Said Özcan. All rights reserved.
//

import SwiftUI
import EasifyCore
import EasifyUI

// MARK: HomeView
/// `HomeView` shows a list of tab items with its contents.
struct HomeView: View {
    @EnvironmentObject var spotifyService: SpotifyService
    @ObservedObject var model = RecentsModel()
    
    var body: some View {
        Text("loggedin")
}
    
//    private let contents: [EasifyUITabBarItem] = [
//        RecentlyPlayedTabBarItem(),
//        SettingsTabBarItem()
//    ]
}

#if DEBUG
// MARK: - HomeView_Previews: PreviewProvider
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
