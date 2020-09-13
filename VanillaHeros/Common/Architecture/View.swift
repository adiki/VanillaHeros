//
//  View.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 11/09/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class View: UIView {
    let designLibrary: DesignLibrary
    
    required init(designLibrary: DesignLibrary) {
        self.designLibrary = designLibrary
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
    }
    
    func setupLayout() {
        
    }
}
