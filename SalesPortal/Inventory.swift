	//
//  Inventory.swift
//  StormyNew
//
//  Created by administrator on 7/2/15.
//  Copyright (c) 2015 Polaner Selections. All rights reserved.
//

import Foundation
    
    
    class InvQty: SyncRows {
        let itemCode: String?
        let quantityAvailable: Double?
        let quantityOnHand: Double?
        let onSo: Double?
        let onMo: Double?
        let onBo: Double?
        
        
        required init(dict: [String: Any]?)
        {
            itemCode = dict?["Code"] as? String
            quantityAvailable = dict?["QtyA"] as? Double
            quantityOnHand = dict?["QtyOh"] as? Double
            onSo = dict?["OnSo"] as? Double
            onMo = dict?["OnMo"] as? Double
            onBo = dict?["OnBo"] as? Double
        }
        
        lazy var getDbDelete: String?  = {
            [unowned self] in
                guard let itemCode = self.itemCode else {
                    return nil
                }
                return "ITEM_CODE='" + itemCode + "'"
        }()
        
        
        lazy var getDbInsert: String? = {
            [unowned self] in
                guard let itemCode = self.itemCode,
                    let quantityAvailable = self.quantityAvailable,
                    let quantityOnHand = self.quantityOnHand,
                    let onSo = self.onSo,
                    let onMo = self.onMo,
                    let onBo = self.onBo else {
                        return nil
                }
                return "('" + itemCode + "', " + "\(quantityAvailable), \(quantityOnHand), \(onSo), \(onMo), \(onBo))"
        }()
        
    }
    
    class InvPo: SyncRows {
        let itemCode: String?
        let poNo: String?
        let onPo: Double?
        let eta: String?
        let poDate: String?
        let poComment: String?
        
        required init(dict: [String: Any]?)
        {
            itemCode = dict?["Code"] as? String
            onPo = dict?["OnPo"] as? Double
            poNo = dict?["PoNo"] as? String
            eta = dict?["Eta"] as? String
            poDate = dict?["PoDate"] as? String
            poComment = dict?["PoCmt"] as? String
        }
        
        lazy var getDbDelete: String?  = {
            [unowned self] in
                guard let itemCode = self.itemCode,
                    let poNo = self.poNo else {
                    return nil
                }
                return "ITEM_CODE='" + itemCode + "' and PO_NO='" + poNo + "'"
        }()
        
         lazy var getDbInsert: String? = {
            [unowned self] in
                guard let itemCode = self.itemCode,
                    let poNo = self.poNo,
                    let onPo = self.onPo,
                    let eta = self.eta,
                    let poDate = self.poDate,
                    let poComment = self.poComment
                    else {
                        return nil
                }
                return "('" + itemCode + "', '" + poNo + "', " + "\(onPo)" + ", '" + eta + "', '"  + poDate + "', '"  + poComment + "')"
        }()
        
    }
    
    
    class InvDesc: SyncRows {
        let itemCode: String?
        let description: String?
        let brand: String?
        let masterVendor: String?
        let vintage: String?
        let uom: String?
        let size: String?
        let damagedNotes: String?
        let closure: String?
        let type: String?
        let varietal: String?
        let organic: String?
        let biodynamic: String?
        let focus: String?
        let country: String?
        let region: String?
        let appellation: String?
        let restrictOffSale: String?
        let restrictOffSaleNotes: String?
        let restrictPremise: String?
        let restrictAllocate: String?
        let restrictApproval: String?
        let restrictMax: String?
        let restrictState: String?
        let restrictSample: String?
        let restrictBo: String?
        let restrictMo: String?
        let upc: String?
        let scoreWa: String?
        let scoreWs: String?
        let scoreIwc: String?
        let scoreBh: String?
        let scoreVm: String?
        let scoreOther: String?
        let receiptDate: String?
        
        
        required init(dict: [String: Any]?)
        {
            itemCode = dict?["Code"] as? String
            description = dict?["Desc"] as? String
            brand = dict?["Brand"] as? String
            masterVendor = dict?["MVendor"] as? String
            vintage = dict?["Vintage"] as? String
            uom = dict?["Uom"] as? String
            size = dict?["Size"] as? String
            damagedNotes = dict?["DamNotes"] as? String
            closure = dict?["Closure"] as? String
            type = dict?["Type"] as? String
            varietal = dict?["Varietal"] as? String
            organic = dict?["Org"] as? String
            biodynamic = dict?["Bio"] as? String
            focus = dict?["Focus"] as? String
            country = dict?["Country"] as? String
            region = dict?["Region"] as? String
            appellation = dict?["App"] as? String
            restrictOffSale = dict?["RstOff"] as? String
            restrictOffSaleNotes = dict?["RstOffNotes"] as? String
            restrictPremise = dict?["RstPrem"] as? String
            restrictAllocate = dict?["RstAllo"] as? String
            restrictApproval = dict?["RstApp"] as? String
            restrictMax = dict?["RstMax"] as? String
            restrictState = dict?["RstState"] as? String
            restrictSample = dict?["RstSam"] as? String
            restrictBo = dict?["RstBo"] as? String
            restrictMo = dict?["RstMo"] as? String
            upc = dict?["Upc"] as? String
            scoreWa = dict?["ScoreWA"] as? String
            scoreWs = dict?["ScoreWS"] as? String
            scoreIwc = dict?["ScoreIWC"] as? String
            scoreBh = dict?["ScoreBH"] as? String
            scoreVm = dict?["ScoreVM"] as? String
            scoreOther = dict?["ScoreOther"] as? String
            receiptDate = dict?["RcptDate"] as? String
        }
        
        lazy var getDbDelete : String? = {
            [unowned self] in
                guard let itemCode = self.itemCode else {
                    return nil
                }
                return "ITEM_CODE='" + itemCode + "'"
        }()
        
        lazy var getDbInsert : String? = {
            [unowned self] in
                guard let itemCode = self.itemCode,
                    let description = self.description,
                    let brand = self.brand,
                    let masterVendor = self.masterVendor,
                    let vintage = self.vintage,
                    let uom = self.uom,
                    let size = self.size,
                    let damagedNotes = self.damagedNotes,
                    let closure = self.closure,
                    let type = self.type,
                    let varietal = self.varietal,
                    let organic = self.organic,
                    let biodynamic = self.biodynamic,
                    let focus = self.focus,
                    let country = self.country,
                    let region = self.region,
                    let appellation = self.appellation,
                    let restrictOffSale = self.restrictOffSale,
                    let restrictOffSaleNotes = self.restrictOffSaleNotes,
                    let restrictPremise = self.restrictPremise,
                    let restrictAllocate = self.restrictAllocate,
                    let restrictApproval = self.restrictApproval,
                    let restrictMax = self.restrictMax,
                    let restrictState = self.restrictState,
                    let restrictSample = self.restrictSample,
                    let restrictBo = self.restrictBo,
                    let restrictMo = self.restrictMo,
                    let upc = self.upc,
                    let scoreWa = self.scoreWa,
                    let scoreWs = self.scoreWs,
                    let scoreIwc = self.scoreIwc,
                    let scoreBh = self.scoreBh,
                    let scoreVm = self.scoreVm,
                    let scoreOther = self.scoreOther,
                    let receiptDate = self.receiptDate else {
                        return nil
                }
                return "('" + itemCode + "', '" + description + "', '" + brand + "', '" + masterVendor + "', '" + vintage + "', '" + uom + "', '" + size + "', '" + damagedNotes + "', '" + closure + "', '" + type + "', '" + varietal + "', '" + organic + "', '" + biodynamic + "', '" + focus + "', '" + country + "', '" + region + "', '" + appellation + "', '" + restrictOffSale + "', '" + restrictOffSaleNotes + "', '" + restrictPremise + "', '" + restrictAllocate + "', '" + restrictApproval + "', '" + restrictMax + "', '" + restrictState + "', '" + restrictSample + "', '" + restrictBo + "', '" + restrictMo + "', '" + upc + "', '" + scoreWa + "', '" + scoreWs + "', '" + scoreIwc + "', '" + scoreBh + "', '" + scoreVm + "', '" + scoreOther + "', '" + receiptDate + "')"
            }()

    }

    class InvPrice: SyncRows {
        let itemCode: String?
        let priceLevel: String?
        let date: String?
        let priceDesc: String?
        
        required init(dict: [String: Any]?)
        {
            itemCode = dict?["Code"] as? String
            priceLevel = dict?["Level"] as? String
            date = dict?["Date"] as? String
            priceDesc = dict?["Desc"] as? String
        }
        
        lazy var getDbDelete : String? = {
            [unowned self] in
                guard let itemCode = self.itemCode,
                    let priceLevel = self.priceLevel,
                    let date = self.date else {
                    return nil
                }
                return "ITEM_CODE='" + itemCode + "' AND PRICE_LEVEL='" + priceLevel + "' AND DATE='" + date + "'"
        }()
        
        lazy var getDbInsert : String? = {
            [unowned self] in
                guard let itemCode = self.itemCode,
                    let priceLevel = self.priceLevel,
                    let date = self.date,
                    let priceDesc = self.priceDesc else {
                        return nil
                }
                return "('" + itemCode + "', '" + priceLevel + "', '" + date + "', '" + priceDesc + "')"
            }()
    }
    
