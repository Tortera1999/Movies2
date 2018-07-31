//
//  DataService2.swift
//  Movies2
//
//  Created by Nikhil Iyer on 7/31/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftyUUID
import Firebase
let DB_BASE2 = Database.database().reference()

class DataService2{
    static let instance = DataService2()
    var REF_BASE2 = DB_BASE2
    
    func writeAGroupToFirebase(publicOrNot: Bool, passwordForPrivate: String, name: String, groupInfo: String){
        
        if(publicOrNot){
            let values = ["name" : name, "groupInfo" : groupInfo] as [String: Any]
            self.REF_BASE2.child("Groups").child("Public").child(name).child("Info").setValue(values)
            self.REF_BASE2.child("Groups").child("Public").child(name).child("Members").child((Auth.auth().currentUser?.uid)!)
        } else{
            let ID = SwiftyUUID.UUID()
            let idString = ID.CanonicalString()
            let values = ["name" : name, "groupInfo" : groupInfo, "password" : passwordForPrivate, "id" : idString] as [String: Any]
            self.REF_BASE2.child("Groups").child("Private").child(idString).child("Info").setValue(values)
        self.REF_BASE2.child("Groups").child("Private").child(idString).child("Members").child((Auth.auth().currentUser?.uid)!)
            self.REF_BASE2.child("Users").child((Auth.auth().currentUser?.uid)!).child("Groups").child(idString).setValue(values)
        }
    }
    
    func writeMessageToGroup(publicOrNot: Bool, name: String, message : String, idIfPrivate: String){
        let ID = SwiftyUUID.UUID()
        let idString = ID.CanonicalString()
        let messageArr = ["message" : message, "sender" : (Auth.auth().currentUser?.uid)!, "time" : "11:00am"] as [String: Any]
        if(publicOrNot){
            self.REF_BASE2.child("Groups").child("Public").child(name).child("Messages").child(idString).setValue(messageArr)
            self.REF_BASE2.child("Groups").child("Public").child(name).child("Members").child((Auth.auth().currentUser?.uid)!)
        } else{
        self.REF_BASE2.child("Groups").child("Private").child(idIfPrivate).child("Messages").child(idString).setValue(messageArr)
        self.REF_BASE2.child("Groups").child("Private").child(idIfPrivate).child("Members").child((Auth.auth().currentUser?.uid)!)
        }
    }
    
    func addMemberToPrivateGroup(personuid: String, nameOfThePerson: String, groupId: String, groupName: String, groupPassword: String, groupInfo: String){
        let values = ["name" : groupName, "groupInfo" : groupInfo, "password" : groupPassword, "id" : groupId] as [String: Any]
        self.REF_BASE2.child("Groups").child("Private").child(groupId).child("Members").child(personuid)
        self.REF_BASE2.child("Users").child(personuid).child("Groups").child(groupId).setValue(values)
    }
    
    func getAllPublicGroups(handler: @escaping (_ nameOfTheGroup: [String])->()){
        var nameOfTheGroup: [String] = []
        REF_BASE2.child("Groups").child("Public").observe(.value) { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects  as? [DataSnapshot] else { return }
            
            for snap in snapshot{
                    guard let innerSnapshot = snap.childSnapshot(forPath: "Info").children.allObjects as? [DataSnapshot] else { return }
                
                    for item in innerSnapshot{
                        nameOfTheGroup.append(item.childSnapshot(forPath: "name").value as! String)
                    }
            }
            
            handler(nameOfTheGroup)
        }
    }
    
    func getAllUserPrivateGroups(handler: @escaping (_ nameOfTheGroup: [String], _ nameOfTheGroupID: [String])->()){
        REF_BASE2.child("Users").child((Auth.auth().currentUser?.uid)!).child("Groups").observe(.value, with:
            { (snapshot) in
                guard let value = snapshot.value as? NSDictionary else { return }
                var nameOfTheGroup: [String] = []
                var nameOfTheGroupID: [String] = []
                for (id, obj) in value {
                    let nameId = id as! String
                    let dictVals = obj as! [String: Any]
                    let name = dictVals["name"] as! String
                    nameOfTheGroup.append(name)
                    nameOfTheGroupID.append(nameId)
                }
                handler(nameOfTheGroup, nameOfTheGroupID)
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getMessagesForASpecificGroup(publicOrNot: Bool, name: String, idIfPrivate: String, handler: @escaping (_ messages: [Message])->()){
        
        if(publicOrNot){
            REF_BASE2.child("Groups").child("Public").child(name).child("Messages").observe(.value, with:
                { (snapshot) in
                    guard let value = snapshot.value as? NSDictionary else { return }
                    var messageArray: [Message] = []
                    for (id, obj) in value {
                        let messageId = id as! String
                        let dictVals = obj as! [String: Any]
                        let message = Message(message: dictVals["message"] as! String, time: dictVals["time"] as! String, sender: dictVals["sender"] as! String, id: messageId)
                        messageArray.append(message)
                    }
                    handler(messageArray)
                    
            })
            { (error) in
                print(error.localizedDescription)
            }
        } else{
            REF_BASE2.child("Groups").child("Private").child(idIfPrivate).child("Messages").observe(.value, with:
                { (snapshot) in
                    guard let value = snapshot.value as? NSDictionary else { return }
                    var messageArray: [Message] = []
                    for (id, obj) in value {
                        let messageId = id as! String
                        let dictVals = obj as! [String: Any]
                        let message = Message(message: dictVals["message"] as! String, time: dictVals["time"] as! String, sender: dictVals["sender"] as! String, id: messageId)
                        messageArray.append(message)
                    }
                    handler(messageArray)
            })
            { (error) in
                print(error.localizedDescription)
            }
        }
    }
}
