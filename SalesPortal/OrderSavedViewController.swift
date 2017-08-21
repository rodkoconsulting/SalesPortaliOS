
import UIKit
import XuniFlexGridKit

class OrderSavedViewController: DataGridViewController {
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        moduleType = Module.orderSaved
        classType = OrderSavedList.self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(isSynched: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        flexGrid.saveUserDefaults(moduleType)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
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
            guard let orderSaved = row.dataItem as? OrderSavedList else {
                return false
            }
            showSavedOrderActionSheet(column: column, rowIndex: range.row, savedOrder: orderSaved, panel: panel, flexGrid: flexGrid)
        default:
            return false
        }
        return false
    }

    
    fileprivate func refreshData() {
        if isLoaded {
            loadData(isSynched: true)
        }
        isLoaded = true
    }
    
    override func loadData(isSynched: Bool) {
            self.gridData?.removeAllObjects()
            let orderSavedQuery = OrderSavedService<AccountOrder>.queryOrderSavedList()
            self.gridData = orderSavedQuery.gridData
            if let orderSavedSearchData = orderSavedQuery.searchData {
                self.searchData = orderSavedSearchData
            }
            if let collectionView = self.flexGrid.collectionView {
                collectionView.removeAllObjects()
            }
            if let itemsSource = self.flexGrid.itemsSource {
                itemsSource.removeAllObjects()
            }
            self.flexGrid.itemsSource = self.gridData
            self.isFilterChanged = false
            self.filterGridColumns(self.searchBar.text!, classType: self.classType)
    }
    
    
    func showSavedOrderActionSheet(column: DataGridColumn, rowIndex: Int32, savedOrder: OrderSavedList, panel: GridPanel, flexGrid: FlexGrid) {
        let actionSheet = UIAlertController(title: savedOrder.customerName, message: nil, preferredStyle: .actionSheet)
        let editButton = UIAlertAction(title: "Edit", style: .default) {
            [unowned self] (alert) -> Void in
            self.editOrder(savedOrder: savedOrder)
        }
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) {
            [unowned self] (alert) -> Void in
            self.deleteOrder(orderNo: savedOrder.orderNo)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in
        }
        let rect = panel.getCellRect(forRow: rowIndex, inColumn: column.index)
        actionSheet.addAction(editButton)
        actionSheet.addAction(deleteButton)
        actionSheet.addAction(cancelButton)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = flexGrid
            popoverController.sourceRect = rect
        }
        present(actionSheet, animated: true, completion: nil)
    }

    fileprivate func editOrder(savedOrder: OrderSavedList) {
        let orderSegue = OrderType(rawValue: savedOrder.orderTypeRaw) == OrderType.Sample ? Constants.sampleOrderSegue : Constants.accountOrderSegue
        performSegue(withIdentifier: orderSegue, sender: savedOrder.orderNo)
    }
    
    fileprivate func deleteOrder(orderNo: Int) {
        do {
            try OrderSavedService<AccountOrder>.deleteSavedOrder(orderNo: orderNo)
            refreshData()
        } catch {
            completionError(ErrorCode.dbError)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let orderNo = sender as? Int else {
            return
        }
        if segue.identifier == Constants.accountOrderSegue {
            guard let orderTabBarController = segue.destination as? OrderTabBarController else {
                return
            }
            orderTabBarController.order = OrderSavedService<AccountOrder>.queryOrderSaved(orderNo: orderNo)
        }
        if segue.identifier == Constants.sampleOrderSegue {
            guard let orderTabBarController = segue.destination as? OrderTabBarController else {
                return
            }
            orderTabBarController.order = OrderSavedService<SampleOrder>.queryOrderSaved(orderNo: orderNo)
        }
    }
}
