//
//  BeerUpdater.swift
//  Hoppy
//
//  Created by Kelly Huberty on 12/20/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

import Foundation

/**
 Provides and interface for events thrown by the `BeerUpdater` class
 */
@objc protocol BeerUpdaterDelegate : class {
    
    ///
    func beerUpdaterDidBegin(_ beerUpdater:BeerUpdater)
    
    ///
    func beerUpdaterDidFinish(_ beerUpdater:BeerUpdater)
    
    ///
    func beerUpdater(_ beerUpdater:BeerUpdater, finishedWith error:Error)
    
}

@objc class BeerUpdater : NSObject {
    
    //MARK: public interface
    @objc weak var delegate : BeerUpdaterDelegate?
    
    @objc func updateToFull(short: BeerShortDisplayable){
        updatedBeer = nil
        _ = network.requestFullBeer (short.identifier) { (result) in
            self.process(result)
        }
    }
    
    @objc var updatedBeer:BeerFullDisplayable? = nil
    
    @objc var isUpdating:Bool{
        return updateOperation != nil ? true : false
    }
    
    //MARK: init
    required init(network newNetwork:Network) {
        network = newNetwork
        super.init()
    }
    
    
    //MARK: implementation
    private let network:Network
    
    private var updateOperation:NetworkToken? = nil
    
    private func process(_ results:NetworkResult<Beer>){
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else{
                return
            }
            strongSelf.updateOperation = nil
            switch results {
            case .success(let beer):
                strongSelf.updatedBeer = beer
                strongSelf.delegate?.beerUpdaterDidFinish(strongSelf)
            case .failure(let networkError):
                strongSelf.delegate?.beerUpdater(strongSelf, finishedWith: networkError)
            }
        }
        
    }
    
    
}

