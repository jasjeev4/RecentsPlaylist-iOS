//
//  Tracks.swift
//  RecentsPlaylist
//
//  Created by Jasjeev on 3/16/21.
//  Copyright © 2021 Logarithmic Science. All rights reserved.
//

import Foundation

struct Tracks: Codable {
    var track_id: String
    var added_date: String
    var name: String
    var artists: String
    var album: String
}
