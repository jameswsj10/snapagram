//
//  UploadDetailVC.swift
//  Snapagram
//
//  Created by James Jung on 3/24/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import Foundation
import UIKit


class UploadDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var selectedImage: UIImage!
    @IBOutlet var threadCollectionView: UICollectionView!
    @IBOutlet weak var feedLocation: UITextField!
    @IBOutlet weak var feedCaption: UITextField!
    @IBOutlet weak var imgToPost: UIImageView!
    var selectedThread: Thread?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgToPost.image = selectedImage
    }
    @IBAction func uploadImg(_ sender: Any) {
        // if selected thread, upload to thread
        if let thread = selectedThread {
            print(thread)
            let currThreadEntry = ThreadEntry(username: feed.username, image: selectedImage)
            thread.addEntry(threadEntry: currThreadEntry)
            selectedThread = nil
            print("uploaded via thread")
            Snapagram.threadAdd(thread: currThreadEntry)
        // if feedlocation and feedcaption is filled in, upload to feed
        } else if let loc = feedLocation.text, let caption = feedCaption.text {
            let currPost = Post(location: loc, image: selectedImage, user: feed.username, caption: caption, date: Date())
            feed.addPost(post: currPost)
            feedLocation.text = ""
            feedCaption.text = ""
            print("uploaded via post")
            Snapagram.postAdd(post: currPost)
        } else {
            print("no threads or location selected")
        }
        
        self.navigationController?.popToRootViewController(animated: true)
        print("successfully uploaded")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.threads.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedThread = feed.threads[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let thread = feed.threads[index]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "threadCell", for: indexPath) as? ThreadCollectionViewCell {
            cell.threadEmojiLabel.text = thread.emoji
            cell.threadNameLabel.text = thread.name
            cell.threadUnreadCountLabel.text = String(thread.unreadCount())
            
            cell.threadBackground.layer.cornerRadius =  cell.threadBackground.frame.width / 2
            cell.threadBackground.layer.borderWidth = 3
            cell.threadBackground.layer.masksToBounds = true
            
            cell.threadUnreadCountLabel.layer.cornerRadius = cell.threadUnreadCountLabel.frame.width / 2
            cell.threadUnreadCountLabel.layer.masksToBounds = true
            
            if thread.unreadCount() == 0 {
                cell.threadUnreadCountLabel.alpha = 0
            } else {
                cell.threadUnreadCountLabel.alpha = 1
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
}
