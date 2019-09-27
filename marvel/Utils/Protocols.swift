//
//  Protocols.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-05.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import Foundation

protocol LoginViewDelegate {
    func handleLogin(for view: LoginView)
    func handleSignup(for view: LoginView)
}

protocol SignupViewDelegate {
    func handleSignup(for view: SignupView)
    func handleSignin(for view: SignupView)
    func handleSelectPhoto(for view: SignupView)
}

protocol ProfileCellDelegate {
    func handleFollowTapped(for cell: ProfileHeaderCell)
    func handleFollowersTapped(for cell: ProfileHeaderCell)
    func handleFollowingTapped(for cell: ProfileHeaderCell)
}

protocol FeedCellDelegate {
    func handleImageOrUsernameTapped(for cell: FeedCell)
    func handleOptionsTapped(for cell: FeedCell)
    func handleLikeTapped(for cell: FeedCell)
    func handleCommentsTapped(for cell: FeedCell)
}
