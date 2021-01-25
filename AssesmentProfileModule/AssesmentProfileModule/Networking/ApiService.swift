//
//  ApiService.swift
//  Assesment
//
//  Created by Govindharaj Murugan on 10/01/21.
//

import Foundation
import UIKit
import AssesmentModels


enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

typealias WebServiceCallBack = (_ success : Bool, _ response : Any?, _ error : APIError? ) -> Void

class ApiService {
    
    init() { }
    
    // Fetch particular user details
    func fetchUserDetails(_ url: String, complete: @escaping WebServiceCallBack) {
        
        guard Reachability.isConnectedToNetwork() else {
            complete(false, UserList() as AnyObject?, .noNetwork)
            return
        }
        
        self.getAPIResponseFrom(url) { (success, response, error) in
            DispatchQueue.main.async {
                do {
                    let userDetails = try JSONDecoder().decode(User.self, from: response! as! Data)
                    complete(true, userDetails, nil)
                } catch {
                    complete(false, nil, .serverOverload)
                }
            }
        }
    }
    
    // Fetch followers of the particular user
    func fetchFollowers(_ pageIndex: Int = 0, url: String, complete: @escaping WebServiceCallBack) {

        guard Reachability.isConnectedToNetwork() else {
            complete(false, nil, .noNetwork)
            return
        }
        self.getAPIResponseFrom("\(url+"?page=\(pageIndex)")", callback: { (success, response, error) in
            DispatchQueue.main.async {
                do {
                    let arrFollow = try JSONDecoder().decode([Follow].self, from: response! as! Data)
                    complete(true, arrFollow, nil)
                } catch {
                    complete(false, nil, .serverOverload)
                }
            }
        })
    }
    
    // Fetch following user list
    func fetchFollowing(_ pageIndex: Int = 0, url: String, complete: @escaping WebServiceCallBack) {
        
        guard Reachability.isConnectedToNetwork() else {
            complete(false, nil, .noNetwork)
            return
        }
        
        self.getAPIResponseFrom("\(url + "/following?page=\(pageIndex)")", callback: { (success, response, error) in
            
            DispatchQueue.main.async {
                do {
                    let arrFollowing = try JSONDecoder().decode([Follow].self, from: response! as! Data)
                    complete(true, arrFollowing, nil)
                } catch {
                    complete(false, nil, .serverOverload)
                }
            }
        })
    }
    
    
    func getAPIResponseFrom(_ url : String, callback: @escaping WebServiceCallBack) {
        
        let urlString = URL(string: url)
        var request = URLRequest(url: urlString!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlString!) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print(error ?? "")
                    callback(false,nil, .serverOverload)
                } else {
                    callback(true, data as AnyObject, .none)
                }
            }
        }
        task.resume()
    }
}
