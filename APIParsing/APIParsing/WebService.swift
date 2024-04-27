//
//  WebService.swift
//  EnrichPassport
//
//  Created by Enrich on 30/12/19.
//  Copyright © 2019 Enrich. All rights reserved.
//

import UIKit

struct WebAPI {
    static let url = "https://jsonplaceholder.typicode.com/posts"
}

struct ResponseObject: Codable  {
    let userId : Int
    let id : Int
    let title : String
    let body : String
    
    lazy var details: [ResponseDetailObject] = []
}

struct ResponseDetailObject: Codable  {
    let postId : Int
    let id : Int
    let name : String
    let email : String
    let body : String
}

class WebService {
    
    // Singleton class shared instance
    static let sharedInstance = WebService()
    
    
    func postRequest(url: String,
                     queryString: String,
                     completionHandler: @escaping (Array<ResponseObject>,String) -> ())
    {
        let request = URLRequest(url: URL(string: "\(url)\(queryString)")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            if let error = error {
                print("Error accessing url: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            /*
            let response = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(response!)
             */
            
            do {
                
                // Decode
                let jsonDecoder = JSONDecoder()
                let responseObject = try jsonDecoder.decode([ResponseObject].self, from: data!)
                //print(responseObject.first?.title)
                completionHandler(responseObject,"")
                
                /*
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Array<AnyObject>
                print(json?.count)
                let apidata : APIData? = (json?.first as? NSDictionary)?.castToObject()
                print(apidata?.title)
                */
           
            } catch {
                print("Something went wrong. \(error.localizedDescription)")
                completionHandler([],error.localizedDescription)
            }
       })
        
        task.resume()
    }
    
    func postDetailRequest(url: String,
                     queryString: String,
                     completionHandler: @escaping (Array<ResponseDetailObject>,String) -> ())
    {
        let request = URLRequest(url: URL(string: "\(url)\(queryString)")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            if let error = error {
                print("Error accessing url: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            do {
                
                // Decode
                let jsonDecoder = JSONDecoder()
                let responseDetailObject = try jsonDecoder.decode([ResponseDetailObject].self, from: data!)
                //print(responseObject.first?.title)
                completionHandler(responseDetailObject,"")
           
            } catch {
                print("Something went wrong. \(error.localizedDescription)")
                completionHandler([],error.localizedDescription)
            }
       })
        
        task.resume()
    }
}

/*
extension NSDictionary {
    func castToObject<T: Decodable>() -> T? {
        let json = try? JSONSerialization.data(withJSONObject: self)
        return json == nil ? nil : try? JSONDecoder().decode(T.self, from: json!)
    }
}
*/

