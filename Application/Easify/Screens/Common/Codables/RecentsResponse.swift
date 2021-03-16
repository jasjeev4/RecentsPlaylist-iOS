//
//  Response.swifrt.swift
//  RecentsPlaylist
//
//  Created by Jasjeev on 3/16/21.
//  Copyright © 2021 Logarithmic Science. All rights reserved.
//

import Foundation

struct RecentsResponse: Codable {
    var status: Int
    var result: RecentsResult
}
