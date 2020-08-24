//
//  UIView+Extensions.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

extension UIView {
    func viewsInside<V: UIView>() -> [V] {
        var views = [V]()
        if let view = self as? V {
            views.append(view)
        } else {
            for subview in subviews {
                let viewInside: [V] = subview.viewsInside()
                views.append(contentsOf: viewInside)
            }
        }
        return views
    }
}
