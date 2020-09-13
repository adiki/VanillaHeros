//
//  FiltersView.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 25/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class FiltersView: View {
    var favouritesSwitchChangedValue: ((Bool) -> Void)?
    var doneButtonTapped: (() -> Void)?
    let favouritesLabel: UILabel
    let favouritesSwitch: UISwitch
    let doneButton: UIButton
    
    required init(designLibrary: DesignLibrary) {
        favouritesLabel = designLibrary.label()
        favouritesSwitch = designLibrary.switch()
        doneButton = designLibrary.primaryButton()
        super.init(designLibrary: designLibrary)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        backgroundColor = designLibrary.colors.background
        favouritesLabel.text = Strings.showsOnlyFavouriteHeros
        favouritesSwitch.addTarget(
            self,
            action: #selector(favouritesSwitchValueChanged),
            for: .valueChanged
        )
        doneButton.addTarget(
            self,
            action: #selector(doneButtonTouchUpInside),
            for: .touchUpInside
        )
        doneButton.setTitle(Strings.done, for: .normal)
    }
    
    override func setupLayout() {
        layoutMargins.top = DesignLibrary.Metrics.Padding.standard
        
        addSubview(favouritesLabel)
        favouritesLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        favouritesLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        
        addSubview(favouritesSwitch)
        favouritesSwitch.centerYAnchor.constraint(equalTo: favouritesLabel.centerYAnchor).isActive = true
        favouritesSwitch.leadingAnchor.constraint(equalTo: favouritesLabel.trailingAnchor).isActive = true
        favouritesSwitch.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        
        addSubview(doneButton)
        doneButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    @objc private func favouritesSwitchValueChanged() {
        favouritesSwitchChangedValue?(favouritesSwitch.isOn)
    }
    
    @objc private func doneButtonTouchUpInside() {
        doneButtonTapped?()
    }
}
