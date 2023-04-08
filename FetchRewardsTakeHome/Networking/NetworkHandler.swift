//
//  NetworkLoader.swift
//  FetchRewardsTakeHome
//
//  Created by Vibhanshu Jain on 4/3/23.
//
//  This class contains all the networking logic

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
                DispatchQueue.main.async {
                    print("*********** ERROR ***********")
                    print(error?.localizedDescription)
                    completion(nil, error)
                }
                //Future scope: Implement a error handler class for platform wide errors
                return
            }
            if let data = data {
                do{
//                    print(response)
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])

                    let responseObject = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
                catch let jsonError as NSError{
                    //Future scope: Implement a error handler class for platform wide errors
                    DispatchQueue.main.async {
                        print("*********** ERROR ***********")
                        print(jsonError.localizedDescription)
                        completion(data as? T, jsonError)
                    }
                }
            }
            else{ //data = nil
                DispatchQueue.main.async {
                    print("*********** ERROR ***********")
                    print(error?.localizedDescription)
                    completion(nil, error)
                }
                //Future scope: Implement a error handler class for platform wide errors
            }
        }
        task.resume()
    }

    func makeAPICall<T:Codable>(with url: String, completion: @escaping ((T?, Error?) -> Void)){
        makeAPICall(with: URL(string: url)!, completion: completion)
    }

    //Used for testing
    func makeAPICall<T:Codable>(with url: test_APIEndpoints, completion: @escaping ((T?, Error?) -> Void)){
        makeAPICall(with: URL(string: url.rawValue)!, completion: completion)
    }

}
