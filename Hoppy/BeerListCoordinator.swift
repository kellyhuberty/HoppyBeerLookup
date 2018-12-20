//
//  BeerListCoordinator.swift
//  Hoppy
//
//  Created by Kelly Huberty on 12/15/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

import UIKit

/**
 Coordinates the interacion of the BeerListViewController and BeerDetailViewController and the UISplitViewController between them.
 */
class BeerListCoordinator {
    
    static let service = BeerService()
    
    ///Split View controller used
    let splitViewController:UISplitViewController
    
    ///The "List" view controller
    private let beerListVC:BeerListViewController = BeerListViewController(beerSearch: service.beerSearch)

    ///The "Detail" view controller. Nil when undisplayed.
    private weak var beerDetailVC:BeerDetailViewController?
    
    required init(splitViewController newSplitViewController:UISplitViewController) {
        
        let primaryNavController = UINavigationController(rootViewController: beerListVC)
        let detailNavController = UINavigationController()
        
        splitViewController = newSplitViewController
        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.delegate = self
        
        splitViewController.viewControllers = [primaryNavController, detailNavController]
        beerListVC.beerListDelegate = self
        
    }

}

extension BeerListCoordinator : UISplitViewControllerDelegate {
    
    func splitViewController(_ splitVC:UISplitViewController, collapseSecondary secondary: UIViewController, onto primary: UIViewController) -> Bool{
        
        if let detailVC = beerDetailVC {
            (primary as! UINavigationController).pushViewController(detailVC, animated: false)
        }
        
        return true
    }

    func splitViewController(_ splitVC:UISplitViewController, separateSecondaryFrom: UIViewController) -> UIViewController?{
        
        let detailNavController = UINavigationController()
        
        if let detailVC = beerDetailVC {
            (separateSecondaryFrom as! UINavigationController).popToRootViewController(animated: false)
            detailNavController.pushViewController(detailVC, animated: false)
        }
        
        return detailNavController
        
    }
    
}

extension BeerListCoordinator : BeerListViewControllerDelegate{
    
    func beerListViewController(_ beerListViewController: BeerListViewController, didSelect: BeerShortDisplayable) {
        
        let beerUpdater = BeerListCoordinator.service.beerUpdater
        let beerDetailViewController = BeerDetailViewController.init(updater: beerUpdater)
        
        if splitViewController.viewControllers.count == 1 {
            (splitViewController.viewControllers.last as? UINavigationController)?.pushViewController(beerDetailViewController, animated: true)
            
        }else{
            let navController = (splitViewController.viewControllers.last as? UINavigationController)
            navController?.viewControllers = [beerDetailViewController]
        }
        
        beerUpdater.updateToFull(short: didSelect)
        beerDetailVC = beerDetailViewController
        
    }
    
}


