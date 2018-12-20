//
//  BeerListTableViewCell.swift
//  Hoppy
//
//  Created by Kelly Huberty on 12/17/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

import UIKit

/**
 BeerListTableViewCell is used in the list view controller to represent a single beer in a list.
 */
class BeerListTableViewCell: UITableViewCell {
//MARK: IBOutlets
    
    /// thumbnail view for the cell. Used instead of cell default image view to account for precise placement.
    @IBOutlet weak var beerImageView: UIImageView?
    
    /// name label for the beer.
    @IBOutlet weak var titleLabel: UILabel?
    
    /// brewery label for the beer.
    @IBOutlet weak var subtitleLabel: UILabel?

    /// the beer used to set info on the beer and image view.
    var beerDisplayable:BeerShortDisplayable? = nil{
        didSet{
            titleLabel?.text = beerDisplayable?.name
            subtitleLabel?.text = beerDisplayable?.breweryName
            
            if let iconURL = beerDisplayable?.iconURL {
                beerImageView?.setImage(from: iconURL)
            }else{
                beerImageView?.resetURLLoadedImage()
            }
        }
    }
    
}
