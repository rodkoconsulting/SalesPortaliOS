
import UIKit
import XuniFlexGridKit
import MessageUI

class OrderMobosViewController: DataGridViewController, OrderInventoryErrorDelegate {
    
    @IBOutlet weak var myTabBarItem: UITabBarItem!
    
    weak var order: AccountOrder?
    
    override func viewDidLoad() {
        guard let orderTabBarController = tabBarController as? OrderTabBarController else {
            return
        }
        order = orderTabBarController.order as? AccountOrder
        guard let order = order else {
            return
        }
        gridData = order.orderMobos
        searchData = order.moboSearchData
        super.viewDidLoad()
        flexGrid.selectionMode = currentSelectionMode
    }
    
    func saveOrderDelegate() {
        try! order?.saveOrder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        flexGrid.invalidate()
        if  isFilterChanged {
            filterRefresh()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        flexGrid.finishEditing(false)
        flexGrid.saveUserDefaults(moduleType)
    }
    
    override func cellDoubleTapped(_ sender: FlexGrid, panel: GridPanel, for range: GridCellRange!) -> Bool {
        guard let range = range else {
            return false
        }
        guard range.col >= 0 else {
            return false
        }
        guard let column = flexGrid.columns.object(at: UInt(range.col)) as? DataGridColumn else {
            return false
        }
        switch panel.cellType {
        case GridCellType.columnHeader:
            showFilterActionSheet(column: column, rowIndex: range.row, panel: panel)
        case GridCellType.cell:
            let row = flexGrid.rows.object(at: UInt(range.row))
            guard let mobo = row.dataItem as? MoboList else {
                return false
            }
            if isMoboException(moboDetail: mobo){
                sendAlert(ErrorCode.moboException)
                return false
            }
            if isBillHoldException(moboDetail: mobo){
                sendAlert(ErrorCode.billHoldException)
                return false
            }
            guard column.isReadOnly == true else {
                return false
            }
            showMoboActionSheet(column: column, rowIndex: row.index, mobo: mobo, panel: panel, flexGrid: flexGrid)
        default:
            return false
            
        }
        return false
    }
    
    func showMoboActionSheet(column: DataGridColumn, rowIndex: Int32, mobo: MoboList, panel: GridPanel, flexGrid: FlexGrid) {
        let actionSheet = UIAlertController(title: mobo.itemCode, message: nil, preferredStyle: .actionSheet)
        let shipAllButton = UIAlertAction(title: "Ship All", style: .default) {
            [unowned self] (alert) -> Void in
            self.moboShipAll(mobo: mobo)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in
        }
        let rect = panel.getCellRect(forRow: rowIndex, inColumn: column.index)
        actionSheet.addAction(shipAllButton)
        actionSheet.addAction(cancelButton)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = flexGrid
            popoverController.sourceRect = rect
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    fileprivate func moboShipAll(mobo: MoboList) {
        mobo.delegate = order
        mobo.shipAll()
        flexGrid.invalidate()
    }
   
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        moduleType = Module.orderMobos
        classType = MoboList.self
    }
    
    override func initGrid() {
        super.initGrid()
        flexGrid.isReadOnly = false
        filterGrid("")
    }
    
    override func setItemLabels(selectedRow: Int32) {
        guard selectedRow >= 0 && UInt(selectedRow) < flexGrid.rows.count else {
            return
        }
        let flexRow = flexGrid.rows.object(at: UInt(selectedRow))
        let inventory = flexRow.dataItem as! MoboList
        if descriptionLabel != nil {
            descriptionLabel.text = inventory.itemDescription
        }
    }
    
    
    func beginningEdit(_ sender: FlexGrid, panel: GridPanel, for range: GridCellRange) -> Bool {
        let flexRow = flexGrid.rows.object(at: UInt(range.row))
        guard let moboDetail = flexRow.dataItem as? MoboList else {
                return false
        }
        if isMoboException(moboDetail: moboDetail){
            sendAlert(ErrorCode.moboException)
            return true
        }
        if isBillHoldException(moboDetail: moboDetail){
            sendAlert(ErrorCode.billHoldException)
            return true
        }
        moboDetail.delegate = order
        activeField = panel.getCellRect(forRow: range.row, inColumn: range.col)
        return false
    }
    
    func cellEditEnding(_ sender: FlexGrid!, panel: GridPanel!, for range: GridCellRange!, cancel: Bool) -> Bool {
        activeField = nil
        return false
    }
    
    fileprivate func isMoboException(moboDetail: MoboList) -> Bool {
        return order?.orderType != .Standard && moboDetail.price > 0
    }
    
    fileprivate func isBillHoldException(moboDetail: MoboList) -> Bool {
        return (order?.orderType != .BillHold && moboDetail.price == 0) || (order?.orderType == .BillHold && moboDetail.price > 0) || (order?.orderType != .BillHold && moboDetail.orderType == "BH")
    }

}
