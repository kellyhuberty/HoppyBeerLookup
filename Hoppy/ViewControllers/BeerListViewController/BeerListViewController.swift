//
//  BeerListViewController.swift
//  Hoppy
//
//  Created by Kelly Huberty on 12/15/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

import UIKit


/**
 Displays a list of beers and a search interface to display them.
 */
class BeerListViewController: UITableViewController {

    //Represents all the cell sections.
    enum Section : String, CaseIterable{
        case loading = "LoadingTableViewCell"
        case data = "BeerListTableViewCell"
    }
    
    //delegate for selections
    weak var beerListDelegate:BeerListViewControllerDelegate?
    
    //the search object
    private let search:BeerSearch
    
    //The top search bar
    private let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = NSLocalizedString("Search Beers", comment: "Search Beers")
        return searchBar
    }()
    
    //MARK: init
    required init(beerSearch:BeerSearch) {
        search = beerSearch
        super.init(nibName: nil, bundle: nil)
        search.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
    
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: lifecycle
    override func viewDidLoad() {
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        search.searchText = ""
        
        //Register Cells
        tableView.register(UINib(nibName: Section.loading.rawValue, bundle: nil), forCellReuseIdentifier: Section.loading.rawValue)
        tableView.register(UINib(nibName: Section.data.rawValue, bundle: nil), forCellReuseIdentifier: Section.data.rawValue)
        
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let tableSection = Section.caseAt(index: section) else{
            return 0
        }
        
        switch tableSection {
        case .loading:
            return search.isSearching == true ? 1 : 0
        case .data:
            return search.totalCount
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section.caseAt(index: indexPath.section) else{
            fatalError("Invalid section")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: section.rawValue, for: indexPath)

        if section == .data {
            
            let beer = search.beer(at:indexPath.row)
            (cell as? BeerListTableViewCell)?.beerDisplayable = beer
            
        }
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = Section.caseAt(index: indexPath.section), section == .data else{
            return
        }
        
        let beer = search.beer(at: indexPath.row)
        
        //Let's delegate know we've selected a beer.
        beerListDelegate?.beerListViewController(self, didSelect: beer)
        
    }

}

//MARK:- BeerSearchDelegate

//For receiving events when data is ready to queried from search.
extension BeerListViewController : BeerSearchDelegate{
    
    func beerSearchDidBegin(_ beerSearch: BeerSearch) {
        tableView.reloadData()
    }
    
    func beerSearchDidFinish(_ beerSearch: BeerSearch) {
        tableView.reloadData()
    }
    
    func beerSearch(_ beerService: BeerSearch, finishedWith error: Error) {
        tableView.reloadData()
    }
    
}

//MARK:- UISearchBarDelegate for recieving data from user
extension BeerListViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar:UISearchBar, textDidChange: String){
        
        search.searchText = textDidChange
        
    }
    
}


//MARK:- BeerListViewControllerDelegate

/**
 BeerListViewControllerDelegate provides an interface for receiving information about a selection after
 a user has selected a beer.
 */
protocol BeerListViewControllerDelegate : class {
    
    func beerListViewController(_ beerListViewController:BeerListViewController, didSelect:BeerShortDisplayable)
    
}
