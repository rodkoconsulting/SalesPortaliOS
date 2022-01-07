//
//  ColumnsViewController.swift
//  InventoryPortal
//
//  Created by administrator on 10/16/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import UIKit
import XuniFlexGridKit

protocol ColumnsDelegate: class {
    func changedColumnFilters()
}

class ColumnsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ColumnCellDelegate, FiltersDelegate  {

    @IBOutlet weak var columnsTableView: UITableView!
    
    @IBAction func unwindFromColumns(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "unwindFromColumns", sender: self)
    }
    
    lazy var longPress: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer()
        return recognizer
    }()
    
    weak var columnSettings : GridColumnCollection?
    weak var columnsDelegate: ColumnsDelegate?
    
    var module: Module?
    var sourceIndexPath: IndexPath? = nil
    var topVisibleIndexPath: IndexPath? = nil
    var snapshot: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longPress.addTarget(self, action: #selector(ColumnsViewController.longPressGestureRecognized(_:)))
        columnsTableView.addGestureRecognizer(longPress)
        columnsTableView.allowsSelection = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFiltersViewController" {
            guard let index = sender as? IndexPath,
                let column =  columnSettings?.object(at: UInt(index.row)) as? DataGridColumn else {
                return
            }
            let columnFilters = column.columnFilters
            let filtersViewController = segue.destination as! FiltersViewController
            filtersViewController.filterDelegate = self
            filtersViewController.columnFilters = columnFilters
            filtersViewController.columnIndex = index.row
            filtersViewController.modalPresentationStyle = .fullScreen
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any!) -> Bool {
        if identifier == "showFiltersViewController" {
            guard let index = (columnsTableView.indexPathForSelectedRow)?.row, let _ =  columnSettings?.object(at: UInt(index)) as? DataGridColumn else {
                return false
            }
        }
        return true
    }

    @IBAction func defaultView(_ sender: AnyObject) {
            guard let module = module else {
                return
            }
            columnSettings?.removeAllObjects()
            let (columns, _) = DataGridColumn.generateColumns(nil, module: module)
            for column in columns {
                columnSettings?.add(column)
            }
            changedAllFilters()
    }
    
    @objc func longPressGestureRecognized(_ gesture: UILongPressGestureRecognizer) {
        let state: UIGestureRecognizer.State = gesture.state;
        let location: CGPoint = gesture.location(in: columnsTableView)
        let indexPath: IndexPath? = columnsTableView.indexPathForRow(at: location)
        
        switch (state) {
        case UIGestureRecognizer.State.began:
            guard let indexPath = indexPath else {
                return
            }
            sourceIndexPath = indexPath;
            let cell = columnsTableView.cellForRow(at: indexPath)!
            snapshot = customSnapshotFromView(cell)
            
            var center = cell.center
            snapshot?.center = center
            snapshot?.alpha = 0.0
            columnsTableView.addSubview(snapshot!)
            
            UIView.animate(withDuration: 0.25, animations: { [unowned self] () -> Void  in
                center.y = location.y
                self.snapshot?.center = center
                self.snapshot?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.snapshot?.alpha = 0.98
                cell.alpha = 0.0
            })
        case UIGestureRecognizer.State.changed:
            guard let indexPath = indexPath, let superview = columnsTableView.superview  else {
                return
            }
            let cellRect = columnsTableView.rectForRow(at: indexPath)
            let convertedRect = columnsTableView.convert(cellRect, to:superview)
            let intersect = columnsTableView.frame.intersection(convertedRect)
            let visibleHeight = intersect.height
            topVisibleIndexPath = visibleHeight > 0 ? indexPath : topVisibleIndexPath
            var center: CGPoint = snapshot!.center
            center.y = location.y
            snapshot?.center = center
            if topVisibleIndexPath != sourceIndexPath {
                moveColumnAtIndex(sourceIndexPath!.row, toIndex: topVisibleIndexPath!.row)
                columnsTableView.moveRow(at: sourceIndexPath!, to: topVisibleIndexPath!)
                sourceIndexPath = topVisibleIndexPath;
            }
        default:
            guard let cell = columnsTableView.cellForRow(at: sourceIndexPath!)  else {
                return
            }
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: { [unowned self] () -> Void in
                self.snapshot?.center = cell.center
                
                self.snapshot?.transform = CGAffineTransform.identity
                self.snapshot?.alpha = 0.0
                // Undo fade out.
                cell.alpha = 1.0
                }, completion: { [unowned self] (finished) in
                    self.sourceIndexPath = nil
                    self.snapshot?.removeFromSuperview()
                    self.snapshot = nil;
            })
        }
    }
    
    func moveColumnAtIndex(_ fromIndex: Int, toIndex: Int) {
        guard let movedItem = columnSettings?.object(at: UInt(fromIndex)) else {
            return
        }
        columnSettings?.removeObject(at: UInt(fromIndex))
        columnSettings?.insert(movedItem, at: UInt(toIndex))
    }
   
    func customSnapshotFromView(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        if let context = UIGraphicsGetCurrentContext()
        {
            inputView.layer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        return snapshot
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let myColumnSettings = columnSettings else {
            return 1
        }
        return Int(myColumnSettings.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = columnsTableView.dequeueReusableCell(withIdentifier: "ColumnsTableCell", for: indexPath) as! ColumnsTableViewCell
        let row = indexPath.row
        cell.switchDelegate = self
        
        guard let myColumnSettings = columnSettings else {
            return cell
        }
        let col = myColumnSettings.object(at: UInt(row)) as! DataGridColumn
        cell.columnsLabel.text = col.header
        cell.columnsSwitch.isOn = col.visible
        cell.filterImage.isHidden = col.columnFilters.filterList.count == 0
        cell.stateLabel.text = col.visible ? "Visible" : "Hidden"
        cell.stateLabel.textColor = col.visible ? UIColor.black  : UIColor.red
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let filter = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Filter", handler: { (action, indexPath) -> Void in
            //self.editing = false
            self.performSegue(withIdentifier: "showFiltersViewController", sender: indexPath)
            self.columnsTableView.reloadData()
        })
        filter.backgroundColor = UIColor.lightGray
        let actionArray: Array = [filter]
        return actionArray
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func didChangeSwitchState(_ sender: ColumnsTableViewCell, isOn: Bool) {
        guard let indexPath = columnsTableView.indexPath(for: sender) else {
            return
        }
        let col = columnSettings!.object(at: UInt(indexPath.row))
        col.visible = isOn
        col.allowResizing = isOn
    }

    func changedFilters(columnIndex: Int) {
        let columnIndexPath = IndexPath(row: columnIndex, section: 0)
        columnsDelegate?.changedColumnFilters()
        guard let column =  columnSettings?.object(at: UInt(columnIndex)) as? DataGridColumn,
            let cell = columnsTableView.cellForRow(at: columnIndexPath) as? ColumnsTableViewCell else {
                return
        }
        cell.filterImage.isHidden = column.columnFilters.filterList.count == 0
        columnsTableView.reloadData()
    }
    
    func changedAllFilters() {
        columnsDelegate?.changedColumnFilters()
        columnsTableView.reloadData()
    }
}

