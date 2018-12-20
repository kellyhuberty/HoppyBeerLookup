//
//  BeerSearch.swift
//  Hoppy
//
//  Created by Kelly Huberty on 12/20/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

import Foundation


/**
 BeerSearchDelegate defines events that the `BeerSearch` encounters and
 relays that to the ViewController layer.
 */
@objc protocol BeerSearchDelegate : class{
    
    ///Called when `searchText` property is modified and a new search is begining.
    func beerSearchDidBegin(_ beerSearch:BeerSearch)
    
    ///Called when the search is completed and new data is available to be used.
    func beerSearchDidFinish(_ beerSearch:BeerSearch)
    
    ///Called when the search is completed unsuccessfully.
    func beerSearch(_ beerService:BeerSearch, finishedWith error:Error)
}


/**
 Service level entry point to make and run searches of beers from the user.
 */
class BeerSearch : NSObject {
    
    //MARK: application interfaces
    weak var delegate : BeerSearchDelegate?
    
    
    ///The query string to search data on.
    var searchText:String?{
        willSet{
            currentSearchOperation?.cancel()
        }
        didSet{
            delegate?.beerSearchDidBegin(self)
            currentSearchOperation = network.requestBeerSearch(query: searchText ?? "", completion: { [weak self] (results) in
                self?.process(results)
            })
        }
    }
    
    ///true when a search is still running.
    var isSearching:Bool{
        return currentSearchOperation != nil ? true : false
    }
    
    /// current results count
    var totalCount:Int{
        return currentResults.count
    }
    
    /// retrieves the beer at the provided index.
    func beer(at index:Int) -> BeerShortDisplayable{
        return currentResults[index]
    }
    
    //MARK: init
    required init(network newNetwork:Network) {
        network = newNetwork
        super.init()
    }
    
    //MARK: implementation.
    
    private let network:Network
    
    private var currentSearchOperation:NetworkToken? = nil
    
    private var currentResults:[Beer] = []
    
    private func process(_ results:NetworkResult<[Beer]>){
        
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else{
                return
            }
            
            strongSelf.currentSearchOperation = nil
            
            switch results {
            case .success(let beer):
                strongSelf.currentResults = beer
                strongSelf.delegate?.beerSearchDidFinish(strongSelf)
            case .failure(let networkError):
                strongSelf.delegate?.beerSearch(strongSelf, finishedWith: networkError)
            }
        }
        
    }
    
    
}
