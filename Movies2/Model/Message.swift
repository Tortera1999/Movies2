//
//  Message.swift
//  Movies2
//
//  Created by Nikhil Iyer on 7/31/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import Foundation
import UIKit

class Message{
    var message: String?
    var time: String?
    var sender: String?
    var id: String?
    
    init(message: String, time: String, sender: String, id: String){
        self.message = message
        self.time = time
        self.sender = sender
        self.id = id
    }
}
