//
//  TableViewCell.swift
//  MagicAppSingle
//
//  Created by David Iacono on 4/30/15.
//  Copyright (c) 2015 David Iacono. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    // Card name label
    @IBOutlet weak var cardNameCell: UILabel!
    
    // Card count label
    @IBOutlet weak var cardCount: UILabel!
    
    // Card stepper button
    @IBOutlet weak var cardStepper: UIStepper!
    
    // Card ID
    var cardID = ""
    
    // Card Set Name
    var cardName: String = ""
    
    // Added techotopia code
    var databasePath = NSString()
    
    // Increment or Decrement the stepper
    @IBAction func cardStep(sender: AnyObject) {
        println("cardStep")
        var stepperValue = cardStepper.value
        cardCount.text = "\(Int(stepperValue))"
        updateTable()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateTable(){
        println("updateTable")
        // From Techotopia
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "MagicData.sqlite")
        
        let MagicDataDB = FMDatabase(path: databasePath as String)
        
        if MagicDataDB.open() {
            //Check to see if it is in the table already to decide to insert or update
            let querySQL = "SELECT CardID FROM DECK WHERE CardID = '\(cardID)';"
            let check = MagicDataDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            let insertSQL: String
        
            
            if check?.next() == false{
                println("Call insert")
                println(cardCount.text!)
                insertSQL = "INSERT INTO DECK (CardID, CardCount) VALUES ('\(cardID)', '\(cardCount.text!)');"
            }
            else{
                println("Call update")
                insertSQL = "UPDATE DECK SET CardCount = '\(cardCount.text!)' WHERE CardID = '\(cardID)';"
            }
            
            let result = MagicDataDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if result {
                println("Card added")
            }
            else {
                println("Insert failed")
            }
            MagicDataDB.close()
        } else {
            println("Error: \(MagicDataDB.lastErrorMessage())")
        }

    }

}
