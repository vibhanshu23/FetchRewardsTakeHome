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

    func getImageFor(url: String, completion: @escaping ((UIImage) -> Void)) {

        makeAPICall(with: url) { (response:Data?, error) in
            if let image = UIImage(data: response!) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            else {
                completion(Utilities.getDefaultImage())
            }
        }

                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: URL(string: url)!) { //TODO: error handling of invalid URL
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                completion(image)
                            }
                        }
                    }
                }

    }
}
