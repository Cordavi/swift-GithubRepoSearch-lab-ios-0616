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
   
   class func getRepositoriesWithCompletion(completion: GitRepositoryResponse -> Void) {
      let urlString = "\(GitHutWebPaths.gitHubAddress)" + "repositories" + "\(APIKeys.clientID)" + "\(APIKeys.clientSecret)"
      
      Alamofire.request(.GET, urlString).responseJSON { response in
         
         if let data = response.data {
            completion((JSON(data: data).arrayObject as? [[String: AnyObject]], response.result.error))
         } else {
            completion((nil, response.result.error))
         }
      }
   }
   
   class func checkIfRepositoryIsStarred(fullName: String, completion: Bool -> Void) {
      let urlString = "\(GitHutWebPaths.gitHubAddress)" + "\(GitHutWebPaths.gitHubStarred)" + "\(fullName)"
      
      guard let repoStarredURL = NSURL(string: urlString) else {
         return
      }
      
      let request = NSMutableURLRequest(URL: repoStarredURL)
      request.HTTPMethod = "GET"
      request.addValue("\(APIKeys.headerAccessToken)", forHTTPHeaderField: "Authorization")
      
      let urlSession = NSURLSession.sharedSession()
      urlSession.dataTaskWithRequest(request) { _, response, _ in
         guard let httpResponse = response as? NSHTTPURLResponse else {
            return
         }
         
         if httpResponse.statusCode == 404 {
            completion(false)
         } else if httpResponse.statusCode == 204 {
            completion(true)
         } else {
            print("Other status code \(httpResponse.statusCode)")
         }
         
         }.resume()
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



