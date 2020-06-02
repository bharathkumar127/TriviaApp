//
//  ViewController.swift
//  TriviaApp
//
//  Created by suhaas v reddy on 6/1/20.
//  Copyright © 2020 Bharath Kumar. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    var db: OpaquePointer?
    

    @IBOutlet weak var textFieldName: UITextField!
    
    
    @IBAction func buttonSave(_ sender: Any) {
        let name = textFieldName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let 
        
        if(name?.isEmpty)!{
            print("Name is empty")
            return;
        }
        
        var stmt: OpaquePointer?
        
        let insertQuery = "INSERT INTO Trivia(name) VALUES (?)"
        
        
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK{
            print("Error Binding query")
            return;
        }
        
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK{
            print("Error Binding name")
            return;
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            print("Trivia Saved successfully")
            return;
        }
        let selectQuery = "SELECT * FROM Trivia;"
        if sqlite3_prepare_v2(db, selectQuery, -1, &stmt, nil) ==
            SQLITE_OK {
          // 2
          if sqlite3_step(stmt) == SQLITE_ROW {
            // 3
            //let id = sqlite3_column_int(stmt, 0)
            // 4
            guard let queryResultCol1 = sqlite3_column_text(stmt, 1) else {
              print("Query result is nil")
              return
            }
            let name = String(cString: queryResultCol1)
            // 5
            print("\nQuery Result:successful")
            print("\(name)")
        } else {
            print("\nQuery returned no results.")
        }
        } else {
            // 6
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("\nQuery is not prepared \(errorMessage)")
        }
        // 7
        sqlite3_finalize(stmt)

    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Mydatabse.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening database")
            return
        }
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS Trivia(name TEXT, ques1 TEXT, ques2 TEXT)"
        
        if  sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
            print("Error creating table")
            return
        }
        print("Everything is fine")
    }


}

