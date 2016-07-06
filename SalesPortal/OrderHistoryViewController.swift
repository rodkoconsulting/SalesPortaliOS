
import UIKit
import XuniFlexGridKit
import MessageUI

class OrderHistoryViewController: DataGridViewController, ColumnsDelegate, OrderInventoryErrorDelegate {
    
    weak var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let orderTabBarController = self.tabBarController as? OrderTabBarController,
            let order = orderTabBarController.order else {
                return
        }
        gridData = order.orderInventory
        searchData = order.searchData
        initGrid()
        setTitleLabel()
        longPressInitialize(flexGrid)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        flexGrid.invalidate()
        if  isFilterChanged {
            filterRefresh()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        flexGrid.finishEditing(false)
        flexGrid.saveUserDefaults(moduleType)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showColumnsViewController" {
            guard let columnsViewController = segue.destinationViewController as? ColumnsViewController else {
                return
            }
            columnsViewController.columnsDelegate = self
            columnsViewController.columnSettings = flexGrid.columns
            columnsViewController.module = moduleType
        }
        if segue.identifier == "showFiltersViewController" {
            segueFiltersViewController(segue: segue, sender: sender)
        }
    }
    
    override func handleLongPress(sender: UILongPressGestureRecognizer) {
        let pressedPoint = sender.locationInView(flexGrid)
        let hit = FlexHitTestInfo(grid: flexGrid, atPoint: pressedPoint)
        if sender.state == UIGestureRecognizerState.Began && hit.cellType == FlexCellType.ColumnHeader {
            guard let column = flexGrid.columns.objectAtIndex(UInt(hit.column)) as? GridColumn else {
                return
            }
            showFilterActionSheet(column: column, rowIndex: hit.row, panel: hit.gridPanel, flexGrid: flexGrid)
        }
    }
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        self.moduleType = Module.OrderHistory
//        self.classType = OrderInventory.self
//    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.moduleType = Module.OrderHistory
        self.classType = OrderInventory.self
    }

    override func setTitleLabel() {
        if let order = order {
            let accountState = order.account.priceLevel
            let orderMonth = order.shipDate.getDate()?.getMonthString() ?? NSDate().getMonthString()
            titleLabel.text = "\(accountState) \(orderMonth) pricing"
        }
    }
    
    override func initGrid() {
        flexGrid.isReadOnly = false
        flexGrid.delegate = self
        flexGrid.gridLayout(moduleType)
        flexGrid.itemsSource = gridData
        flexGrid.sortColumns()
        filterGrid("")
    }
    
    
    override func filterGridColumns<T: NSObject>(searchText: String?, classType: T.Type, isIndex: Bool = false) {
        flexGrid.collectionView.filter = {(item : NSObject?) -> Bool in
            guard let row = item as? OrderInventory else {
                return false
            }
            guard row.lastQuantity > 0 else {
                let index = self.searchData.indexOf {
                    if let value = $0["DisplaySubText"] as? String where value == row.itemCode {
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
    
    
    
    func beginningEdit(sender: FlexGrid!, panel: FlexGridPanel!, forRange range: FlexCellRange!) -> Bool {
        guard let flexRow = flexGrid.rows.objectAtIndex(UInt(range.row)) as? FlexRow,
            let inventory = flexRow.dataItem as? OrderInventory else {
                return false
        }
        let viewRange = flexGrid.viewRange
        let topRow = viewRange.row2 != viewRange.row ? viewRange.row + 1 :  viewRange.row
        topCell = panel.getCellRectForRow(topRow, inColumn: range.col)
        //activeHeader = headerPanel.getCellRectForRow(1, inColumn: range.col)
        activeField = panel.getCellRectForRow(range.row, inColumn: range.col)
        
        //flexGrid.scrollRowIntoView(range.row, forColumn: range.col)
        //if inventory.delegate == nil {
        inventory.errorDelegate = self
        inventory.delegate = order
        inventory.orderType = order?.orderType
        //}
        return false
    }
    
    func cellEditEnding(sender: FlexGrid!, panel: FlexGridPanel!, forRange range: FlexCellRange!, cancel: Bool) -> Bool {
        activeField = nil
        topCell = nil
        return false
    }
    
    
}