struct InvSync {
    let qtySync: Sync<InvQty>
    let descSync: Sync<InvDesc>
    let priceSync: Sync<InvPrice>
    let poSync: Sync<InvPo>
    
    init(qtyDict: [String : Any], descDict: [String : Any], priceDict: [String : Any], poDict: [String : Any]) {
        qtySync = Sync<InvQty>(dict: qtyDict)
        descSync = Sync<InvDesc>(dict: descDict)
        priceSync = Sync<InvPrice>(dict: priceDict)
        poSync = Sync<InvPo>(dict: poDict)
    }
}

class InventoryPo {
    let itemCode: String
    let purchaseOrderNo: String
    let onPo: Double
    let poEta: String
    let poDate: String
    let poComment: String
    
    init(queryResult: FMResultSet) {
            itemCode = queryResult.string(forColumn: "item_code")
            purchaseOrderNo = queryResult.string(forColumn: "po_no")
            onPo = queryResult.double(forColumn: "on_po")
            poEta = queryResult.string(forColumn: "po_eta")
            poDate = queryResult.string(forColumn: "po_date")
            poComment = queryResult.string(forColumn: "po_cmt")
    }

}
    
@objcMembers
class Inventory : NSObject {
    typealias priceBreakType = (priceCase: Double, discountCase: Double, priceBottle: Double, discountBottle: Double)
    typealias poDictType = [(onPo: Double, poEta: String, poDate: String, poComment: String)]
    let poDict: poDictType?
    let itemCode: String
    let quantityAvailable: Double
    let quantityOnHand: Double
    let onSo: Double
    let onMo: Double
    let onBo: Double
    let brand: String
    let masterVendor: String
    let vintage: String
    let uom: String
    let size: String
    let closure: String
    let type: String
    let varietal: String
    let organic: String
    let biodynamic: String
    let focusRaw: String
    let descriptionRaw: String
    let damagedNotes: String
    var priceString: String
    let country: String
    let region: String
    let appellation: String
    let date: String
    let upc: String
    let restrictOffSale: String
    let restrictOffSaleNotes: String
    let restrictAllocated: String
    let restrictPremise: String
    let restrictState: String
    let restrictApproval: String
    let restrictMax: String
    let restrictSample: String
    let restrictBo: String
    let restrictMo: String
    let scoreWaRaw: String
    let scoreWsRaw: String
    let scoreIwcRaw: String
    let scoreBhRaw: String
    let scoreVmRaw: String
    let scoreOtherRaw: String
    let receiptDateString: String
    
