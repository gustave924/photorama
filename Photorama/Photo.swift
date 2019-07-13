//
//  Photo.swift
//  Photorama
//
//  Created by Ahmed Aboelela on 7/12/19.
//  Copyright © 2019 Ahmed Aboelela. All rights reserved.
//

import Foundation

class Photo{
    let title: String
    let remoteURL: URL
    let photoId: String
    let dateTaken: Date
    
    init(title:String, remoteURL: URL, photoId: String, dateTaken: Date) {
        self.title = title
        self.remoteURL = remoteURL
        self.photoId = photoId
        self.dateTaken = dateTaken
    }
}
