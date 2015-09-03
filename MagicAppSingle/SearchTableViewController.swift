//
//  ViewController.swift
//  MagicAppSingle
//
//  Created by David Iacono on 4/29/15.
//  Copyright (c) 2015 David Iacono. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UITableViewDelegate {
    // Card Name
    var receivedCardName : String = ""
    // Set Name
    var receivedSetName : String = ""
    
    // Added techotopia code
    var databasePath = NSString()
    
    // List of Cards from Search
    var cardList = [String]()
    
    // List of Card ID numbers from Search
    var cardIDList = [String]()
    
    // List of Sets that correspond to Cards from Search
    var cardSetList = [String]()
    
    // List of Card Totals
    var cardCountList = [String]()
    
    // Table view
    @IBOutlet var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // From Techotopia
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "MagicData.sqlite")
        
        if !filemgr.fileExistsAtPath(databasePath as String) {
            
            let MagicDataDB = FMDatabase(path: databasePath as String)
            
            if MagicDataDB == nil {
                println("Error: \(MagicDataDB.lastErrorMessage())")
            }
            
            if MagicDataDB.open() {
                println("Error: \(MagicDataDB.lastErrorMessage())")
                
                MagicDataDB.close()
            } else {
                println("Error: \(MagicDataDB.lastErrorMessage())")
            }
        }
        
        // Open database and search
        let MagicDataDB = FMDatabase(path: databasePath as String)
        
        if MagicDataDB.open() {
            let querySQL = "SELECT SETCARDS.CardID, CardName, SetName FROM CARDS, SETCARDS, SETS WHERE CARDS.CardID = SETCARDS.CardID AND SETS.SetID = SETCARDS.SetID AND CardName LIKE '%\(receivedCardName)%' AND SETS.SetName LIKE '%\(receivedSetName)%' ORDER BY CARDS.CardName;"

            let results:FMResultSet? = MagicDataDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            println("\n\nQuery\n*************")
            while results?.next() == true {
                receivedCardName = results!.stringForColumn("CardName")
                
                cardList.append(receivedCardName)
                cardIDList.append(results!.stringForColumn("CardID"))
                cardSetList.append(results!.stringForColumn("SetName"))
            }
            receivedCardName = ""
            println("List Count")
            println(cardList.count)
            
            MagicDataDB.close()
        } else {
            println("Error: \(MagicDataDB.lastErrorMessage())")
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TableViewCell {
        // Add cells to the table and feed the data to each cell
        let SearchCell = self.tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as! TableViewCell
        SearchCell.cardNameCell.text = cardList[indexPath.row]
        SearchCell.cardID = cardIDList[indexPath.row]
        
        return SearchCell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        // navigate back to root ViewController
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

}

