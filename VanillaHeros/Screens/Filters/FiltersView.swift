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
        add(
            subview: favouritesLabel,
            constraints: [
                favouritesLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                favouritesLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
            ]
        )
        add(
            subview: favouritesSwitch,
            constraints: [
                favouritesSwitch.centerYAnchor.constraint(equalTo: favouritesLabel.centerYAnchor),
                favouritesSwitch.leadingAnchor.constraint(equalTo: favouritesLabel.trailingAnchor),
                favouritesSwitch.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            ]
        )
        add(
            subview: doneButton,
            constraints: [
                doneButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                doneButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                doneButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            ]
        )
    }
    
    @objc private func favouritesSwitchValueChanged() {
        favouritesSwitchChangedValue?(favouritesSwitch.isOn)
    }
    
    @objc private func doneButtonTouchUpInside() {
        doneButtonTapped?()
    }
}
