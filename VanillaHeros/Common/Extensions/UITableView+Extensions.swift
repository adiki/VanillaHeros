//
//  UITableView+Extensions.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 24/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

extension UITableView {
    func register(_ cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: cellClass.description())
    }

    func dequeueReusableCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) -> Cell {
        guard let someCell = dequeueReusableCell(withIdentifier: cellClass.description()) as? Cell else {
            fatalError("Not supported cell type")
        }
        return someCell
    }
}

