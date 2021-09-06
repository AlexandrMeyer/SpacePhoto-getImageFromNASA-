//
//  ViewController.swift
//  SpacePhoto2
//
//  Created by Александр on 1.07.21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    
    let photoInfoController = PhotoInfoController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.title = ""
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        
        photoInfoController.fetchPotoInfo { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let photoInfo):
                    self.updateUI(with: photoInfo)
                case .failure(let error):
                    self.updateUI(with: error)
                }
            }
        }
    }
    
    func updateUI(with photoInfo: PhotoInfo) {
        photoInfoController.fetchImage(from: photoInfo.url) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.title = photoInfo.title
                    self.descriptionLabel.text = photoInfo.description
                    self.copyrightLabel.text = photoInfo.copyright
                    self.imageView.image = image
                case .failure(let error):
                    self.updateUI(with: error)
                }
            }
        }
    }
    
    func updateUI(with error: Error) {
        self.title = "Error Fetching Photo"
        self.imageView.image = UIImage(systemName: "exclamationmark.octagon")
        self.descriptionLabel.text = error.localizedDescription
        self.copyrightLabel.text = ""
    }
    
}

