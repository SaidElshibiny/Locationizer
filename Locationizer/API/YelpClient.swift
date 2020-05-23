//
//  YelpClient.swift
//  Locationizer
//
//  Created by Said Elshibiny on 2018-11-17.
//  Copyright © 2018 Said. All rights reserved.

/************************************Code required for Yelp API to work********************/
/*
 The Yelp Client allows to search items with different filters
 I have impelemented the search with term and the need to provide the device location
 To show the nearby businesses
 */

import UIKit
import AFNetworking
import BDBOAuth1Manager
import YelpAPI
import CoreLocation

// Registered for Yelp API key here: https://www.yelp.com/developers/v3/manage_app
let yelpAPIKey = "hGcY1bgpc4UFZutObquJLiUx3KxwTk-flqDBo0TxCSPV0jDIMgp_2iS-oJBX-fyGmyhWcBjQMizAqTZiEvfKTRbn9bOYIxi-0tfK_fyN2du9HVSJZpAaP2djJX3wW3Yx"

enum YelpSortMode: String {
    case best_match, rating, review_count, distance
}

class YelpClient: AFHTTPRequestOperationManager, CLLocationManagerDelegate{
    var apiKey: String!
    
    //MARK: Shared Instance
    
    static let sharedInstance = YelpClient(yelpAPIKey: yelpAPIKey)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Initialize with API key
    init(yelpAPIKey: String) {
        self.apiKey = yelpAPIKey
        
        let baseUrl = URL(string: "https://api.yelp.com/v3/")
        super.init(baseURL: baseUrl)
        requestSerializer.setValue("Bearer \(self.apiKey!)", forHTTPHeaderField: "Authorization")
    }
    
    //Search function with term and location required
    func searchWithTerm(_ term: String, location: String, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(term, sort: nil, categories: nil, openNow: nil, location: location, completion: completion)
    }
    
    //Search function with term and location required
    func searchWithTerm(_ term: String, sort: YelpSortMode?, categories: [String]?, openNow: Bool?, location: String, completion: @escaping ([Business]?, Error?) -> Void) -> AFHTTPRequestOperation {
        
        //Parameters for the search
        
        // Test location - San Francisco ("37.785771,-122.406165")
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "location": location as AnyObject]
        
        if sort != nil {
            parameters["sort_by"] = sort!.rawValue as AnyObject?
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["categories"] = (categories!).joined(separator: ",") as AnyObject?
        }
        
        if openNow != nil {
            parameters["open_now"] = openNow! as AnyObject
        }
        
        //show the parameters in console
        print(parameters)
        
        //return search with parameters
        return self.get("businesses/search", parameters: parameters,
                        success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
                            if let response = response as? [String: Any]{
                                let dictionaries = response["businesses"] as? [NSDictionary]
                                if dictionaries != nil {
                                    completion(Business.businesses(array: dictionaries!), nil)
                                }
                            }
        },
                        failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
                            completion(nil, error)
        })!
    }
}
