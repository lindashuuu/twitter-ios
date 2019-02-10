
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
        numberOfTweet=20
        myRefresh.addTarget(self,  action: #selector(getTweets), for: .valueChanged)
        tableView.refreshControl=myRefresh
        tableView.rowHeight=UITableView.automaticDimension
        tableView.estimatedRowHeight=160
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getTweets()
    }
    @objc func getTweets(){
        let url="https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        let params: [String:Any]=["count":numberOfTweet]
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row+1 == tweetArray.count{
            getMoreTweets()
        }
    }


    @IBAction func onLogOut(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: false, completion: nil)
        UserDefaults.standard.set(false, forKey:"login" )
       
        //
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
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId=tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        return cell
    }
  

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tweetArray.count
    }


}
