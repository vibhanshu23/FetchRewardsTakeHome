//
//  NetworkLoader.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/3/23.
//

import Foundation

struct NetworkHandler {

    static func makeAPICall<T:Codable>(with url: URL, completion: @escaping ((T?, Error?) -> Void)){

        //TODO: Generics or no
        let session = URLSession.shared

        let task = session.dataTask(with: url) { data, response, error in
            //TODO: Consider checking data, response, and error if valid network response is recevied instead of force unwrapping the data
            guard error == nil
            else {
                completion(nil, error)
                //Future scope: Implement a error handler class for platform wide errors
                return
            }
            if let data = data {
                do{
//                TODO: check errors, check data

                    let responseObject = try JSONDecoder().decode(T.self, from: data)
                    completion(responseObject, nil)
                    //TODO: dispatch on main queue

                }
                catch let jsonError as NSError{
                    completion(nil, jsonError)
                }
            }
            else{ //data = nil
                completion(nil, error)
                //Future scope: Implement a error handler class for platform wide errors
            }
        }
        task.resume()
    }
}
