//
//  ProfileCellModel.swift
//  AssesmentProfileModule
//
//  Created by Govindharaj Murugan on 23/01/21.
//

import Foundation

class ProfileCellViewModel {
    
    let userName: String?
    let id: Int?
    let imageUrl: String?
    
    init(userName: String, id: Int, imageUrl:String) {
        self.userName = userName
        self.id = id
        self.imageUrl = imageUrl
    }
}
