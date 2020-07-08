//
//  PhotosCollectionViewController.swift
//  CameraFilter
//
//  Created by MAHIMA on 11/07/20.
//  Copyright © 2020 MAHIMA. All rights reserved.
//

import UIKit
import Photos
import RxSwift

private let reuseIdentifier = "Cell"

class PhotosCollectionViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var images = [PHAsset]()
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    
    //MARK: -IBoutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        populatePhotos()
    }
    
    //MARK: - Private methods
    
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization {[weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
            }
            self?.images.reverse()
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
            
        }
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {return UICollectionViewCell()}
        let asset = self.images[indexPath.item]
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 300,height: 300), contentMode: .aspectFit, options: .none, resultHandler: { image, _ in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        })
        return cell
    }


    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.images[indexPath.item]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300.0), contentMode: .aspectFit, options: nil) {[weak self] (image, info) in
            guard let info = info,
                let isDegradedImage = info["PHImageResultIsDegradedKey"] as? Bool, !isDegradedImage,
                let image = image else {return}
            self?.selectedPhotoSubject.onNext(image)
            self?.dismiss(animated: true , completion: nil)
            
        }
    }

}