    lazy var focus : Bool = {
        [unowned self] in
            return self.focusRaw == "Y" ? true : false
    }()
    
    lazy var sizeDescription : String = {
        [unowned self] in
            let bottleSizeArray = self.size.split(maxSplits: Int.max, omittingEmptySubsequences: true, whereSeparator: { $0 == " " }).map { String($0) }
            guard bottleSizeArray.count > 0 else {
                return ""
            }
            let sizeString = bottleSizeArray[0]
            let unitString = bottleSizeArray[1]
            return unitString == "L" ? sizeString + unitString : sizeString
    }()
    
    lazy var uomString : String = {
        [unowned self] in
            return self.uom.replacingOccurrences(of: "C", with: "")
    }()

    @objc lazy var itemDescription : String = {
        [unowned self] in
        guard !self.descriptionRaw.isEmpty else {
            return ""
        }
        return self.brand + " " + self.descriptionRaw + " " + self.vintage + " " + "(" + self.uomString + "/" + self.sizeDescription + ") " + self.damagedNotes
    }()
    
    lazy var mixDescription : String = {
        [unowned self] in
        return self.brand + self.descriptionRaw + self.vintage
        }()
    
    lazy var priceArray : [String] = {
        [unowned self] in
            let priceStripped = self.priceString.replacingOccurrences(of: " ", with: "")
            return priceStripped.split {$0 == ","}.map { String($0) }
    }()
    
