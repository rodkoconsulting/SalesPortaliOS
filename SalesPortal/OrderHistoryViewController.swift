
import UIKit
import XuniFlexGridKit
import MessageUI

class OrderHistoryViewController: DataGridViewController, OrderInventoryErrorDelegate {
    
    @IBOutlet weak var myTabBarItem: UITabBarItem!
    
    weak var order: isOrderType?
    
    override func viewDidLoad() {
        guard let orderTabBarController = tabBarController as? OrderTabBarController else {
            return
        }
        order = orderTabBarController.order
        initData()
        super.viewDidLoad()
        setTitleLabel()
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
    
//    override func handleLongPress(sender: UILongPressGestureRecognizer) {
//        let pressedPoint = sender.locationInView(flexGrid)
//        let hit = GridHitTestInfo(grid: flexGrid, atPoint: pressedPoint)
//        guard hit.column >= 0 else {
//            return
//        }
//        if sender.state == UIGestureRecognizerState.Began && hit.cellType == GridCellType.ColumnHeader {
//            guard let column = flexGrid.columns.objectAtIndex(UInt(hit.column)) as? DataGridColumn else {
//                return
//            }
//            showFilterActionSheet(column: column, rowIndex: hit.row, panel: hit.gridPanel, flexGrid: flexGrid)
//        }
//    }
    
    override func setItemLabels(selectedRow: Int32) {
        guard selectedRow >= 0 && UInt(selectedRow) < flexGrid.rows.count else {
            return
        }
        let flexRow = flexGrid.rows.objectAtIndex(UInt(selectedRow)) as! GridRow
        let inventory = flexRow.dataItem as! Inventory
        if descriptionLabel != nil {
            descriptionLabel.text = inventory.itemDescription
            restrictionLabel.text = inventory.restrictedList
        }
    }
    
    override func clearItemLabels() {
        descriptionLabel.text = ""
        restrictionLabel.text = ""
    }
    
    func initData() {
        guard let order = order else {
            return
        }
        gridData = order.orderInventory
        searchData = order.searchData
    }
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        self.moduleType = Module.OrderHistory
//        self.classType = OrderInventory.self
//    }
    
    

    override func setTitleLabel() {
        if let order = order, let account = order.account {
            let accountState = account.priceLevel
            let orderMonth = order.shipDate?.getDate()?.getMonthString() ?? Date().getMonthString()
            titleLabel.text = accountState.labelText() + " " + orderMonth
        }
    }
    
    override func initGrid() {
        super.initGrid()
        flexGrid.isReadOnly = false
        flexGrid.sortColumns()
        filterGrid("")
    }

    
    override func filterGridColumns<T: NSObject>(_ searchText: String?, classType: T.Type, isIndex: Bool = false) {
        guard let collectionView = flexGrid.collectionView else {
            return
        }
        collectionView.filter = {[unowned self](item : NSObject?) -> Bool in
            guard let row = item as? OrderInventory else {
                return false
            }
            guard !isIndex else {
                return self.flexGrid.filterIndex(searchText, row: row, moduleType: self.moduleType) && self.flexGrid.filterColumns(nil, row: row)
            }
            guard row.lastQuantity > 0 else {
                let index = self.searchData.indexOf {
                    if let value = $0["DisplaySubText"], value == row.itemCode {
                        return true
                    }
                    return false
                }
                if let index = index {
                    self.searchData.removeAtIndex(index)
                }
                return false
            }
            return self.flexGrid.filterColumns(searchText, row: row)
            } as IXuniPredicate
        resetGrid()
    }
    
    func setAccountInventoryDelegate(_ orderInventory: OrderInventory) {
        // implement in child
        }
    
    func beginningEdit(_ sender: FlexGrid!, panel: GridPanel!, forRange range: GridCellRange!) -> Bool {
        guard panel != nil else {
            return false
        }
        guard let flexRow = flexGrid.rows.objectAtIndex(UInt(range.row)) as? GridRow,
            let inventory = flexRow.dataItem as? OrderInventory else {
                return false
        }
        activeField = panel.getCellRectForRow(range.row, inColumn: range.col)
        inventory.errorDelegate = self
        setAccountInventoryDelegate(inventory)
        return false
    }
    
    func cellEditEnding(_ sender: FlexGrid!, panel: GridPanel!, forRange range: GridCellRange!, cancel: Bool) -> Bool {
        activeField = nil
        
        return false
    }
    
    
}
