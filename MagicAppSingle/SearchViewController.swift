//
//  ViewController.swift
//  MagicAppSingle
//
//  Created by David Iacono on 4/29/15.
//  Copyright (c) 2015 David Iacono. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // Name of the card that is being searched for
    @IBOutlet weak var CardName: UITextField!
    // Name of the set that is being searched for
    @IBOutlet weak var SetName: UITextField!
    
    @IBAction func cancelTapped(sender: AnyObject) {
        // navigate back to root ViewController
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Send the data to the next View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var searchTable : SearchTableViewController = segue.destinationViewController as! SearchTableViewController
        searchTable.receivedCardName = CardName.text
        searchTable.receivedSetName = SetName.text
    }
}

