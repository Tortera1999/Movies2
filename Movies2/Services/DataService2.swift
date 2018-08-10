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
    
    var messages: [Message] = []
    
    var REF_BASE2 = DB_BASE2
    
    func writeAGroupToFirebase(publicOrNot: Bool, passwordForPrivate: String, name: String, groupInfo: String){
        
        if(publicOrNot){
            let values = ["name" : name, "groupInfo" : groupInfo] as [String: Any]
            self.REF_BASE2.child("Groups").child("Public").child(name).child("Info").setValue(values)
            self.REF_BASE2.child("Groups").child("Public").child(name).child("Members").child((Auth.auth().currentUser?.uid)!)
            self.REF_BASE2.child("Users").child((Auth.auth().currentUser?.uid)!).child("Groups").child("Public").child(name).child("Info").setValue(values)
        } else{
            let ID = SwiftyUUID.UUID()
            let idString = ID.CanonicalString()
            let values = ["name" : name, "groupInfo" : groupInfo, "password" : passwordForPrivate, "id" : idString] as [String: Any]
            self.REF_BASE2.child("Groups").child("Private").child(idString).child("Info").setValue(values)
        self.REF_BASE2.child("Groups").child("Private").child(idString).child("Members").child((Auth.auth().currentUser?.uid)!).setValue((Auth.auth().currentUser?.email)!)
            self.REF_BASE2.child("Users").child((Auth.auth().currentUser?.uid)!).child("Groups").child("Private").child(idString).child("Info").setValue(values)
        }
    }
    
    func writeMessageToGroup(publicOrNot: Bool, name: String, message : String, idIfPrivate: String){
        let ID = SwiftyUUID.UUID()
        let idString = ID.CanonicalString()
        
        let timestamp = Int(Date().timeIntervalSince1970)
       
        let messageArr = ["message" : message, "sender" : (Auth.auth().currentUser?.uid)!, "time" : timestamp, "favoriteCount" : "0"] as [String: Any]
        if(publicOrNot){
            self.REF_BASE2.child("Groups").child("Public").child(name).child("Messages").child(idString).setValue(messageArr)
            self.REF_BASE2.child("Groups").child("Public").child(name).child("Members").child((Auth.auth().currentUser?.uid)!)
        } else{
        self.REF_BASE2.child("Groups").child("Private").child(idIfPrivate).child("Messages").child(idString).setValue(messageArr)
        self.REF_BASE2.child("Groups").child("Private").child(idIfPrivate).child("Members").child((Auth.auth().currentUser?.uid)!)
        }
    }
    
    func upvoteOrDownvoteNow(upvoteOrDownvote: Bool, publicOrNot: Bool, name: String, idIfPrivate: String, messageIn: Message){
        
        if(publicOrNot){
            self.REF_BASE2.child("Groups").child("Public").child(name).child("Messages").child(messageIn.id!).child("favoriteCount").setValue(messageIn.favoriteCount!)
        } else{
        self.REF_BASE2.child("Groups").child("Private").child(idIfPrivate).child("Messages").child(messageIn.id!).child("favoriteCount").setValue(messageIn.favoriteCount!)
        }
        
        if(upvoteOrDownvote){
            self.REF_BASE2.child("Users").child((Auth.auth().currentUser?.uid)!).child("Upvotes").child(messageIn.id!).setValue(messageIn.sender!)
        } else{
            self.REF_BASE2.child("Users").child((Auth.auth().currentUser?.uid)!).child("Downvotes").child(messageIn.id!).setValue(messageIn.sender!)
        }
            
    }
    
    func addMemberToPrivateGroup(personuid: [String], nameOfThePerson: [String], groupId: String, groupName: String, groupPassword: String, groupInfo: String){
        let values = ["name" : groupName, "groupInfo" : groupInfo, "password" : groupPassword, "id" : groupId] as [String: Any]
        for personId in personuid{
            self.REF_BASE2.child("Users").child(personId).child("Info").child("email").observe(.value, with: { (snapshot) in
                
                if let value = snapshot.value as? String{
                    self.REF_BASE2.child("Groups").child("Private").child(groupId).child("Members").child(personId).setValue(value)
                    self.REF_BASE2.child("Users").child(personId).child("Groups").child("Private").child(groupId).child("Info").setValue(values)
                }
            })
            
        }
    }
    
    func subscribeToPublicGroup(group: Group){
        let values = ["name" : group.groupName!, "groupInfo" : group.groupInfo!] as [String: Any]
        self.REF_BASE2.child("Users").child((Auth.auth().currentUser?.uid)!).child("Groups").child("Public").child(group.groupName!).child("Info").setValue(values)
    }
    
    func getAllUserSubscribedPublicGroups(handler: @escaping (_ publicGroupsArr: [Group])->()){
        var publicGroupsArr : [Group] = []
        REF_BASE2.child("Users").child((Auth.auth().currentUser?.uid)!).child("Groups").child("Public").observe(.value) { (snapshot) in

            guard let snapshot = snapshot.children.allObjects  as? [DataSnapshot] else { return }

            print("getAllUserSubscribedPublicGroups:")
            print(snapshot)
            for snap in snapshot{
                guard let innerSnapshot = snap.childSnapshot(forPath: "Info").childSnapshot(forPath: "name").value as? String else{ return }
                guard let innerSnapshot2 = snap.childSnapshot(forPath: "Info").childSnapshot(forPath: "groupInfo").value as? String else{ return }


                let group = Group(groupName: innerSnapshot, groupId: "", groupInfo: innerSnapshot2, publicOrNot: true)

                publicGroupsArr.append(group)
            }

            handler(publicGroupsArr)
            publicGroupsArr = []
        }
        
    }
    
    func getAllPublicGroups(handler: @escaping (_ publicGroupsArr: [Group])->()){
        var publicGroupsArr : [Group] = []
        REF_BASE2.child("Groups").child("Public").observe(.value) { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects  as? [DataSnapshot] else { return }
            
            for snap in snapshot{
                guard let innerSnapshot = snap.childSnapshot(forPath: "Info").childSnapshot(forPath: "name").value as? String else{ return }
                guard let innerSnapshot2 = snap.childSnapshot(forPath: "Info").childSnapshot(forPath: "groupInfo").value as? String else{ return }
                
                let group = Group(groupName: innerSnapshot, groupId: "", groupInfo: innerSnapshot2, publicOrNot: true)
                
                publicGroupsArr.append(group)
            }
            
            handler(publicGroupsArr)
            publicGroupsArr = []
        }
    }
    
    func getAllUserPrivateGroups(handler: @escaping (_ privateGroupsArr: [Group])->()){
        var privateGroupsArr : [Group] = []
        REF_BASE2.child("Users").child((Auth.auth().currentUser?.uid)!).child("Groups").child("Private").observe(.value) { (snapshot) in
            
            guard let snapshot = snapshot.children.allObjects  as? [DataSnapshot] else { return }
            
            print("getAllUserSubscribedPublicGroups:")
            print(snapshot)
            for snap in snapshot{
                guard let innerSnapshot = snap.childSnapshot(forPath: "Info").childSnapshot(forPath: "name").value as? String else{ return }
                guard let innerSnapshot2 = snap.childSnapshot(forPath: "Info").childSnapshot(forPath: "groupInfo").value as? String else{ return }
                guard let innerSnapshot3 = snap.childSnapshot(forPath: "Info").childSnapshot(forPath: "id").value as? String else{ return }
                
                let group = Group(groupName: innerSnapshot, groupId: innerSnapshot3, groupInfo: innerSnapshot2, publicOrNot: false)
                
                privateGroupsArr.append(group)
            }
            
            handler(privateGroupsArr)
            privateGroupsArr = []
        }
    }
    
    
    
    func checkIfMessageHasBeenUpvoted(messageId: String, handler: @escaping (_ upvoted: Bool)->()){
        
        REF_BASE2.child("Users").child((Auth.auth().currentUser?.uid)!).child("Upvotes").observe(.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects  as? [DataSnapshot] else { return }
            
            for snap in snapshot{
                if(snap.key == messageId){
                    print("HEERREE U")
                    // This if statement runs, and HEERREE U prints out.. which means it is recognizing the message has been downvoted, but the handler is sent after the message object is created, which is of no use
                    handler(true)
                }
            }
            handler(false)
        }
        
    }
    
    func checkIfMessageHasBeenDownvoted(messageId: String, handler: @escaping (_ downvoted: Bool)->()){
        
        REF_BASE2.child("Users").child((Auth.auth().currentUser?.uid)!).child("Downvotes").observe(.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects  as? [DataSnapshot] else { return }
            
            for snap in snapshot{
                if(snap.key == messageId){
                    print("HEERREE D")
                    // This if statement runs, and HEERREE D prints out.. which means it is recognizing the message has been downvoted, but the handler is sent after the message object is created, which is of no use
                    handler(true)
                }
            }
            handler(false)
        }
    }
    
    func getMessagesForASpecificGroup(publicOrNot: Bool, name: String, idIfPrivate: String, handler: @escaping (_ messages: [Message])->()){
        
        if(publicOrNot){
            REF_BASE2.child("Groups").child("Public").child(name).child("Messages").queryOrdered(byChild: "time").observe(.value, with:
                { (snapshot) in
                    guard let value = snapshot.value as? NSDictionary else { return }
                    var messageArray: [Message] = []
                    for (id, obj) in value {
                        let messageId = id as! String
                        let dictVals = obj as! [String: Any]
                        
                        var upvotedBefore = false
                        var downvotedBefore = false
                        
                        //The next two statements are not updating the above two variables:
                        
                        DataService2.instance.checkIfMessageHasBeenUpvoted(messageId: messageId, handler: { (upvote) in
                            upvotedBefore = upvote
                        })
                        
                        DataService2.instance.checkIfMessageHasBeenDownvoted(messageId: messageId, handler: { (downvote) in
                            downvotedBefore = downvote
                        })
                        
                        //end of the problem..
                        //Think it is some async problem.. tried using dispatchGroup, but didnt work.. // same for the bottom else statement..
                        
                        //false keeps printing out when true needs to be printed
                        print(upvotedBefore)
                        print(downvotedBefore)
                        let message = Message(message: dictVals["message"] as! String, time: dictVals["time"] as! Int, sender: dictVals["sender"] as! String, id: messageId, favoriteCount: dictVals["favoriteCount"] as! String, upvotedBefore: upvotedBefore, downvotedBefore: downvotedBefore)
                        messageArray.append(message)
                        
                        
                    }
                    
                    handler(messageArray)
                    messageArray = []
                    
            })
            { (error) in
                print(error.localizedDescription)
            }
        } else{
            REF_BASE2.child("Groups").child("Private").child(idIfPrivate).child("Messages").queryOrdered(byChild: "time").observe(.value, with:
                { (snapshot) in
                    guard let value = snapshot.value as? NSDictionary else { return }
                    var messageArray: [Message] = []
                    for (id, obj) in value {
                        let messageId = id as! String
                        let dictVals = obj as! [String: Any]
                        
                        var upvotedBefore = false
                        var downvotedBefore = false
                        
                        DataService2.instance.checkIfMessageHasBeenUpvoted(messageId: messageId, handler: { (upvote) in
                            upvotedBefore = upvote
                        })
                        
                        DataService2.instance.checkIfMessageHasBeenDownvoted(messageId: messageId, handler: { (downvote) in
                            downvotedBefore = downvote
                        })
                        
                        print(upvotedBefore)
                        print(downvotedBefore)
                        let message = Message(message: dictVals["message"] as! String, time: dictVals["time"] as! Int, sender: dictVals["sender"] as! String, id: messageId, favoriteCount: dictVals["favoriteCount"] as! String, upvotedBefore: upvotedBefore, downvotedBefore: downvotedBefore)
                        messageArray.append(message)
                    }
                    
                    handler(messageArray)
                    messageArray = []
            })
            { (error) in
                print(error.localizedDescription)
            }
        }
    }
}
