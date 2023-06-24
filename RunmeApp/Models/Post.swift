//
//  Post.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 24.06.2023.
//

import Foundation

struct Post {

    let uid: String
    let author: User
    let date: Date
    let text: String = ""
    let imageName: String?
    var likes: UInt32 = 0
    
}
