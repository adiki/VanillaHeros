//
//  Hero.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

struct Hero: Hashable, Codable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
}
