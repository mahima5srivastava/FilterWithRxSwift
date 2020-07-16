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
    
    //MARK:- Private methods
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.filterButton.isHidden = false
    }
    
    //MARK:- IBAction
    
    @IBAction func filterAction(_ sender: Any) {
        guard let sourceImage = self.photoImageView.image else {return}
        FilterService().applyfilter(to: sourceImage).subscribe(onNext: { filteredImage in
            DispatchQueue.main.async {
                self.photoImageView.image = filteredImage
            }
        }).disposed(by: disposeBag)
    }
}

