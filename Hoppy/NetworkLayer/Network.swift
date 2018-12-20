//
//  Network.swift
//  Hoppy
//
//  Created by Kelly Huberty on 12/16/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

import Foundation

import Alamofire
import os
class Network {

    ///needed vars
    private let session = Alamofire.SessionManager.default
    private static let log = OSLog(subsystem:"com.kellyhuberty.Hoppy", category:"network")
    
    ///URL constants
    struct URLS{
        static let base = URL(string:"https://sandbox-api.brewerydb.com/v2/")!
        static let search = URLS.base.appendingPathComponent("search")
        static let beers = URLS.base.appendingPathComponent("beers")
    }
    
    ///requests the list of beers with the given query string.
    public func requestBeerSearch(query:String?, completion:@escaping ((NetworkResult<[Beer]>) -> Void) ) -> NetworkToken{
        
        var params = defaultParams()
        
        if let query = query {
            params["q"] = query
        }

        params["withBreweries"] = "Y"
        params["type"] = "beer"

        return makeTypedRequest(type: BreweryDBResponse<[Beer]>.self, url: URLS.search, params: params, success: { (response) in
            
            let data = response.data ?? []
            
            let result = NetworkResult.success(response: data)
            
            completion(result)
            
        }) { (error) in
            
            completion(.failure(error:error))
            
        }
        

    }
    
    
    ///requests additional beer data given a Beer's Identifier.
    public func requestFullBeer(_ identifier:String, completion:@escaping ((NetworkResult<Beer>) -> Void) ) -> NetworkToken{
        
        var params = defaultParams()
        
        params["beerId"] = identifier
        params["withBreweries"] = "Y"
        params["hasLabels"] = "Y"
        params["withIngredients"] = "Y"
        params["withSocialAccounts"] = "Y"

        return makeTypedRequest(type: BreweryDBResponse<Beer>.self, url: URLS.beers, params: params, success: { (response) in
            
            guard let data = response.data else{
                completion(.failure(error:.unknown))
                return
            }
            
            let result = NetworkResult.success(response: data)
            
            completion(result)
            
        }) { (error) in
            
            completion(.failure(error:error))
        }
        
    }

    /**
     Requests a codable model from a restful/ json backend with the given type using a GET request.
     
     - parameter type : The type of the codable model to parse out
     - parameter url : The url with the host/path to retrieve data
     - parameter params : Query parameters appended to the URL
     - parameter success : Success block that returns the Codable Model requested
     - parameter failure : Failure block that returns the NetworkError encounterd.
     */
    private func makeTypedRequest<ResponseType>(type:ResponseType.Type,
                                                url:URL,
                                                params:Parameters,
                                                success:@escaping ((ResponseType)->Void),
                                                failure:@escaping ((NetworkError)->Void)
        ) -> DataRequest where ResponseType : Decodable {
        
        let task = session.request(url, method: .get, parameters: params).responseJSON { [weak self] (response) in
            
            guard response.result.error == nil else{
                self?.callAndLogFail(failure, error:.networkError(underlyingError: response.result.error!))
                return
            }
            
            guard let data = response.data else{
                self?.callAndLogFail(failure, error:.noData)
                return
            }
            
            self?.debugLogData(data)
            
            let decoder = JSONDecoder()
            var rawParsedResponse:ResponseType?
            
            do{
                rawParsedResponse = try decoder.decode(ResponseType.self, from: data)
            } catch let error{
                self?.callAndLogFail(failure, error: .parseError(underlyingError: error))
                return
            }

            guard let parsedResponse = rawParsedResponse else{
                self?.callAndLogFail(failure, error: .unknown)
                return
            }
            
            success(parsedResponse)
            
        }
        
        return task
        
    }
    
    ///log method
    private func callAndLogFail(_ failBlock:((NetworkError)->Void), error:NetworkError){

        let message = "Network error \(error)"
         
        os_log("%@", log:Network.log, type:.debug, message)
        
        failBlock(error)
    }
    
    ///logs JSON data to the console in debug mode.
    private func debugLogData(_ data:Data){
        
        guard let message = String(data: data, encoding: .utf8) else {
            return
        }
            
        os_log("%@", log:Network.log, type:.debug, message)
    }
    
    /// the params required for every single request.
    private func defaultParams() -> Parameters{
        return ["key":"af23b14b55d7941eaeaf337b7df267a2"]
    }
    
    
}

/**
 A concrete error returned from the Network.
 */
enum NetworkError : LocalizedError {
    case parseError(underlyingError:Error)
    case networkError(underlyingError:Error)
    case noData
    case serviceFailure
    case unknown
    
    
}

/**
 The generic response from the network layer of a given request.
 */
enum NetworkResult<ResponseType> {
    case success(response:ResponseType)
    case failure(error:NetworkError)
}

/**
 Object that represents a pending network request and provides an interface to
 cancel it.
 */
protocol NetworkToken {
    
    func cancel()
    
}

extension DataRequest : NetworkToken{
    
}

/**
 Object that represents a pending network request and provides an interface to
 cancel it.
 */
class BreweryDBResponse<ResponseType> : Codable where ResponseType : Codable {
    
    enum Status: String, Codable {
        case success = "success"
        case failure = "failure"
    }
    
    let errorMessage:String?
    let status:Status
    let currentPage:Int?
    let numberOfPages:Int?
    let data:ResponseType?
}
