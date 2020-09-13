//
//  ViewController.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 11/09/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class ViewController<V: View>: UIViewController {
    private let designLibrary: DesignLibrary
    
    var actualView: V {
        return view as! V
    }
    
    init(designLibrary: DesignLibrary) {
        self.designLibrary = designLibrary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = V(designLibrary: designLibrary)
    }
}
