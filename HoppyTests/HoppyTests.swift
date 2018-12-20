//
//  HoppyTests.swift
//  HoppyTests
//
//  Created by Kelly Huberty on 12/15/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

import XCTest
@testable import Hoppy

class HoppyTests: XCTestCase {

    let networkTimeout = TimeInterval(10)

    //Short responses
    
    func testSearchBeer() {
        
        let waitExpectation = self.expectation(description: "NetworkComplete")
        
        let network = Network()
        _ = network.requestBeerSearch(query:"P") { (result) in
            switch result {
            case .success(let data):
                XCTAssert(data.count > 0)
            case .failure(let error):
                print("Error: \(error)")
                XCTFail()
            }
            
            waitExpectation.fulfill()
        }
        
        self.wait(for: [waitExpectation], timeout: networkTimeout)
        
    }
    
    func testSearchBeerEmptyQuery() {
        
        let waitExpectation = self.expectation(description: "NetworkComplete")
        
        let network = Network()
        _ = network.requestBeerSearch(query:"") { (result) in
            switch result {
            case .success(let data):
                XCTAssert(data.count == 0)
            case .failure(let error):
                print("Error: \(error)")
                XCTFail()
            }
            
            waitExpectation.fulfill()
        }
        
        self.wait(for: [waitExpectation], timeout: networkTimeout)
        
    }
    
    //Full responses
    
    func testRetrieveFullBeer() {
        
        let waitExpectation = self.expectation(description: "NetworkComplete")
        
        let network = Network()
        
        _ = network.requestFullBeer("KuflHE") { (result) in
            switch result {
            case .success(let beer):
                
                print("Beer: \(beer) retrieved!")

            case .failure(let error):
                print("Error: \(error)")
                XCTFail()
            }

            waitExpectation.fulfill()
        }
        
        self.wait(for: [waitExpectation], timeout: networkTimeout)
        
    }
    
    
    func testRetrieveFullBeerBadId() {
        
        let waitExpectation = self.expectation(description: "NetworkComplete")
        
        let network = Network()
        
        _ = network.requestFullBeer("") { (result) in
            switch result {
            case .success(let beer):
                XCTFail("Beer with bad ID was found! \(beer)")
            case .failure(let error):
                print("Error: \(error)")
            }
            
            waitExpectation.fulfill()
        }
        
        self.wait(for: [waitExpectation], timeout: networkTimeout)
        
    }
    
}
