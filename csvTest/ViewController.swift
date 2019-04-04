//
//  ViewController.swift
//  csvTest
//
//  Created by Doyle, Mark(Information Technology Services) on 3/25/19.
//  Copyright © 2019 Doyle, Mark(Information Technology Services). All rights reserved.
//

import Cocoa


//Add NSTableViewDelegate and NSTAbleViewDataSource to Class
class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

//TableView Connection.
    @IBOutlet var tableView: NSTableView!
    
  
//Path to the active CSV... Not actually used in this script.
   let activeCSV = Bundle.main.path(forResource: "ActiveMacs", ofType: "csv", inDirectory: "csv")
    
    var data: [[String]]!
    var dictionaryItems = [String:String]()
    var computers = [[String:String]]()
    
//Function to read data from CSV.
    func getData(fileName:String, header1:String, header2:String, header3:String){
    data = readDataFromFile(file:fileName).components(separatedBy: "\n").map{ $0.components(separatedBy: ",")}
        for i in 1..<data.count-1 {
            let items = data[i]
            dictionaryItems[header1] = "\(items[0])"
            dictionaryItems[header2] = "\(items[1])"
            dictionaryItems[header3] = "\(items[2])"
            computers.append(dictionaryItems)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      getData(fileName:"ActiveMacs", header1: "serialNumber", header2: "assetTag", header3: "active")
        print(computers)
    }

//    override var representedObject: Any? {
//        didSet {
//        // Update the view, if already loaded.
//        }
//    }
    
    func readDataFromFile(file:String)-> String!{
        guard let filepath = Bundle.main.path (forResource: file, ofType: "csv",  inDirectory: "csv")
            else {return nil}
        do {
            var contents = try String(contentsOfFile: filepath)
            contents = contents.replacingOccurrences(of: "\r", with: "\n")
            contents = contents.replacingOccurrences(of: "\n\n", with: "\n")
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }

    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }

    
//Functions to populate Computer data to table.
    func numberOfRows(in tableView: NSTableView) -> Int {
            return computers.count
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            var result:NSTableCellView
        result = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
            result.textField?.stringValue = computers[row][(tableColumn?.identifier.rawValue)!]!
            return result
                }
}

