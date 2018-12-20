//
//  File.swift
//  Hoppy
//
//  Created by Kelly Huberty on 12/15/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

import Foundation




/**
 BeerService exposes a set of network functionality for the Brewwery DB backend:
 * a method to search it's backend using a query string
 * a way to retrieve a more full data set of beer info.
 */
@objc(HOPService) class BeerService : NSObject {
    
    static var `default`:BeerService = BeerService()
    
    private var network = Network()
    
    static let BaseURL = URL(string: "https://sandbox-api.brewerydb.com/v2/")!
    static let BeersURL = BaseURL.appendingPathComponent("beers")
    
    var beerSearch:BeerSearch{
        return BeerSearch(network: network)
    }
    
    var beerUpdater:BeerUpdater{
        return BeerUpdater(network: network)
    }
    
    
}


