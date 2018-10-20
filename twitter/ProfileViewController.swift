//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Neil Shah on 10/12/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    
    @IBOutlet weak var detailLabelView: UIView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var statusCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var user : User?
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.backgroundColor = UIColor(red: 200/255, green: 249/255, blue: 255/255, alpha: 1)
        detailLabelView.layer.borderWidth = 0.5
        detailLabelView.layer.borderColor = UIColor.black.cgColor
        circularProfilePicture()
        loadProfileInfo()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadProfileInfo()
        user = User.current!
    }
    
    func loadProfileInfo(){
         if let user = self.user {
            usernameLabel.text = "@\(user.screenName)"
            if user.name != nil {
                fullNameLabel.text = user.name
            }
            followersCountLabel.text = "\(user.followercount!)"
            followingCountLabel.text = "\(user.friendcount!)"
            statusCountLabel.text = "\(user.statusCount!)"
            if let propicURL = user.profilepic {
                profileImageView.af_setImage(withURL: propicURL)
            }
            if let bannerURL = user.bannerpic {
                bannerImageView.af_setImage(withURL: bannerURL)
            }
            fetchTweets()
        }
        
    }
    
    func fetchTweets() {
        APIManager.shared.getUserTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    func circularProfilePicture() {
        profileImageView.layer.cornerRadius = profileImageView.layer.frame.height/2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func didTapCompose(_ sender: Any) {
        self.performSegue(withIdentifier: "composeProfileSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.user = self.user
        //cell.parentView = self as ProfileViewController
        cell.indexPath = indexPath
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="composeProfileSegue") {
            if let composeView = segue.destination as? composeViewController {
                composeView.user = User.current
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
