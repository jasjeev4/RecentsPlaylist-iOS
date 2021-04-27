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
import SwiftyJSON

// MARK: HomeView
/// `HomeView` shows a list of tab items with its contents.

struct Track: Identifiable {
    let id = UUID()
    let name: String
    let artists: String
    let album: String
}

// A view that shows the data for one Track.
struct TrackRow: View {
    var track: Track

    var body: some View {
        VStack(alignment: .leading){
            Text(track.name).fontWeight(.heavy)
            Text(track.artists)
            Text(track.album)
        }.padding()
    }
}

extension UIColor {
    static let goldColor = UIColor(red: 252.0/255.0, green: 195.0/255.0, blue: 0.0/255.0, alpha: 1.0)
}

struct HomeView: View {
    @EnvironmentObject var spotifyService: SpotifyService
    @ObservedObject var recentsModel = RecentsModel()
    
    var body: some View {
        VStack{
            if(self.recentsModel.shouldRedirectToHomeView) {
                HStack{
                        VStack(alignment: .leading){
                            Text("Recents Playlist")
                                .font(.system(size: 30, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            Text("Playlist available on your Spotify!")
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .foregroundColor(.white)
                        }   .padding(30)
                        Spacer()
                }.background(Color(.goldColor))
                    
                List(self.recentsModel.tracks) { track in
                    TrackRow(track: track)
                }
            }
            else {
                ProgressView()
                    .scaleEffect(2.5, anchor: .center)
            }
        }
        .onAppear{
            self.recentsModel.onLogin(spotifyService: spotifyService)
        }
    }
    
}

class RecentsModel: ObservableObject {
    @Published var shouldRedirectToHomeView = false
    var tracks = [Track]()
    
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
            if(error != nil){
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
            else
            {
                if let data = data {
                    // let returnData = String(data: data, encoding: .utf8)
                    let json = JSON(data)
                    debugPrint(json)
                        // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        print(json["status"].intValue)
                        // update our UI
                        if(json["status"].intValue == 1) {
                            self.processPlaylist(result: json["result"])
                        }
                        else {
                            print("There was an error with the backend")
                        }
                    }
                    // everything is good, so we can exit
                    return
                }
            }
        }.resume()
    }
    
    func processPlaylist(result: JSON) {
        let playlist = result["playlist"]["tracks"]
        
        for (_, trackData):(String, JSON) in playlist {
            let currentTrack = Track(
                name: trackData["name"].stringValue,
                artists: trackData["artists"].stringValue,
                album: trackData["album"].stringValue
            )
            self.tracks.append(currentTrack)
        }
        
        self.shouldRedirectToHomeView = true
    }
}


struct NavigationBarModifier: ViewModifier {
        
    var backgroundColor: UIColor?
    
    init( backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white

    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
 
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }

}


#if DEBUG
// MARK: - HomeView_Previews: PreviewProvider
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
