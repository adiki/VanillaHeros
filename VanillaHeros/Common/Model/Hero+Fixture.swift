//
//  Hero+Fixture.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

extension Hero {
    static func fixture(
        id: Int
    ) -> Hero {
        Hero(
            id: id,
            name: "Hero \(id)",
            description: "Hero \(id) description",
            thumbnail: Thumbnail(path: "", extension: "jpg")
        )
    }
}
