//
//  ViewController.swift
//  MagicAppSingle
//
//  Created by David Iacono on 4/29/15.
//  Copyright (c) 2015 David Iacono. All rights reserved.
//

import UIKit

class DeckTableViewController: UITableViewController, UITableViewDelegate {
    // Added techotopia code
    var databasePath = NSString()
    
    // Table view
    @IBOutlet var searchTableView: UITableView!
    
    // List of Cards from Search
    var cardList = [String]()
    
    // List of Card IDs from Search
    var cardIDList = [String]()
    
    // Count of Cards from Search
    var cardCount = [String]()
    
    // Size of Library
    var libSize = ""
    
    // UITableView Reference
    @IBOutlet var cardTableView: UITableView!
    
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
                //}
                MagicDataDB.close()
            } else {
                println("Error: \(MagicDataDB.lastErrorMessage())")
            }
        }
    
        // SEARCH DATABASE
        let MagicDataDB = FMDatabase(path: databasePath as String)
        
        if MagicDataDB.open() {
            // Query DB
            println("Got here 1")
            let querySQL = "SELECT CARDS.CardID, CardName, CardCount FROM CARDS, DECK WHERE CARDS.CardID = DECK.CardID AND  (DECK.CardCount > 0) ORDER BY CARDS.CardID;"
            println("got here 2")
            let results:FMResultSet? = MagicDataDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            println("\n\nQuery\n*************")
            //libSize = results!.stringForColumn("LibCount")
            while results?.next() == true {
                cardIDList.append(results!.stringForColumn("CardID"))
                cardList.append(results!.stringForColumn("CardName"))
                cardCount.append(results!.stringForColumn("CardCount"))
            }
            
            let sizeSQL = "SELECT SUM(CardCount) AS LibCount FROM CARDS, DECK WHERE CARDS.CardID = DECK.CardID;"
            
            let sizeResults:FMResultSet? = MagicDataDB.executeQuery(sizeSQL,
                withArgumentsInArray: nil)
            
            if results?.next() == true{
                libSize = results!.stringForColumn("LibCount")
            }
            println(libSize)
            println(cardList.count)
            
            MagicDataDB.close()
        } else {
            println("Error: \(MagicDataDB.lastErrorMessage())")
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> DeckTableViewCell {
        // Add cells to the table and feed the data to each cell
        let SearchCell = self.tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as! DeckTableViewCell
        SearchCell.cardID = cardIDList[indexPath.row]
        SearchCell.cardName.text = cardList[indexPath.row]
        SearchCell.cardCount.text = cardCount[indexPath.row]
        
        return SearchCell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refreshData(sender: AnyObject) {
        viewDidLoad()
        cardTableView.reloadData()
    }
}

