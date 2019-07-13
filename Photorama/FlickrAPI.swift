//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Ahmed Aboelela on 7/12/19.
//  Copyright © 2019 Ahmed Aboelela. All rights reserved.
//

import Foundation

enum Method: String{
    case interstingPhotos = "flickr.interestingness.getList"
}

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "92715dd8a1b900ad6a76d3da9e0b93b0"
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static func flickrURL(method: Method, parameters: [String:String]?) -> URL{
        
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format":"json",
            "nojsoncallback":"1",
            "api_key":apiKey
        ]
        
        for (key, value) in baseParams{
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters{
            for (key, value) in additionalParams{
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    
    static func photos(fromJSON data: Data) -> PhotoResult{
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDictionary = jsonObject as? [AnyHashable: Any],
                let photos = jsonDictionary["photos"] as? [String: Any],
                let photosArray = photos["photo"] as? [[String: Any]] else{
                    return .failure(NSError(domain: "Invalid Json data", code: 10, userInfo:nil))
            }
            
            var finalPhotos = [Photo]()
            for jsonPhoto in photosArray{
                if let photo = photo(fromJSON: jsonPhoto){
                    finalPhotos.append(photo)
                }
            }
            if(finalPhotos.isEmpty && !photosArray.isEmpty){
                return .failure(NSError(domain: "Invalid Json data", code: 10, userInfo:nil))
            }
            return .success(finalPhotos)
        }catch let error{
            return .failure(error)
        }
    }

    
    static var interestingPhotosURL: URL{
        return flickrURL(method: .interstingPhotos, parameters: ["extras":"url_h,date_taken"])
    }
    
    private static func photo(fromJSON json: [String:Any]) ->  Photo?{
        guard let photoId = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString) else{
                return nil
        }
        return Photo(title: title, remoteURL: url, photoId: photoId, dateTaken: dateTaken)
    }
}
