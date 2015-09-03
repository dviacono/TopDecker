//
//  DeckTableViewCell.swift
//  MagicAppSingle
//
//  Created by David Iacono on 4/30/15.
//  Copyright (c) 2015 David Iacono. All rights reserved.
//

import UIKit

class DeckTableViewCell: UITableViewCell {
    // Name of card
    @IBOutlet weak var cardName: UILabel!
    // Number of card
    @IBOutlet weak var cardCount: UILabel!
    // Probability of drawing the card
    @IBOutlet weak var probDraw: UILabel!
    // Draw a card
    @IBOutlet weak var drawButton: UIButton!
    // Added techotopia code
    var databasePath = NSString()
    // Card ID
    var cardID = ""
    // Size of Library
    var librarySize: Int = 0
    // Probability calculation
    var calcProb: Double = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func drawCardFromDeck(sender: AnyObject) {
        var compare: Int! = cardCount.text!.toInt()
        if compare > 0 {
            compare = compare - 1
            cardCount.text = String(compare!)
            updateTable(compare!)
        }
    }
    
    func updateTable(newCount: Int){
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
            let insertSQL: String

            println("Call update")
            println(newCount)
            insertSQL = "UPDATE DECK SET CardCount = '\(newCount)' WHERE CardID = '\(cardID)';"
            
            
            let result = MagicDataDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if result {
                println("Success")
            }
            else {
                println("Failed")
                
            }
            MagicDataDB.close()
        } else {
            println("Error: \(MagicDataDB.lastErrorMessage())")
        }
        
    }
}
