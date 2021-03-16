//
//  ContainerView.swift
//  Easify
//
//  Created by Muhammed Said Özcan on 18/05/2020.
//  Copyright © 2020 Muhammed Said Özcan. All rights reserved.
//

import SwiftUI
import EasifyCore

// MARK: - ContainerView
/// Provides a view based on the user authorization status with Spotify API. If the user is logged in returns `HomeView` otherwise returns `LoginView`.
struct ContainerView {
    // MARK: - Properties
    @EnvironmentObject var spotifyService: SpotifyService
    @ObservedObject var model = RecentsModel()
    
    var body: some View {
        if(spotifyService.isLoggedIn) {
            self.model.onLogin(spotifyService: spotifyService)
            return AnyView(HomeView())
        } else {
            return AnyView(LoginView())
        }
    }
    
//    var body: some Scene {
//        WindowGroup {
//            if spotifyService.isLoggedIn {
//                TextView()
//            }
//            else {
//                return AnyView(LoginView())
//            }
//        }
}

class RecentsModel: ObservableObject {
    let baseurl = "https://us-central1-primary-server-168620.cloudfunctions.net/recents-ios?token="
    
    func onLogin(spotifyService: SpotifyService){
        spotifyService.getAccessToken {(accessToken, error) in
            if error == nil {
                self.makeRequest(accessToken: accessToken!)
            }
            else {
                print(error!)
            }
        }
    }
    
    
    func makeRequest(accessToken: String) {
        let stringurl = baseurl + accessToken
        guard let url = URL(string: stringurl) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let returnData = String(data: data, encoding: .utf8)
                print(returnData)
                if let decodedResponse = try? JSONDecoder().decode(RecentsResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        if(decodedResponse.status == 0) {
                            print("There was an error with the backend")
                        }
                        else {
                            // self.results = decodedResponse.results
                            print(decodedResponse.result.tracks[0].name)
                        }
                    }

                    // everything is good, so we can exit
                    return
                }
            }
            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()

                
    }
}

// MARK: - ContainerView: View
extension ContainerView: View {
    
}

#if DEBUG
// MARK: - ContainerView_Previews: PreviewProvider
struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
#endif
