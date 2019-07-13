//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Ahmed Aboelela on 7/12/19.
//  Copyright © 2019 Ahmed Aboelela. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchInterestingPhotos { (photoResult) in
            switch photoResult{
            case let .success(photos):
                print("Successfully fetches photos \(photos)")
                if let firstPhoto = photos.first{
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("An error occured \(error)")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func updateImageView(for photo: Photo){
        store.fetchImage(for: photo) { (imageResult) in
            switch imageResult{
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error downloading image \(error)")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
