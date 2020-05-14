//
//  Network.swift
//  CatTest
//
//  Created by kam_team on 14.05.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import Foundation
import Alamofire

public let token = "88e797be-6760-4562-bac4-be20aa3338fc"

class CatService{
    
    static func getRandomURLImages(limitImages: Int?, completionHandler: @escaping (Bool, Array<String>?)->Void){
        let param: [String:String] = [ "limit" : "\(limitImages ?? 1)"]
        let url = "https://api.thecatapi.com/v1/images/search?"
        let headers = HTTPHeaders([HTTPHeader(name: "x-api-key", value: token)])
        var arrayURL = Array<String>()
        AF.request(url, method: .get, parameters: param, headers: headers).validate(contentType: ["application/json","charset=utf-8"]).responseJSON{ (response) in
            switch response.result{
                
            case .failure(let error):
                print("getRandomURLImages -> Error:", error)
                completionHandler(false, nil)
                return
                
            case .success(let data):
                guard let dataF = data as? Array<Dictionary<String,Any>> else {
                    completionHandler(false, nil)
                    return
                }
                for catData in dataF{
                    if let urlCat = catData["url"] as? String{
                        arrayURL.append(urlCat)
                    }
                }
                completionHandler(true, arrayURL)
                return
            }
        }
    }
    
    static func getUIImageCat(_ url: String, completionHandler: @escaping (Bool, UIImage?)->Void){
        AF.request(url).responseData { (data) in
            guard let dataImage = data.data else{
                completionHandler(false, nil)
                return
            }
            guard let imageCat = UIImage(data: dataImage) else{
                completionHandler(false, nil)
                return
            }
            completionHandler(true, imageCat)
            return
        }
    }
}
