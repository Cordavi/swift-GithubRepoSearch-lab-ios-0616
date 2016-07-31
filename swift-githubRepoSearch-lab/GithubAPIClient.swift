//
//  GithubAPIClient.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GithubAPIClient {
   
   typealias GitRepositoryResponse = (data: [[String: AnyObject]]?, error: NSError?)
   typealias GitRepositoryStarredResponse = (status: Bool?, error: NSError?)
   
   class func getRepositoriesWithCompletion(completion: GitRepositoryResponse -> Void) {
      let repoAPIString = "\(GitHutWebPaths.gitHubAddress)" + "repositories"
      Alamofire.request(.GET, repoAPIString, parameters: APIKeys.twitterLoginCredentals).responseJSON { response in
         if let data = response.data {
            completion((JSON(data: data).arrayObject as? [[String: AnyObject]], response.result.error))
         } else {
            completion((nil, response.result.error))
         }
      }
   }
   
   class func checkIfRepositoryIsStarred(fullName: String, completion: GitRepositoryStarredResponse -> Void) {
      let starredAPIString = "\(GitHutWebPaths.gitHubAddress)" + "\(GitHutWebPaths.gitHubStarred)" + "\(fullName)"
      
      Alamofire.request(.GET, starredAPIString, parameters: APIKeys.twitterLoginCredentals, headers: APIKeys.headerAccessToken).responseJSON { response in
         if response.response?.statusCode == 404 {
            completion((false, response.result.error))
         } else if response.response?.statusCode == 204 {
            completion((true, response.result.error))
         } else {
            completion((nil, response.result.error))
         }
      }
   }
   
   
   class func starRepository(fullName: String, completion: () -> Void) {
      let urlString = "\(GitHutWebPaths.gitHubAddress)" + "\(GitHutWebPaths.gitHubStarred)" + "\(fullName)"
      
      guard let repoStarredURL = NSURL(string: urlString) else {
         return
      }
      
      let request = NSMutableURLRequest(URL: repoStarredURL)
      request.HTTPMethod = "PUT"
      request.addValue("\(APIKeys.headerAccessToken)", forHTTPHeaderField: "Authorization")
      
      let urlSession = NSURLSession.sharedSession()
      urlSession.dataTaskWithRequest(request) { _, response, _ in
         guard let httpResponse = response as? NSHTTPURLResponse else {
            return
         }
         
         if httpResponse.statusCode == 204 {
            completion()
         } else {
            print("Other status code \(httpResponse.statusCode)")
         }
         
         }.resume()
   }
   
   class func unStarRepository(fullName: String, completion: () -> Void) {
      let urlString = "\(GitHutWebPaths.gitHubAddress)" + "\(GitHutWebPaths.gitHubStarred)" + "\(fullName)"
      
      guard let repoStarredURL = NSURL(string: urlString) else {
         return
      }
      
      let request = NSMutableURLRequest(URL: repoStarredURL)
      request.HTTPMethod = "DELETE"
      request.addValue("\(APIKeys.headerAccessToken)", forHTTPHeaderField: "Authorization")
      
      let urlSession = NSURLSession.sharedSession()
      urlSession.dataTaskWithRequest(request) { _, response, _ in
         guard let httpResponse = response as? NSHTTPURLResponse else {
            return
         }
         
         if httpResponse.statusCode == 204 {
            completion()
         } else {
            print("Other status code \(httpResponse.statusCode)")
         }
         
         }.resume()
      
   }
}