    lazy var uomInt : Int = {
        [unowned self] in
        return Int(self.uomString) ?? 12
    }()
    
    lazy var bottleQuantityAvailable: Int = {
        [unowned self] in
        Int(round(self.quantityAvailable * Double(self.uomInt)))
    } ()

    lazy var backOrderQuantityAvailable: Int = {
        [unowned self] in
        guard self.onPoTotal >= self.onBo else {
            return 0
        }
        return Int(round((self.onPoTotal - self.onBo) * Double(self.uomInt)))
    }()
    
    
    lazy var getPriceTupleArray : [(price: Double, unit: Int)] = {
        [unowned self] in
        var tupleArray:[(price: Double, unit: Int)] = []
        for priceBreak in self.priceArray {
            let breakArray: [String]
            breakArray = priceBreak.contains("/") ? priceBreak.split{ $0 == "/" }.map { String($0) } : [priceBreak, "1"]
            let priceWrapped: Double? = Double(breakArray[0])
            let unitWrapped: Int?
            if self.isBottlePricing {
                unitWrapped = breakArray[1] != "B" ? Int((breakArray[1].replacingOccurrences(of: "B", with: ""))) : 1
            } else {
                unitWrapped = Int(breakArray[1])
            }
            if let price = priceWrapped, let unit = unitWrapped {
                tupleArray.append((price, unit))
            }
        }
        return tupleArray
    }()
    
    lazy var priceBreaks : priceBreakType = {
        [unowned self] in
        let priceCaseTuple: (price: Double, discount: Double)
            if self.getPriceTupleArray.isEmpty {
                priceCaseTuple = (0, 0)
            } else if !self.isBottlePricing {
                priceCaseTuple = (Double((self.getPriceTupleArray[0]).price), Double((self.getPriceTupleArray[self.getPriceTupleArray.count - 1]).price))
            } else {
                priceCaseTuple = ((self.getPriceTupleArray[0]).price * Double(self.uomInt), (self.getPriceTupleArray[self.getPriceTupleArray.count - 1]).price * Double(self.uomInt))
            }
            return (priceCase: priceCaseTuple.price, discountCase: priceCaseTuple.discount, priceBottle: priceCaseTuple.price/Double(self.uomInt), discountBottle:priceCaseTuple.discount/Double(self.uomInt))
    }()
    
   
    
    lazy var priceCase : Double = {
        [unowned self] in
            return self.priceBreaks.priceCase
    }()
    
    lazy var priceBottle : Double = {
        [unowned self] in
            return self.priceBreaks.priceBottle
    }()
    
