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

    func makeAPICall<T:Codable>(with endpoint: APIEndpoints, completion: @escaping ((T?, NetworkError?) -> Void)){
        makeAPICall(with: endpoint.url, completion: completion) //FIXME: URL class
    }

    //Used for testing
    func makeAPICall<T:Codable>(with url: test_APIEndpoints, completion: @escaping ((T?, Error?) -> Void)){
        makeAPICall(with: URL(string: url.rawValue)!, completion: completion)
    }

    
    func handlePlatformErrors(with error: NetworkError?) -> NetworkError?{

        guard let errror = error else {
            return error
        }
        switch errror {
            case .connectionError:
                print("connectionError")

            case .timeoutError:
                print("timeoutError")

            case .networkError:
                print("networkError")

            case .jsonError:
                print("jsonError")
        }
        return errror

    }

//MARK: Private
    private func makeAPICall<T:Codable>(with url: URL, completion: @escaping ((T?, NetworkError?) -> Void)){

        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil
            else {
                //                print("*********** ERROR ***********")
                //                print(error?.localizedDescription)

                guard error != nil else{
                    completion(nil, handlePlatformErrors(with: .connectionError))

                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else{
                    completion(nil, handlePlatformErrors(with: .networkError))

                    return
                }

                return
            }
            guard let data = data else{

                completion(nil, handlePlatformErrors(with: .networkError))

                return
            }
            do{
                //                print(response)
                //                let responseObjectDebug = try? JSONDecoder().decode(T.self, from: data)
                //                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])

                let responseObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch let jsonError as NSError{
                //Future scope: Implement a error handler class for platform wide errors
                DispatchQueue.main.async {
//                    print("*********** ERROR ***********")
//                    print(jsonError.localizedDescription)

                    completion(data as? T, handlePlatformErrors(with: .jsonError))
                }
            }

        }
        task.resume()
    }

}

//MARK: NetworkError enum
enum NetworkError: Error {
    case connectionError
    case timeoutError
    case networkError
    case jsonError

    var errorMessage: String {
        switch self {
            case .connectionError:
                return "Some connection error occured"
            case .timeoutError:
                return "timeout occured"
            case .networkError:
                return "network error occured"
            case .jsonError:
                return "Json error occured"
        }
    }
}
