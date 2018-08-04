//
//  Group.swift
//  Movies2
//
//  Created by Nikhil Iyer on 8/4/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import Foundation

class Group{
    var groupName: String?
    var groupId: String?
    var groupInfo: String?
    var publicOrNot: Bool?
    
    init(groupName: String, groupId: String, groupInfo: String, publicOrNot: Bool) {
        self.groupName = groupName
        self.groupId = groupId
        self.groupInfo = groupInfo
        self.publicOrNot = publicOrNot
    }
}
