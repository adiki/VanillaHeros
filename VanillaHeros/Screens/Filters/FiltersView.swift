//
//  FiltersView.swift
//  VanillaHeros
//
//  Created by Adrian Śliwa on 25/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import UIKit

class FiltersView: UIView {
    var favouritesSwitchChangedValue: ((Bool) -> Void)?
    var doneButtonTapped: (() -> Void)?
    let favouritesLabel = UILabel()
    let favouritesSwitch = UISwitch()
    let doneButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        backgroundColor = Colors.backgroundColor
        
        favouritesLabel.text = Strings.showsOnlyFavouriteHeros
        favouritesLabel.textColor = Colors.textColor
        addSubview(favouritesLabel)
        favouritesLabel.translatesAutoresizingMaskIntoConstraints = false
        favouritesLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 16).isActive = true
        favouritesLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        
        favouritesSwitch.addTarget(
            self,
            action: #selector(favouritesSwitchValueChanged),
            for: .valueChanged
        )
        favouritesSwitch.onTintColor = .red
        addSubview(favouritesSwitch)
        favouritesSwitch.translatesAutoresizingMaskIntoConstraints = false
        favouritesSwitch.centerYAnchor.constraint(equalTo: favouritesLabel.centerYAnchor).isActive = true
        favouritesSwitch.leadingAnchor.constraint(equalTo: favouritesLabel.trailingAnchor).isActive = true
        favouritesSwitch.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        
        doneButton.addTarget(
            self,
            action: #selector(doneButtonTouchUpInside),
            for: .touchUpInside
        )
        doneButton.backgroundColor = Colors.buttonColor
        doneButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).bold()
        doneButton.layer.cornerRadius = 8
        doneButton.setTitle(Strings.done, for: .normal)
        addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func favouritesSwitchValueChanged() {
        favouritesSwitchChangedValue?(favouritesSwitch.isOn)
    }
    
    @objc private func doneButtonTouchUpInside() {
        doneButtonTapped?()
    }
}
