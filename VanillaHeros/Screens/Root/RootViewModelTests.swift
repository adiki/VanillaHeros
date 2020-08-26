//
//  RootViewModelTests.swift
//  VanillaHerosTests
//
//  Created by Adrian Śliwa on 26/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import XCTest
@testable import VanillaHeros

class RootViewModelTests: XCTestCase {
    var favourites: FavouritesMock!
    var herosProvider: HerosProviderMock!
    var testScheduler: TestScheduler!
    var routes = [RootViewModel.Route]()
    
    override func setUp() {
        super.setUp()
        favourites = FavouritesMock()
        herosProvider = HerosProviderMock()
        testScheduler = TestScheduler()
    }
    
    func test_loading_selectingFilters_selectingHero_andAddingItToFavourites() {
        favourites.isHeroFavouriteMocked = true
        let hero0 = Hero.fixture(id: 0)
        let hero1 = Hero.fixture(id: 1)
        let hero2 = Hero.fixture(id: 2)
        let heros = [hero0, hero1, hero2]
        herosProvider.fetchHerosMocked = .success(heros)
        favourites.loadFavouritesMocked = .success([1, 2])
        favourites.isFavouritesOnlyFilterOn = false
        let viewModel = makeViewModel()
        XCTAssertEqual(viewModel.store.state.status, .idle)
        viewModel.send(action: .load)
        XCTAssertEqual(viewModel.store.state.status, .loading)
        testScheduler.advance()
        XCTAssertEqual(viewModel.store.state.status, .loaded)
        XCTAssertEqual(viewModel.store.state.heros, heros)
        XCTAssertEqual(viewModel.store.state.favouriteHeroIds, [1, 2])
        XCTAssertEqual(viewModel.store.state.isFavouritesOnlyFilterOn, false)
        viewModel.send(action: .openFilters)
        XCTAssertEqual(routes[0], .openFilters)
        viewModel.send(action: .didUpdate(favourites: [1, 2], isFavouritesOnlyFilterOn: true))
        XCTAssertEqual(viewModel.store.state.favouriteHeroIds, [1, 2])
        XCTAssertEqual(viewModel.store.state.isFavouritesOnlyFilterOn, true)
        viewModel.send(action: .didSelect(hero: hero0))
        XCTAssertEqual(routes[1], .heroSelected(hero: hero0, heroImageData: nil))
        viewModel.send(action: .didUpdate(favourites: [0, 1, 2], isFavouritesOnlyFilterOn: true))
        XCTAssertEqual(viewModel.store.state.favouriteHeroIds, [0, 1, 2])
        XCTAssertEqual(viewModel.store.state.isFavouritesOnlyFilterOn, true)
    }
    
    private func makeViewModel() -> RootViewModel {
        let environment = RootViewModel.Environment(
            favourites: favourites,
            herosProvider: herosProvider,
            synchronize: TestSynchronize()
        )
        let viewModel = RootViewModel(
            environment: environment,
            scheduler: testScheduler
        )
        viewModel.store.handleRoute = { [weak self] route in
            self?.routes.append(route)
        }
        return viewModel
    }
}
