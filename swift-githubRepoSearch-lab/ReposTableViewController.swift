//
//  ReposTableViewController.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReposTableViewController: UITableViewController {
   let dataStore = ReposDataStore.sharedInstance
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.tableView.accessibilityLabel = "tableView"
      self.tableView.delegate = self
      
      //      GithubAPIClient.searchRepositories("Swift") { repsonse in
      //         for dictItem in repsonse.data! {
      //            print(dictItem["html_url"])
      //         }
      //      }
      //
      dataStore.getRepositoriesWithCompletion {
         dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
         }
      }
   }
   
   @IBAction func searchButtonTapped(sender: AnyObject) {
//      //1. Create the alert controller.
//      let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .Alert)
//      
//      //2. Add the text field. You can configure it however you need.
//      alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
//         textField.text = "Some default text."
//      })
//      
//      //3. Grab the value from the text field, and print it when the user clicks OK.
//      alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
//         let textField = alert.textFields![0] as UITextField
//         print("Text field: \(textField.text)")
//      }))
//      
//      // 4. Present the alert.
//      self.presentViewController(alert, animated: true, completion: nil)
      let searchAlertView = UIAlertController(title: "Search GitHub", message: "Enter a term", preferredStyle: .Alert)
      
      searchAlertView.addTextFieldWithConfigurationHandler { searchTextField in
         searchTextField.placeholder = "Search term"
      }
      
      searchAlertView.addAction(UIAlertAction(title: "Search", style: .Default, handler: { alertField in
         let searchTermField = searchAlertView.textFields?.first
         if let searchTerm = searchTermField {
            print(searchTerm.text)
         }

      }))
      self.presentViewController(searchAlertView, animated: true, completion: nil)
      
   }
   
   
   
   // MARK: - Table view data source
   
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return dataStore.repositories.count
   }
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
      
      cell.textLabel?.text = dataStore.repositories[indexPath.row].fullName
      return cell
   }
   
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      let repoSelected = dataStore.repositories[indexPath.row]
      dataStore.toggleStarStatusForRepository(repoSelected) { toggle in
         if toggle {
            let alertView = UIAlertController(title: "GitHub", message: "You just starred \(repoSelected.fullName)", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertView.addAction(okAction)
            alertView.accessibilityLabel = "You just starred \(repoSelected.fullName)"
            dispatch_async(dispatch_get_main_queue(), {
               self.presentViewController(alertView, animated: true, completion: nil)
               }
            )
         } else if !toggle {
            let alertView = UIAlertController(title: "GitHub", message: "You just unstarred \(repoSelected.fullName)", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertView.addAction(okAction)
            alertView.accessibilityLabel = "You just unstarred \(repoSelected.fullName)"
            dispatch_async(dispatch_get_main_queue(), {
               self.presentViewController(alertView, animated: true, completion: nil)
               }
            )
         }
      }
   }
}


