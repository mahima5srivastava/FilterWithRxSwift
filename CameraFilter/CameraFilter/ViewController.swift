//
//  ViewController.swift
//  CameraFilter
//
//  Created by MAHIMA on 18/07/20.
//  Copyright © 2020 MAHIMA. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var filterButton: UIButton!
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    
    //MARK:- Overridden Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVc = segue.destination as? UINavigationController,
            let photoVc = navVc.viewControllers.first as? PhotosCollectionViewController {
            photoVc.selectedPhoto.subscribe (onNext: {[weak self] photo in
                DispatchQueue.main.async {
                    self?.updateUI(with: photo)
                }
                }).disposed(by: disposeBag)
        }
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.filterButton.isHidden = false
    }
    
    @IBAction func filterAction(_ sender: Any) {
        guard let sourceImage = self.photoImageView.image else {return}
        FilterService().applyFilter(to: sourceImage) {[weak self] image in
            DispatchQueue.main.async {
                self?.photoImageView.image = image
            }
            
        }
 
    }
}