    lazy var discountCase : Double = {
        [unowned self] in
            return self.priceBreaks.discountCase
    }()
    
    lazy var discountBottle : Double = {
        [unowned self] in
            return self.priceBreaks.discountBottle
    }()
    
    lazy var discountList : String = {
        [unowned self] in
            var discountArray:[String] = []
            for (index, pricebreak) in self.priceArray.enumerated() {
                if index != 0 {
                    discountArray.append(pricebreak)
                }
            }
            return discountArray.joined(separator: ",")
    }()
    
    lazy var onPo : String = {
        [unowned self] in
            guard let onPo = self.poDict else {
                return "0"
            }
            var poString = ""
            for (index, po) in onPo.enumerated() {
                let onPoString = String(format: "%g", Double(round(100*po.onPo)/100))
                poString += onPoString
                if index <  onPo.count - 1 {
                    poString += "\n"
                }
            }
            return poString
    }()
    
    lazy var poComment : String = {
        [unowned self] in
        guard let poDict = self.poDict else {
            return ""
        }
        var poComment = ""
        for (index, po) in poDict.enumerated() {
            poComment += po.poComment
            if index <  poDict.count - 1 {
                poComment += "\n"
            }
        }
        return poComment
        }()
    
    lazy var onPoTotal: Double = {
        [unowned self] in
        guard let onPo = self.poDict else {
            return 0
        }
        var poTotal = 0.0
        for po in onPo {
            poTotal += po.onPo
        }
        return poTotal
    }()

    
    func getPoEta(_ isSort: Bool) -> String  {
        guard let onPo = poDict else {
            return ""
        }
        var poEtaString = ""
        for (index, po) in onPo.enumerated() {
            let date = po.poEta.getDate()
            if let etaDate = date {
                let year = etaDate.getYearInt()
                if year > 2000 {
                    poEtaString += etaDate.getDateGridString()
                    if isSort {
                        return poEtaString
                    }
                }
            }
            if index <  onPo.count - 1 {
                poEtaString += "\n"
            }
        }
        return poEtaString
    }
    
    lazy var poEta : String = {
        [unowned self] in
            return self.getPoEta(false)
    }()
    
    lazy var poEtaSort : Date = {
        [unowned self] in
            let dateString = self.getPoEta(true)
            guard let sortDate = dateString.getGridDate() else {
                return Date.defaultPoEtaDate()
            }
            return sortDate as Date
    }()
    
    func getPoDate(_ isSort: Bool) -> String {
        guard let onPo = self.poDict else {
            return ""
        }
        var minDate = Date.defaultPoDate()
        var poDateString = ""
        for (index, po) in onPo.enumerated() {
            let date = po.poDate.getDate()
            if let poDate = date {
                let year = poDate.getYearInt()
                if year < 2000 {
                    poDateString += ""
                } else {
                    poDateString += poDate.getDateGridString()
                    if poDate.isGreaterThanDate(minDate) {
                        minDate = poDate
                    }
                }
            }
            if index <  onPo.count - 1 {
                poDateString += "\n"
            }
        }
        if isSort {
            return minDate.getDateGridString()
        } else {
            return poDateString
        }
    }
    
    lazy var poDate : String = {
        [unowned self] in
            return self.getPoDate(false)
    }()
    
    lazy var poDateSort : Date = {
        [unowned self] in
            let dateString = self.getPoDate(true)
            guard let sortDate = dateString.getGridDate() else {
                return Date.defaultPoDate()
            }
            return sortDate as Date
    }()
    
    
    lazy var receiptDate : Date? = {
        [unowned self] in
        guard let receiptDate = receiptDateString.getDate() else {
            return nil
        }
        return receiptDate
        }()
    
    lazy var offSale : String = {
        [unowned self] in
            guard self.restrictOffSale == "Y" else {
                return ""
            }
            var offSaleString = "Offsale"
            if self.restrictOffSaleNotes.count > 0 {
                offSaleString = offSaleString + "/" + self.restrictOffSaleNotes
            }
            offSaleString += "; "
            return offSaleString
    }()
    
