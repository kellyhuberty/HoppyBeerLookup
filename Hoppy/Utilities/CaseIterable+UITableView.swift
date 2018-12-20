//
//  CaseIterable+UITableView.swift
//  Hoppy
//
//  Created by Kelly Huberty on 12/16/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

import Foundation

/**
 NOTE: this was originally written by me (Kelly Huberty) for another project that I have since
 re-used elsewhere because it cleans up my table view data sources so well.
 */
extension CaseIterable where Self : Equatable{
    
    func index() -> Int{
        
        for (index, aCase) in type(of:self).allCases.enumerated() {
            
            if aCase == self {
                return index
            }
            
        }
        
        fatalError()
        
    }
    
    static func caseAt(index:Int) -> Self? {
        
        let cases = Array(allCases)
        
        if index < cases.count {
            return cases[index]
        }
        return nil
    }
    
}

