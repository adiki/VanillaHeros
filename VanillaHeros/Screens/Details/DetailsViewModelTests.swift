//
//  DetailsViewModelTests.swift
//  VanillaHerosTests
//
//  Created by Adrian Śliwa on 26/08/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import XCTest
@testable import VanillaHeros

class DetailsViewModelTests: XCTestCase {
    let hero = Hero.fixture(id: 0)
    var favourites: FavouritesMock!
    var herosProvider: HerosProviderMock!
    var testScheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        favourites = FavouritesMock()
        herosProvider = HerosProviderMock()
        testScheduler = TestScheduler()
    }
    
    func test_favouriteHeroWithoutImageData() {
        favourites.isHeroFavouriteMocked = true
        let data = Data()
        herosProvider.imageDataResultMocked = .success(data)
        let viewModel = makeViewModel(heroImageData: nil)
        viewModel.send(action: .initialize)
        testScheduler.advance()
        XCTAssertEqual(viewModel.store.state.isHeroFavourite, true)
        XCTAssertEqual(viewModel.store.state.heroImageData, data)
        viewModel.send(action: .favouritesButtonTapped)
        testScheduler.advance()
        XCTAssertEqual(viewModel.store.state.isHeroFavourite, false)
        XCTAssertEqual(favourites.saveFavouritesCallsNumber, 1)
        viewModel.send(action: .favouritesButtonTapped)
        testScheduler.advance()
        XCTAssertEqual(viewModel.store.state.isHeroFavourite, true)
        XCTAssertEqual(favourites.saveFavouritesCallsNumber, 2)
    }
    
    private func makeViewModel(heroImageData: Data?) -> DetailsViewModel {
        let environment = DetailsViewModel.Environment(
            favourites: favourites,
            herosProvider: herosProvider
        )
        let viewModel = DetailsViewModel(
            hero: hero,
            heroImageData: heroImageData,
            environment: environment,
            scheduler: testScheduler
        )
        return viewModel
    }
}
