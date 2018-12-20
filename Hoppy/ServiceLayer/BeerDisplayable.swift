//
//  BeerDisplayable.swift
//  Hoppy
//
//  Created by Kelly Huberty on 12/20/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

import Foundation

/**
 BeerDisplayable.swift defines a set of protocols to expose to the View and Controller parts of the application,
 without exposing parsing and codable models. Models that are used for parsing can then be cheaply reused in the
 frontend with less fear of tying the them to the parsed data.
 */
@objc protocol BeerShortDisplayable {
    var iconURL: URL?{ get }
    var breweryName : String?{ get }
    var name : String { get }
    var identifier : String { get }
}

@objc protocol BeerFullDisplayable : BeerShortDisplayable {
    var description:String? { get }
    var links:[LinkDisplayable] { get }
    
    var abv : String? { get }
    var ibu : String? { get }
    
    var mediumIconURL: URL? { get }
    var largeIconURL: URL? { get }
}

@objc protocol LinkDisplayable {
    var name:String? { get }
    var urlString:String? { get }
}

