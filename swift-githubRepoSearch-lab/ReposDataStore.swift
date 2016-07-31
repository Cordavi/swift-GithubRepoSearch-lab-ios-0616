//
//  ReposDataStore.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
   
   static let sharedInstance = ReposDataStore()
   var repositories = [GithubRepository]()
   
   func getRepositoriesWithCompletion(completion: () -> Void){
      GithubAPIClient.getRepositoriesWithCompletion { responseData in
         
         guard let repositoryDictionaries = responseData.data where responseData.error == nil else {
            return
         }
         
         ReposDataStore.sharedInstance.repositories.removeAll()
         
         for repositoryDictionary in repositoryDictionaries {
            self.repositories.append(GithubRepository(dictionary: repositoryDictionary))
         }
         
         completion()
      }
   }
   
   func toggleStarStatusForRepository(repository: GithubRepository, completion: Bool -> Void) {
      GithubAPIClient.checkIfRepositoryIsStarred(repository.fullName) { responseStatus in
         
         guard let starredStatusResponse = responseStatus.status where responseStatus.error == nil else {
            return
         }
         
         if starredStatusResponse {
            GithubAPIClient.unStarRepository(repository.fullName, completion: {
               completion(false)
               }
            )
         } else if !starredStatusResponse {
            GithubAPIClient.starRepository(repository.fullName, completion: {
               completion(true)
               }
            )
         } else {
            print("There was some kind of error unstarring/starring")
         }
      }
   }
}
