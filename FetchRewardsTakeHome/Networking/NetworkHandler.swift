//
//  NetworkLoader.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/3/23.
//

import Foundation
import UIKit

struct NetworkHandler {

    var session: URLSession

    init(session: URLSession = URLSession.shared){
        self.session = session
    }

    func makeAPICall<T:Codable>(with url: URL, completion: @escaping ((T?, Error?) -> Void)){

        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil
            else {
                completion(nil, error)
                //Future scope: Implement a error handler class for platform wide errors
                return
            }
            if let data = data {
                do{
//                    print(response)
                    let responseObject = try JSONDecoder().decode(T.self, from: data)
                    completion(responseObject, nil)
                    //TODO: dispatch on main queue

                }
                catch let jsonError as NSError{
                    //Future scope: Implement a error handler class for platform wide errors
                    completion(data as? T, jsonError)
                }
            }
            else{ //data = nil
                completion(nil, error)
                //Future scope: Implement a error handler class for platform wide errors
            }
        }
        task.resume()
    }

    func makeAPICall<T:Codable>(with url: String, completion: @escaping ((T?, Error?) -> Void)){
        makeAPICall(with: URL(string: url)!, completion: completion)
    }

    //future scope: to make a robust solution for handling multiple endpoints
    func makeAPICall<T:Codable>(with url: URLType, completion: @escaping ((T?, Error?) -> Void)){
        makeAPICall(with: URL(string: url.rawValue)!, completion: completion)
    }

}
