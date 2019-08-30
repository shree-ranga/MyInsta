//
//  GridCell.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-30.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {
    
    static let cellId = "gridCellId"
    
    lazy var postImageView: CustomImageView = {
        let iv = CustomImageView()
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
        backgroundColor = UIColor.lightGray
        
        // image anchors
        addSubview(postImageView)
        postImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        postImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        postImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        postImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
