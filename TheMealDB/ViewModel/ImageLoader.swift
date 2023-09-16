//
//  ViewModelDependency.swift
//  TheMealDB
//
//  Created by Vibhanshu Jain on 8/14/23.
//

import Foundation
import UIKit


protocol ImageService {
    func getImage(forUrl url: String, completion: @escaping (UIImage) -> Void)
}

class ImageLoader: ImageService {

    private let networkHandler: NetworkService

    init(networkService service: NetworkService = NetworkHandler()){
        self.networkHandler = service
    }

    func getImage(forUrl url: String, completion: @escaping (UIImage) -> Void) {

        networkHandler.makeAPICall(with: APIEndpoints.custom(url)) { (response:Data?, error) in
            if let image = UIImage(data: response!) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            else {
                completion(Utilities.getDefaultImage())
            }
        }
    }

}
