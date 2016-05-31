//
//  ColumnsViewController.swift
//  InventoryPortal
//
//  Created by administrator on 10/16/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import UIKit
import XuniFlexGridKit

protocol ColumnsDelegate {
    func changedFilters()
}

class ColumnsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ColumnCellDelegate, FiltersDelegate  {

    @IBOutlet weak var columnsTableView: UITableView!
    
    lazy var longPress: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer()
        return recognizer
    }()
    
    var columnSettings : FlexColumnCollection?
    var columnsDelegate: ColumnsDelegate?
    //var gridFilter: [ColumnFilters]?
    //var filterSettings :
    
    var sourceIndexPath: NSIndexPath? = nil
    var snapshot: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longPress.addTarget(self, action: #selector(ColumnsViewController.longPressGestureRecognized(_:)))
        columnsTableView.addGestureRecognizer(longPress)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFiltersViewController" {
            guard let index = sender as? NSIndexPath else {
                return
            }
            //let index = (columnsTableView.indexPathForSelectedRow)?.row
            //let column =  columnSettings?.objectAtIndex(UInt(index!)) as? GridColumn
            let column =  columnSettings?.objectAtIndex(UInt(index.row)) as? GridColumn
            let columnFilters = column!.columnFilters
            let filtersViewController = segue.destinationViewController as! FiltersViewController
            filtersViewController.filterDelegate = self
            filtersViewController.columnFilters = columnFilters
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "showFiltersViewController" {
            guard let index = (columnsTableView.indexPathForSelectedRow)?.row, let _ =  columnSettings?.objectAtIndex(UInt(index)) as? GridColumn else {
                return false
            }
        }
        return true
    }
    
