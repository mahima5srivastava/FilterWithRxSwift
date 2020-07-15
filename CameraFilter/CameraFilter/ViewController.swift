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
                self?.photoImageView.image = photo
                }).disposed(by: disposeBag)
        }
    }
}