    lazy var allocated : String = {
        [unowned self] in
            return self.restrictAllocated == "Y" ? "Alloc; " : ""
    }()
    
    lazy var premise : String = {
        [unowned self] in
            return self.restrictPremise == "Y" ? "On Prem; " : ""
    }()
    
    lazy var state : String = {
        [unowned self] in
            return self.restrictState.count > 0 ? self.restrictState + "; " : ""
    }()
    
    lazy var approval : String = {
        [unowned self] in
            guard self.restrictApproval.count > 0 else {
                return ""
            }
            if self.restrictApproval=="SPECIAL ORDER" {
                return self.restrictApproval + "; "
            } else if (self.restrictApproval as NSString).localizedCaseInsensitiveContains("Retail") {
                let retailApproval = self.restrictApproval.replacingOccurrences(of: "Retail", with: "")
                return "Retail Ask " + retailApproval + "; "
            } else {
                return "Ask " + self.restrictApproval + "; "
            }
    }()
    
    lazy var maxCases : String = {
        [unowned self] in
            guard let maxCasesInt = Int(self.restrictMax), maxCasesInt > 0 else {
                return ""
            }
            return self.restrictMax + "c Max; "
    }()
    
    lazy var noSample : String = {
        [unowned self] in
            return self.restrictSample == "Y" ? "NS; " : ""
    }()
    
    lazy var noBackOrders : String  = {
        [unowned self] in
            return self.restrictBo == "Y" ? "No BOs; " : ""
    }()
    
    lazy var noMasterOrders : String = {
        [unowned self] in
            return self.restrictMo == "Y" ? "No MOs; " : ""
    }()
    
    lazy var restrictedList : String = {
        [unowned self] in
            let restricted = self.offSale + self.allocated + self.premise + self.state + self.approval + self.maxCases + self.noSample + self.noBackOrders + self.noMasterOrders
            guard restricted.count > 0 else {
                return ""
            }
            return String(restricted[restricted.startIndex..<restricted.index(restricted.startIndex, offsetBy: restricted.count - 2)])
    }()
    
    lazy var isRestricted : Bool = {
        [unowned self] in
        return self.restrictedList.count > 0 && self.restrictedList != "NS"
    }()
    
    lazy var scoreWa : String = {
        [unowned self] in
            return self.scoreWaRaw.count > 0 ? self.scoreWaRaw + "(WA);" : ""
    }()
    
    lazy var scoreWs : String = {
        [unowned self] in
            return self.scoreWsRaw.count > 0 ? self.scoreWsRaw + "(WS);" : ""
    }()
    
    lazy var scoreIwc : String = {
        [unowned self] in
            return self.scoreIwcRaw.count > 0 ? self.scoreIwcRaw + "(IWC);" : ""
    }()
    
    lazy var scoreBh : String = {
        [unowned self] in
            return self.scoreBhRaw.count > 0 ? self.scoreBhRaw + "(BH);" : ""
    }()
    
    lazy var scoreVm : String = {
        [unowned self] in
            return self.scoreVmRaw.count > 0 ? self.scoreVmRaw + "(VM);" : ""
    }()
    
    lazy var scoreOther : String  = {
        [unowned self] in
            return self.scoreOtherRaw.count > 0 ? self.scoreOtherRaw + ";" : ""
    }()
    
    lazy var scoreList : String  = {
        [unowned self] in
            let scores = self.scoreWa + self.scoreWs + self.scoreIwc + self.scoreBh + self.scoreVm + self.scoreOther
            guard scores.count > 0 else {
                return ""
            }
            return String(scores[scores.startIndex..<scores.index(scores.startIndex, offsetBy: scores.count - 1)])
    }()
  
