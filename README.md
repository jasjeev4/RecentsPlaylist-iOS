# RecentsPlaylist-iOS

Recents Playlist is an Android app that creates a playlist of recently added tracks for any Spotify user. It takes advantage of latest frameworks such as Combine and SwiftUI.

This app is derived from a fork of [Easify-iOS](https://github.com/s/Easify-iOS).

It uses a copy of [SpotifyLogin SDK](https://github.com/spotify/SpotifyLogin) to handle the login process with Spotify. 

Also this app relies on `Alamofire` module from `EasifyNetwork` module via `Swift Package Manager`. Make sure to fetch this package before running the application. 

Then you can register an application on [Spotify Developer Portal](https://developer.spotify.com/dashboard/applications) and add the following values to the `SpotifyCredentials.plist` in `EasifyCore` module:

```
<key>client_id</key>
<string>YOUR_CLIENT_ID</string>
<key>client_secret</key>
<string>YOUR_CLIENT_SECRET</string>
<key>redirect_url</key>
<string>YOUR_REDIRECT_URL</string>
```
