//
//  SelectImageVC.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-09-19.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit
import Photos

class SelectImageVC: UIViewController {
    
    var selectImageView: SelectImageView!
    
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configNavBar()
        configureCollectionView()
        fetchPhotos()
    }
    
    func setupViews() {
        selectImageView = SelectImageView(frame: UIScreen.main.bounds)
        view.addSubview(selectImageView)
    }
    
    func configNavBar() {
        navigationItem.title = "Camera Roll"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    func configureCollectionView() {
        selectImageView.collectionView.delegate = self
        selectImageView.collectionView.dataSource = self
        selectImageView.collectionView.register(SelectPhotoHeaderCell.self, forCellWithReuseIdentifier: SelectPhotoHeaderCell.cellId)
        selectImageView.collectionView.register(SelectPhotoCell.self, forCellWithReuseIdentifier: SelectPhotoCell.cellId)
    }
    
    func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: getPHAssetFetchOptions())
        
        // fetch images on the background thread
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects({ (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                // request image representation of a specific asset
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        // append image to the images
                        self.images.append(image)
                        
                        // append asset to assets
                        self.assets.append(asset)
                        
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                        
                        if count == allPhotos.count - 1 {
                            // reload collection view
                            DispatchQueue.main.async {
                                self.selectImageView.collectionView.reloadData()
                            }
                        }
                    }
                })
            })
        }
    }
    
    func getPHAssetFetchOptions() -> PHFetchOptions {
        let options = PHFetchOptions()
        
        // fetch all photos from the photo library
        options.fetchLimit = 0
        
        // sort photos by date
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]
        
        return options
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        print("Next tapped")
    }
}

extension SelectImageVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return images.count
    }
    
    // this method is called every time collectionview.reload()
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectPhotoHeaderCell.cellId, for: indexPath) as! SelectPhotoHeaderCell
            if let selectedImage = selectedImage {
                // get index of the selected image
                if let index = images.firstIndex(of: selectedImage) {
                    // get the asset associated with the selected image
                    let asset = assets[index]
                    
                    // image manager
                    let imageManager = PHImageManager.default()
                    let targetSize = CGSize(width: view.frame.width, height: view.frame.width)
                    
                    imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { (image, info) in
                        cell.photoImageView.image = image
                    }
                }
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectPhotoCell.cellId, for: indexPath) as! SelectPhotoCell
        cell.photoImageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: view.frame.width)
        }
        
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            selectedImage = images[indexPath.item]
            collectionView.reloadData()
            let myIndexpath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: myIndexpath, at: .bottom, animated: true)
        }
    }
}
