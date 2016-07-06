//
//  MPGTextField-Swift.swift
//  MPGTextField-Swift
//
//  Created by Gaurav Wadhwani on 08/06/14.
//  Copyright (c) 2014 Mappgic. All rights reserved.
//

import UIKit

@objc protocol MPGTextFieldDelegate{
    func dataForPopoverInTextField(textfield: MPGTextField_Swift) -> [[String : AnyObject]]
    func searchTextChanged()
    optional func textFieldDidEndEditing(textField: MPGTextField_Swift, isIndex: Bool)
    optional func textFieldShouldSelect(textField: MPGTextField_Swift) -> Bool
    
}

class MPGTextField_Swift: UISearchBar, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    weak var mDelegate : MPGTextFieldDelegate?
    var tableViewController : UITableViewController?
    var data = [[String : AnyObject]]()
    @IBInspectable var popoverBackgroundColor : UIColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    @IBInspectable var popoverSize : CGRect?
    @IBInspectable var seperatorColor : UIColor = UIColor(white: 0.95, alpha: 1.0)


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    func removeFromView() {
        if let table = self.tableViewController{
            if table.tableView.superview != nil{
                table.tableView.removeFromSuperview()
                self.tableViewController = nil
            }
        }
    }
    
    
    override func layoutSubviews(){
        if self.delegate == nil {
            self.delegate = self
        }
        super.layoutSubviews()
    }
    
    override func resignFirstResponder() -> Bool{
        UIView.animateWithDuration(0.3,
            animations: ({
                if let table = self.tableViewController {
                    table.tableView.alpha = 0.0
                }
                }),
            completion:{
                (finished : Bool) in
                    if self.tableViewController != nil {
                        self.tableViewController!.tableView.removeFromSuperview()
                        self.tableViewController = nil
                    }
                
                })
        self.handleExit()
        return super.resignFirstResponder()
    }
    
    func provideSuggestions(){
        guard let str = self.text,
                let superView = self.superview else {
            return
        }
        if let _ = self.tableViewController {
            tableViewController!.tableView.reloadData()
        }
        else if self.applyFilterWithSearchQuery(str).count > 0{
            //let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MPGTextField_Swift.tapped(_:)))
            //tapRecognizer.numberOfTapsRequired = 1
            //tapRecognizer.cancelsTouchesInView = false
            //tapRecognizer.delegate = self
            //superView.addGestureRecognizer(tapRecognizer)
            self.tableViewController = UITableViewController()
            self.tableViewController!.tableView.delegate = self
            self.tableViewController!.tableView.dataSource = self
            self.tableViewController!.tableView.backgroundColor = self.popoverBackgroundColor
            self.tableViewController!.tableView.separatorColor = self.seperatorColor
            if let frameSize = self.popoverSize{
                self.tableViewController!.tableView.frame = frameSize
            } else {
                var frameForPresentation = self.frame
                frameForPresentation.origin.y += self.frame.size.height
                frameForPresentation.size.height = 200
                self.tableViewController!.tableView.frame = frameForPresentation
            }
            
            var frameForPresentation = self.frame
            frameForPresentation.origin.y += self.frame.size.height;
            frameForPresentation.size.height = 200;
            tableViewController!.tableView.frame = frameForPresentation
            
            superView.addSubview(tableViewController!.tableView)
            self.tableViewController!.tableView.alpha = 0.0
            UIView.animateWithDuration(0.3,
                animations: ({
                    self.tableViewController!.tableView.alpha = 1.0
                    }),
                completion:{
                    (finished : Bool) in
                })
        }
    }
    
//    func tapped (sender : UIGestureRecognizer!){
//        if let table = self.tableViewController{
//            if !CGRectContainsPoint(table.tableView.frame, sender.locationInView(self.superview)) && self.isFirstResponder(){
//                if self.tableViewController != nil {
//                    self.tableViewController!.tableView.removeFromSuperview()
//                    self.tableViewController = nil
//                }
//                super.resignFirstResponder()
//            }
//        }
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let str = self.text else {
            return 0
        }
        let count = self.applyFilterWithSearchQuery(str).count
        if count == 0{
            UIView.animateWithDuration(0.3,
                animations: ({
                    if let table = self.tableViewController {
                        table.tableView.alpha = 0.0
                    }
                    }),
                completion:{
                    (finished : Bool) in
                    if let table = self.tableViewController{
                        table.tableView.removeFromSuperview()
                        self.tableViewController = nil
                    }
                })
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MPGResultsCell") ?? UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MPGResultsCell")
        guard let str = self.text else {
            return cell
        }
        cell.backgroundColor = UIColor.clearColor()
        let dataForRowAtIndexPath = self.applyFilterWithSearchQuery(str)[indexPath.row]
        guard let displayText = dataForRowAtIndexPath["DisplayText"] as? String,
            let displaySubText = dataForRowAtIndexPath["DisplaySubText"] as? String else {
                return cell
        }
        cell.textLabel!.text = displayText
        cell.detailTextLabel!.text = displaySubText
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.resignFirstResponder()
    }
    
    
    func applyFilterWithSearchQuery(filter : String) -> [[String : AnyObject]]
    {
        let filteredData = data.filter({
                if let matchText = $0["DisplayText"] as? String,
                    let matchSubText = $0["DisplaySubText"] as? String {
                    return (matchText.lowercaseString.rangeOfString((filter as String).lowercaseString) != nil) || (matchSubText.lowercaseString.rangeOfString((filter as String).lowercaseString) != nil)
                }
                else{
                    return false
                }
            })
        return filteredData
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        handleExit()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        guard let str = self.text,
            let mDelegate = mDelegate else {
                removeFromView()
                return
        }
        guard str.characters.count > 0 && self.isFirstResponder() else {
            removeFromView()
            return
        }
        data = mDelegate.dataForPopoverInTextField(self)
        self.provideSuggestions()
        mDelegate.searchTextChanged()
    }
    
    func handleExit(){
        let selectedIndexPath = self.tableViewController?.tableView.indexPathForSelectedRow
        guard let str = self.text else {
            return
        }
        if let table = self.tableViewController{
            table.tableView.removeFromSuperview()
        }
        guard let indexPath = selectedIndexPath else {
            mDelegate?.textFieldDidEndEditing?(self, isIndex: false)
            self.tableViewController = nil
            return
        }
        if ((mDelegate?.textFieldShouldSelect?(self)) != nil){
            if self.applyFilterWithSearchQuery(str).count > 0 {
                let selectedData = self.applyFilterWithSearchQuery(str)[indexPath.row]
                if let displayText = selectedData["DisplaySubText"] as? String {
                    self.text = displayText
                }
            }
            mDelegate?.textFieldDidEndEditing?(self, isIndex: true )
        }

    }

}
