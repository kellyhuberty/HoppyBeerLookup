//
//  Beer.swift
//  Hoppy
//
//  Created by Kelly Huberty on 12/15/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

import Foundation
/**
Beer is the Codable model used to parse data from the BreweryDB backend, but also facilitates
 the duties of the actual model used, by conforming to the `BeerShortDisplayable`
 and `BeerFullDisplayable` methods.
 */
class Beer : Codable{
    
    ///Represents the label image of the beer.
    struct Labels : Codable{
        let icon: URL?
        let medium: URL?
        let large: URL?
    }
    
    let `id` : String
    let name : String
    
    let abv : String?
    let ibu : String?

    let description : String?
    
    ///The label image urls.
    let labels: Labels?
    
    ///Beer style.
    let style: Style?
    
    ///Brewery beer came from
    let breweries: [Brewery]?
    
    ///Additional socail info provided.
    let socialAccounts:[SocailAccount]?
}

///The brewery created by the beer.
class Brewery : Codable {
    let `id` : String?
    let name : String?
    let nameShortDisplay : String?
    let description : String?
}

///The represted style of a beer.
class Style : Codable{
    let name : String
}

///Socail data of the beer.
class SocailAccount : Codable{
    
    let name:String?
    let link:String?
    
}

//MARK: Link Displayable extension
extension SocailAccount : LinkDisplayable{
    var urlString: String? {
        return link
    }
}

//MARK: BeerShortDisplayable conformance.
extension Beer : BeerShortDisplayable{
    
    var identifier: String{
        return self.id
    }
    
    var iconURL: URL?{
        return self.labels?.icon
    }
    var breweryName : String?{
        return breweries?.first?.nameShortDisplay
    }
    //Implemented by `Beer`
    //let name : String
}

//MARK: BeerFullDisplayable conformance.
extension Beer : BeerFullDisplayable{

    var styleName:String? {
        return self.style?.name
    }
    
    var links:[LinkDisplayable]{
        return socialAccounts ?? []
    }
    
    var mediumIconURL: URL?{
        return self.labels?.medium
    }
    
    var largeIconURL: URL?{
        return self.labels?.large
    }
    
}

