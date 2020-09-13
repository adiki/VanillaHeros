//
//  Colors.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

struct Colors {
    let primary: UIColor
    let background: UIColor
    let text: UIColor
    let row: UIColor
    let rowHighlighted: UIColor
    let imageViewBackground: UIColor
}

extension Colors {
    static let current = Colors(
        primary: .red,
        background: UIColor(red: 0.133, green: 0.145, blue: 0.169, alpha: 1),
        text: .white,
        row: UIColor(red: 0.212, green: 0.231, blue: 0.270, alpha: 1),
        rowHighlighted: .darkGray,
        imageViewBackground: .gray
    )
}
