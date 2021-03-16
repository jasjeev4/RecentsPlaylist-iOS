//
//  Result.swift
//  RecentsPlaylist
//
//  Created by Jasjeev on 3/16/21.
//  Copyright © 2021 Logarithmic Science. All rights reserved.
//

import Foundation

struct RecentsResult: Codable {
    var user_id: String
    var playlist_id: String
    var tracks: [Tracks]
}
