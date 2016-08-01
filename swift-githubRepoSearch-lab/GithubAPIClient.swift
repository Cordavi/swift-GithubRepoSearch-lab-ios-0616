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
   typealias GitRepositorySearch = (data: [String: AnyObject]?, error: NSError?)
   
   static let starredAPIString = "\(GitHubWebPaths.gitHubAddress)" + "\(GitHubWebPaths.gitHubStarred)"
   static let searchAPIString = "\(GitHubWebPaths.gitHubAddress)" + "\(GitHubWebPaths.gitHubSearch)"
   
   
   class func getRepositoriesWithCompletion(completion: GitRepositoryResponse -> Void) {
      let repoAPIString = "\(GitHubWebPaths.gitHubAddress)" + "repositories"
      Alamofire.request(.GET, repoAPIString, parameters: APIKeys.twitterLoginCredentals).responseJSON { response in
         if let data = response.data {
            completion((JSON(data: data).arrayObject as? [[String: AnyObject]], response.result.error))
         } else {
            completion((nil, response.result.error))
         }
      }
   }
   
   class func checkIfRepositoryIsStarred(fullName: String, completion: GitRepositoryStarredResponse -> Void) {
      
      Alamofire.request(.GET, starredAPIString + "\(fullName)", parameters: APIKeys.twitterLoginCredentals, headers: APIKeys.headerAccessToken).responseJSON { response in
         
         if let serverResponse = response.response {
            switch serverResponse.statusCode {
            case 404:
               completion((false, response.result.error))
            case 204:
               completion((true, response.result.error))
            default:
               completion((nil, response.result.error))
            }
         }
      }
   }
   
   
   class func starRepository(fullName: String, completion: GitRepositoryStarredResponse -> Void) {
      Alamofire.request(.PUT, starredAPIString + "\(fullName)", parameters: APIKeys.twitterLoginCredentals, headers: APIKeys.headerAccessToken).responseJSON { response in
         if let serverResponse = response.response {
            switch serverResponse.statusCode {
            case 204:
               completion((true, response.result.error))
            default:
               completion((nil, response.result.error))
            }
         }
      }
   }
   
   class func unStarRepository(fullName: String, completion: GitRepositoryStarredResponse -> Void) {
      Alamofire.request(.DELETE, starredAPIString + "\(fullName)", parameters: APIKeys.twitterLoginCredentals, headers: APIKeys.headerAccessToken).responseJSON { response in
         if let serverResponse = response.response {
            switch serverResponse.statusCode {
            case 204:
               completion((true, response.result.error))
            default:
               completion((nil, response.result.error))
            }
         }
      }
   }
   
   class func searchRepositories(searchTerm: String, completion: GitRepositoryResponse -> Void) {
      Alamofire.request(.GET, searchAPIString + "\(searchTerm)", parameters: APIKeys.twitterLoginCredentals, headers: APIKeys.headerAccessToken).responseJSON { response in
         if let data = response.data {
            if let searchData = JSON(data: data).dictionaryObject {
               if let searchRepos = searchData["items"] {
                  completion((JSON(searchRepos).arrayObject as? [[String: AnyObject]], response.result.error))
               }
            }
         } else {
            completion((nil, response.result.error))
         }
      }
   }
}




