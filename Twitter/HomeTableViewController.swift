
//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by linda shu on 2/2/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var tweetArray=[NSDictionary]()
    var numberOfTweet:Int!
    let myRefresh=UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTweets()
        myRefresh.addTarget(self,  action: #selector(getTweets), for: .valueChanged)
        tableView.refreshControl=myRefresh
    }
    
    @objc func getTweets(){
        let url="https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweet=10
        let params=["count":numberOfTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }, failure: { (Error) in
            print("failed to get tweets")
        })
    }
    
    func getMoreTweets(){
        let url="https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweet+=20
        let params=["count":numberOfTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("failed to get tweets")
        })
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if IndexPath.row+1=tweetArray.count{
            getMoreTweets()
        }
    }

    @IBAction func onLogout(_ sender: Any) {
            TwitterAPICaller.client?.logout()
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(false, forKey: "login")
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCellTableViewCell
        let name=tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text=name["name"] as! String
        cell.tweetContent.text=tweetArray[indexPath.row]["text"] as! String
        
        let imageUrl = URL(string: (name["profile_image_url"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData=data{
            cell.tweetImage.image=UIImage(data:imageData)

        }
        
        return cell
    }
  

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tweetArray.count
    }


}