//    @IBAction func unwindFromFilters(segue: UIStoryboardSegue) {
//        guard let indexPath = columnsTableView.indexPathForSelectedRow,
//                let column =  columnSettings?.objectAtIndex(UInt(indexPath.row)) as? GridColumn,
//                let cell = columnsTableView.cellForRowAtIndexPath(indexPath) as? ColumnsTableViewCell else {
//            return
//        }
//        cell.filterImage.hidden = column.columnFilters.filterList.count == 0
//    }
    
    @IBAction func removeFilters(sender: AnyObject) {
        var isFilterChanged = false
        guard let myColumnSettings = columnSettings else {
            return
        }
        for index in 0...myColumnSettings.count - 1 {
            guard let column = myColumnSettings.objectAtIndex(index) as? GridColumn else {
                continue
            }
            if column.columnFilters.filterList.count > 0 {
                isFilterChanged = true
            }
            column.columnFilters.filterList.removeAll()
        }
        guard isFilterChanged else {
            return
        }
        changedFilters()
        columnsTableView.reloadData()

    }

    @IBAction func defaultView(sender: AnyObject) {
        columnSettings?.removeAllObjects()
        let columns = GridColumn.generateColumns(nil)
        for column in columns {
            columnSettings?.addObject(column)
        }
        columnsTableView.reloadData()
    }
    
    func longPressGestureRecognized(gesture: UILongPressGestureRecognizer) {
        let state: UIGestureRecognizerState = gesture.state;
        let location: CGPoint = gesture.locationInView(columnsTableView)
        
        //if location.y < 0 {
        //    location.y = CGFloat(0)
        //}
        
        let indexPath: NSIndexPath? = columnsTableView.indexPathForRowAtPoint(location)
        
        //if indexPath == nil {
        //    indexPath = NSIndexPath(forRow: Int(columnSettings!.count) - 1, inSection: 0)
        //}
        
        switch (state) {
            
        case UIGestureRecognizerState.Began:
            guard let indexPath = indexPath else {
                return
            }
            sourceIndexPath = indexPath;
            let cell = columnsTableView.cellForRowAtIndexPath(indexPath)!
            snapshot = customSnapshotFromView(cell)
            
            var center = cell.center
            snapshot?.center = center
            snapshot?.alpha = 0.0
            columnsTableView.addSubview(snapshot!)
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                center.y = location.y
                self.snapshot?.center = center
                self.snapshot?.transform = CGAffineTransformMakeScale(1.05, 1.05)
                self.snapshot?.alpha = 0.98
                cell.alpha = 0.0
            })
            
            
        
        case UIGestureRecognizerState.Changed:
            guard let indexPath = indexPath else {
                return
            }
            var center: CGPoint = snapshot!.center
            center.y = location.y
            snapshot?.center = center
            
            
            if indexPath != sourceIndexPath {
                // ... update data source.
                moveColumnAtIndex(sourceIndexPath!.row, toIndex: indexPath.row)
                // ... move the rows.
                columnsTableView.moveRowAtIndexPath(sourceIndexPath!, toIndexPath: indexPath)
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            
            
            
        default:
            guard let cell = columnsTableView.cellForRowAtIndexPath(sourceIndexPath!)  else {
                return
            }
            cell.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.snapshot?.center = cell.center
                self.snapshot?.transform = CGAffineTransformIdentity
                self.snapshot?.alpha = 0.0
                // Undo fade out.
                cell.alpha = 1.0
                
                }, completion: { (finished) in
                    
                    self.sourceIndexPath = nil
                    self.snapshot?.removeFromSuperview()
                    self.snapshot = nil;
            })
            
            // Clean up.
            //guard let cell = columnsTableView.cellForRowAtIndexPath(indexPath!) else {
            //    return
            //}
            //let cell = columnsTableView.cellForRowAtIndexPath(indexPath!)!
            //break
        }
    }
    
    func moveColumnAtIndex(fromIndex: Int, toIndex: Int) {
        guard let movedItem = columnSettings?.objectAtIndex(UInt(fromIndex)) else {
            return
        }
        columnSettings?.removeObjectAtIndex(UInt(fromIndex))
        columnSettings?.insertObject(movedItem, atIndex: UInt(toIndex))

    }
   
    func customSnapshotFromView(inputView: UIView) -> UIView {
        
        // Make an image from the input view.
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        if let context = UIGraphicsGetCurrentContext()
        {
            inputView.layer.renderInContext(context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        // Create an image view.
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        
        return snapshot
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let myColumnSettings = columnSettings else {
            return 1
        }
        return Int(myColumnSettings.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = columnsTableView.dequeueReusableCellWithIdentifier("ColumnsTableCell", forIndexPath: indexPath) as! ColumnsTableViewCell
        let row = indexPath.row
        cell.switchDelegate = self
        
        guard let myColumnSettings = columnSettings else {
            return cell
        }
        let col = myColumnSettings.objectAtIndex(UInt(row)) as! GridColumn
        cell.columnsLabel.text = col.header
        cell.columnsSwitch.on = col.visible
        cell.filterImage.hidden = col.columnFilters.filterList.count == 0
        cell.stateLabel.text = col.visible ? "Visible" : "Hidden"
        cell.stateLabel.textColor = col.visible ? UIColor.blackColor()  : UIColor.redColor()
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let filter = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Filter", handler: { (action, indexPath) -> Void in
            //self.editing = false
            self.performSegueWithIdentifier("showFiltersViewController", sender: indexPath)
            self.columnsTableView.reloadData()
        })
        filter.backgroundColor = UIColor.lightGrayColor()
        let actionArray: Array = [filter]
        return actionArray
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func didChangeSwitchState(sender: ColumnsTableViewCell, isOn: Bool) {
        guard let indexPath = columnsTableView.indexPathForCell(sender),
                let col = columnSettings!.objectAtIndex(UInt(indexPath.row)) as? FlexColumn else {
            return
        }
        col.visible = isOn
        col.allowResizing = isOn
        //if !col.visible {
        //    moveColumnAtIndex(indexPath.row, toIndex: NSIndexPath(forRow: Int(columnSettings!.count) - 1, inSection: 0).row)
        //}
        //columnsTableView.reloadData()
    }

    func changedFilters() {
        columnsDelegate?.changedFilters()
        guard let indexPath = columnsTableView.indexPathForSelectedRow,
            let column =  columnSettings?.objectAtIndex(UInt(indexPath.row)) as? GridColumn,
            let cell = columnsTableView.cellForRowAtIndexPath(indexPath) as? ColumnsTableViewCell else {
                return
        }
        cell.filterImage.hidden = column.columnFilters.filterList.count == 0
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
