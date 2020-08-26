//
//  FavouritesViewModelTest.swift
//  VanillaHerosTests
//
//  Created by Adrian Śliwa on 25/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import XCTest
@testable import VanillaHeros

class FavouritesViewModelTests: XCTestCase {
    var favourites: FavouritesMock!
    var routes = [FiltersViewModel.Route]()
    
    override func setUp() {
        super.setUp()
        favourites = FavouritesMock()
        routes = []
    }
    
    func test_togglingFavouritesFilter() {
        let viewModel = makeViewModel()
        viewModel.send(action: .favouritesOnlyFilterChanged(isOn: true))
        XCTAssertEqual(viewModel.store.state.isFavouritesOnlyFilterOn, true)
        XCTAssertEqual(favourites.isFavouritesOnlyFilterOn, true)
        viewModel.send(action: .favouritesOnlyFilterChanged(isOn: false))
        XCTAssertEqual(viewModel.store.state.isFavouritesOnlyFilterOn, false)
        XCTAssertEqual(favourites.isFavouritesOnlyFilterOn, false)
    }
    
    func test_tappingDone() {
        let viewModel = makeViewModel()
        viewModel.send(action: .done)
        XCTAssertEqual(routes, [.done])
    }
    
    private func makeViewModel() -> FiltersViewModel {
        let environment = FiltersViewModel.Environment(
            favourites: favourites
        )
        let viewModel = FiltersViewModel(
            environment: environment,
            scheduler: TestScheduler()
        )
        viewModel.store.handleRoute = { [weak self] route in
            self?.routes.append(route)
        }
        return viewModel
    }
}
