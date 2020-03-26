//
//  FeedData.swift
//  Snapagram
//
//  Created by Arman Vaziri on 3/8/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

// Create global instance of the feed
var feed = FeedData()

class Thread {
    var name: String
    var emoji: String
    var entries: [ThreadEntry]
    
    init(name: String, emoji: String) {
        self.name = name
        self.emoji = emoji
        self.entries = []
    }
    
    func addEntry(threadEntry: ThreadEntry) {
        entries.append(threadEntry)
    }
    
    func removeFirstEntry() -> ThreadEntry? {
        if entries.count > 0 {
            return entries.removeFirst()
        }
        return nil
    }
    
    func unreadCount() -> Int {
        return entries.count
    }
    
    
}

struct ThreadEntry {
    var username: String
    var image: UIImage
}

struct Post {
    var location: String
    var image: UIImage?
    var user: String
    var caption: String
    var date: Date
}

class FeedData {
    var username = "YOUR USERNAME"
    
    var threads: [Thread] = [
        Thread(name: "memes", emoji: "😂"),
        Thread(name: "dogs", emoji: "🐶"),
        Thread(name: "fashion", emoji: "🕶"),
        Thread(name: "fam", emoji: "👨‍👩‍👧‍👦"),
        Thread(name: "tech", emoji: "💻"),
        Thread(name: "eats", emoji: "🍱"),
    ]

    // Adds dummy posts to the Feed
    var posts: [Post] = [
        Post(location: "New York City", image: UIImage(named: "skyline"), user: "nyerasi", caption: "Concrete jungle, wet dreams tomato 🍅 —Alicia Keys", date: Date()),
        Post(location: "Memorial Stadium", image: UIImage(named: "garbers"), user: "rjpimentel", caption: "Last Cal Football game of senior year!", date: Date()),
        Post(location: "Soda Hall", image: UIImage(named: "soda"), user: "chromadrive", caption: "Find your happy place 💻", date: Date())
    ]
    
    // Adds dummy data to each thread
    init() {
        for thread in threads {
            let entry = ThreadEntry(username: self.username, image: UIImage(named: "garbers")!)
            thread.addEntry(threadEntry: entry)
        }
    }
    
    func addPost(post: Post) {
        posts.append(post)
    }
    
    // Optional: Implement adding new threads!
    func addThread(thread: Thread) {
        threads.append(thread)
    }
}

// write firebase functions here (pushing, pulling, etc.) 

struct PostData {
    let image: UIImage
    let timestamp: Date
    let caption: String
    let user: String

    }

let db = Firestore.firestore()
let storage = Storage.storage()


 func threadAdd(thread: ThreadEntry) {
    let imageID = UUID.init().uuidString
    let user = thread.username
    
    let storageRef = storage.reference(withPath: "images/\(imageID).jpg")
    guard let imageData = thread.image.jpegData(compressionQuality: 0.75) else {return}
    let uploadMetadata = StorageMetadata.init()
    uploadMetadata.contentType = "image/jpeg"
    storageRef.putData(imageData)
    
    var ref = db.collection("threadEntry").addDocument(data: [
        "imageID" : imageID,
        "user": user])
}

func postAdd(post: Post) {
    let imageID = UUID.init().uuidString
    let timestamp = Timestamp(date: post.date)
    
    let storageRef = storage.reference(withPath: "images/\(imageID).jpg")
    guard let imageData = post.image!.jpegData(compressionQuality: 0.75) else {return}
    let uploadMetadata = StorageMetadata.init()
    uploadMetadata.contentType = "image/jpeg"
    storageRef.putData(imageData)
    
    var ref = db.collection("postEntry").addDocument(data: [
        "imageID" : imageID,
        "user": post.user,
        "caption": post.caption,
        "timeStamp": timestamp,
        "location": post.location
        ])
}


