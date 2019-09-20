//
//  SelectPhotoHeaderCell.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-09-19.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

class SelectPhotoHeaderCell: UICollectionViewCell {
    
    static let cellId = "selectPhotoHeaderCellId"
    
    lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .lightGray
        
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
