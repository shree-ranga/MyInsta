//
//  Constants.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-07-03.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import Foundation

//let BASE_URL = "http://192.168.0.12:8000"

let BASE_URL = "http://127.0.0.1:8000"

// TODO: - Password reset and change
let AUTH_URL = ACCOUNTS_URL + "auth/"
let LOGIN_URL = AUTH_URL + "login/"
let LOGOUT_URL = AUTH_URL + "logout/"
let REGISTER_URL = AUTH_URL + "register/"

let ACCOUNTS_URL = BASE_URL + "/accounts/"
let USERS_URL = ACCOUNTS_URL + "users/"

let FOLLOW_UNFOLLOW_URL = USERS_URL + "follow-unfollow/"
let CHECK_FOLLOW_URL = USERS_URL + "check-follow/"