    lazy var getPricing:(Double) -> Double = {
        [unowned self] (quantity: Double) in
        guard self.hasPriceBreaks else {
            return self.isBottlePricing ? self.priceBottle : self.priceCase
        }
        let priceArray = self.getPriceTupleArray
        if let priceTuple = priceArray.filter({Double($0.unit) <= quantity}).last {
            return Double(priceTuple.price)
        }
        return self.priceCase
    }
    
    lazy var hasPriceBreaks : Bool = {
        [unowned self] in
       return self.discountList.count > 0
    }()
    
    lazy var isBottlePricing : Bool = {
        [unowned self] in
        return self.priceString.contains("B")
    }()
    
    init(queryResult: FMResultSet?, poDict: [String:poDictType]?) {
        itemCode = queryResult?.string(forColumn: "item_code") ?? ""
        self.poDict = poDict?[itemCode]
        quantityAvailable = queryResult?.double(forColumn: "qty_avail") ?? 0
        quantityOnHand = queryResult?.double(forColumn: "qty_oh") ?? 0
        onSo = queryResult?.double(forColumn: "on_so") ?? 0
        onMo = queryResult?.double(forColumn: "on_mo") ?? 0
        onBo = queryResult?.double(forColumn: "on_bo") ?? 0
        descriptionRaw = queryResult?.string(forColumn: "desc") ?? ""
        brand = queryResult?.string(forColumn: "brand") ?? ""
        masterVendor = queryResult?.string(forColumn: "master_vendor") ?? ""
        vintage = queryResult?.string(forColumn: "vintage") ?? ""
        uom = queryResult?.string(forColumn: "uom") ?? ""
        size = queryResult?.string(forColumn: "size") ?? ""
        damagedNotes = queryResult?.string(forColumn: "damaged_notes") ?? ""
        closure = queryResult?.string(forColumn: "closure") ?? ""
        type = queryResult?.string(forColumn: "type") ?? ""
        varietal = queryResult?.string(forColumn: "varietal") ?? ""
        organic = queryResult?.string(forColumn: "organic") ?? ""
        biodynamic = queryResult?.string(forColumn: "biodynamic") ?? ""
        focusRaw = queryResult?.string(forColumn: "focus") ?? ""
        country = queryResult?.string(forColumn: "country") ?? ""
        region = queryResult?.string(forColumn: "region") ?? ""
        appellation = queryResult?.string(forColumn: "appellation") ?? ""
        restrictOffSale = queryResult?.string(forColumn: "restrict_offsale") ?? ""
        restrictOffSaleNotes = queryResult?.string(forColumn: "restrict_offsale_notes") ?? ""
        restrictAllocated = queryResult?.string(forColumn: "restrict_allocated") ?? ""
        restrictPremise = queryResult?.string(forColumn: "restrict_premise") ?? ""
        restrictState = queryResult?.string(forColumn: "restrict_state") ?? ""
        restrictApproval = queryResult?.string(forColumn: "restrict_approval") ?? ""
        restrictMax = queryResult?.string(forColumn: "restrict_max") ?? ""
        restrictSample = queryResult?.string(forColumn: "restrict_sample") ?? ""
        restrictBo = queryResult?.string(forColumn: "restrict_bo") ?? ""
        restrictMo = queryResult?.string(forColumn: "restrict_mo") ?? ""
        date = queryResult?.string(forColumn: "date") ?? ""
        priceString = queryResult?.string(forColumn: "price_desc") ?? ""
        upc = queryResult?.string(forColumn: "upc") ?? ""
        scoreWaRaw = queryResult?.string(forColumn: "score_wa") ?? ""
        scoreWsRaw = queryResult?.string(forColumn: "score_ws") ?? ""
        scoreVmRaw = queryResult?.string(forColumn: "score_vm") ?? ""
        scoreIwcRaw = queryResult?.string(forColumn: "score_iwc") ?? ""
        scoreBhRaw = queryResult?.string(forColumn: "score_bh") ?? ""
        scoreOtherRaw = queryResult?.string(forColumn: "score_other") ?? ""
        receiptDateString = queryResult?.string(forColumn: "receipt_date") ?? ""
    }
}
