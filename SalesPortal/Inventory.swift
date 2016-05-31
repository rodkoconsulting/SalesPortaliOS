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
        
        
        required init(dict: [String: AnyObject]?)
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
                return "ITEM_CODE='\(itemCode)'"
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
                return "(ITEM_CODE, QTY_AVAIL, QTY_OH, ON_SO, ON_MO, ON_BO) VALUES ('\(itemCode)', \(quantityAvailable), \(quantityOnHand), \(onSo), \(onMo), \(onBo))"
        }()
    }
    
    class InvPo: SyncRows {
        let itemCode: String?
        let poNo: String?
        let onPo: Double?
        let eta: String?
        let poDate: String?
        
        required init(dict: [String: AnyObject]?)
        {
            itemCode = dict?["Code"] as? String
            onPo = dict?["OnPo"] as? Double
            poNo = dict?["PoNo"] as? String
            eta = dict?["Eta"] as? String
            poDate = dict?["PoDate"] as? String
        }
        
        lazy var getDbDelete: String?  = {
            [unowned self] in
                guard let itemCode = self.itemCode,
                    let poNo = self.poNo else {
                    return nil
                }
                return "ITEM_CODE='\(itemCode)' and PO_NO='\(poNo)'"
        }()
        
         lazy var getDbInsert: String? = {
            [unowned self] in
                guard let itemCode = self.itemCode,
                    let poNo = self.poNo,
                    let onPo = self.onPo,
                    let eta = self.eta,
                    let poDate = self.poDate
                    else {
                        return nil
                }
                return "(ITEM_CODE, PO_NO, ON_PO, PO_ETA, PO_DATE) VALUES ('\(itemCode)', '\(poNo)', \(onPo), \(eta), \(poDate))"
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
        
        
        required init(dict: [String: AnyObject]?)
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
        }
        
        lazy var getDbDelete : String? = {
            [unowned self] in
                guard let itemCode = self.itemCode else {
                    return nil
                }
                return "ITEM_CODE='\(itemCode)'"
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
                    let scoreOther = self.scoreOther else {
                        return nil
                }
                return "(ITEM_CODE, DESC, BRAND, MASTER_VENDOR, VINTAGE, UOM, SIZE, DAMAGED_NOTES, CLOSURE, TYPE, VARIETAL, ORGANIC, BIODYNAMIC, FOCUS, COUNTRY, REGION, APPELLATION, RESTRICT_OFFSALE, RESTRICT_OFFSALE_NOTES, RESTRICT_PREMISE, RESTRICT_ALLOCATED, RESTRICT_APPROVAL, RESTRICT_MAX, RESTRICT_STATE, RESTRICT_SAMPLE, RESTRICT_BO, RESTRICT_MO, UPC, SCORE_WA, SCORE_WS, SCORE_IWC, SCORE_BH, SCORE_VM, SCORE_OTHER) VALUES ('\(itemCode)', '\(description)', '\(brand)', '\(masterVendor)', '\(vintage)', '\(uom)', '\(size)', '\(damagedNotes)', '\(closure)', '\(type)', '\(varietal)', '\(organic)', '\(biodynamic)', '\(focus)', '\(country)', '\(region)', '\(appellation)', '\(restrictOffSale)', '\(restrictOffSaleNotes)', '\(restrictPremise)', '\(restrictAllocate)','\(restrictApproval)', '\(restrictMax)', '\(restrictState)', '\(restrictSample)', '\(restrictBo)', '\(restrictMo)', '\(upc)', '\(scoreWa)', '\(scoreWs)', '\(scoreIwc)', '\(scoreBh)', '\(scoreVm)', '\(scoreOther)')"
            }()
    }

    class InvPrice: SyncRows {
        let itemCode: String?
        let priceLevel: String?
        let date: String?
        let priceDesc: String?
        
        required init(dict: [String: AnyObject]?)
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
                return "ITEM_CODE='\(itemCode)' AND PRICE_LEVEL='\(priceLevel)' AND DATE='\(date)'"
        }()
        
        lazy var getDbInsert : String? = {
            [unowned self] in
                guard let itemCode = self.itemCode,
                    let priceLevel = self.priceLevel,
                    let date = self.date,
                    let priceDesc = self.priceDesc else {
                        return nil
                }
                return "(ITEM_CODE, PRICE_LEVEL, DATE, PRICE_DESC) VALUES ('\(itemCode)', '\(priceLevel)', '\(date)', '\(priceDesc)')"
            }()
    }
    
struct InvSync {
    let qtySync: Sync<InvQty>
    let descSync: Sync<InvDesc>
    let priceSync: Sync<InvPrice>
    let poSync: Sync<InvPo>
    
    init(qtyDict: [String : AnyObject], descDict: [String : AnyObject], priceDict: [String : AnyObject], poDict: [String : AnyObject]) {
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
    
    init(queryResult: FMResultSet) {
            itemCode = queryResult.stringForColumn("item_code")
            purchaseOrderNo = queryResult.stringForColumn("po_no")
            onPo = queryResult.doubleForColumn("on_po")
            poEta = queryResult.stringForColumn("po_eta")
            poDate = queryResult.stringForColumn("po_date")
    }
}

class Inventory : NSObject {
    typealias priceBreakType = (priceCase: Double, discountCase: Double, priceBottle: Double, discountBottle: Double)
    typealias poDictType = [(onPo: Double, poEta: String, poDate: String)]
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
    let priceString: String
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
    
    lazy var focus : Bool = {
        [unowned self] in
            return self.focusRaw == "Y" ? true : false
    }()
    
    lazy var sizeDescription : String = {
        [unowned self] in
            let bottleSizeArray = self.size.characters.split(Int.max, allowEmptySlices: false, isSeparator: { $0 == " " }).map { String($0) }
            let sizeString = bottleSizeArray[0]
            let unitString = bottleSizeArray[1]
            return unitString == "L" ? "\(sizeString)\(unitString)" : sizeString
    }()
    
    lazy var uomString : String = {
        [unowned self] in
            return self.uom.stringByReplacingOccurrencesOfString("C", withString: "")
    }()

    lazy var itemDescription : String = {
        [unowned self] in
            return "\(self.brand) \(self.descriptionRaw) \(self.vintage) (\(self.uomString)/\(self.sizeDescription))\(self.damagedNotes)"
    }()
    
    lazy var priceArray : [String] = {
        [unowned self] in
            let priceStripped = self.priceString.stringByReplacingOccurrencesOfString(" ", withString: "")
            return priceStripped.characters.split {$0 == ","}.map { String($0) }
    }()
    
    lazy var priceBreaks : priceBreakType = {
        [unowned self] in
            let isBottlePrice = self.priceString.containsString("B")
            let uomInt = Int(self.uomString) ?? 12
            var priceTupleArray:[(price: Int, unit: Int)] = []
            let priceCaseTuple: (price: Double, discount: Double)
            for priceBreak in self.priceArray {
                let breakArray: [String]
                breakArray = priceBreak.containsString("/") ? priceBreak.characters.split{ $0 == "/" }.map { String($0) } : [priceBreak, "1"]
                let priceWrapped: Int? = Int(breakArray[0])
                let unitWrapped: Int?
                if isBottlePrice {
                    unitWrapped = breakArray[1] != "B" ? Int((breakArray[1].stringByReplacingOccurrencesOfString("B", withString: ""))) : 1
                } else {
                    unitWrapped = Int(breakArray[1])
                }
                if priceWrapped != nil && unitWrapped != nil {
                    let priceTuple = (priceWrapped!, unitWrapped!)
                    priceTupleArray.append(priceTuple)
                }
            }
            if priceTupleArray.isEmpty {
                priceCaseTuple = (0, 0)
            } else if !isBottlePrice {
                priceCaseTuple = (Double((priceTupleArray[0]).price), Double((priceTupleArray[priceTupleArray.count - 1]).price))
            } else {
                priceCaseTuple = (Double((priceTupleArray[0]).price * uomInt), Double((priceTupleArray[priceTupleArray.count - 1]).price * uomInt))
            }
            return (priceCase: priceCaseTuple.price, discountCase: priceCaseTuple.discount, priceBottle: priceCaseTuple.price/Double(uomInt), discountBottle:priceCaseTuple.discount/Double(uomInt))
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
            for (index, pricebreak) in self.priceArray.enumerate() {
                if index != 0 {
                    discountArray.append(pricebreak)
                }
            }
            return discountArray.joinWithSeparator(",")
    }()
    
    lazy var onPo : String = {
        [unowned self] in
            guard let onPo = self.poDict else {
                return "0"
            }
            var poString = ""
            for (index, po) in onPo.enumerate() {
                let onPoString = String(format: "%g", Double(round(100*po.onPo)/100))
                poString += "\(onPoString)"
                if index <  onPo.count - 1 {
                    poString += "\n"
                }
            }
            return poString
    }()

    
    private func getPoEta(isSort isSort: Bool) -> String {
        guard let onPo = poDict else {
            return ""
        }
        //let dateFormatterToDate:NSDateFormatter = NSDateFormatter()
        //dateFormatterToDate.dateFormat = "yyyyMMdd"
        var poEtaString = ""
        for (index, po) in onPo.enumerate() {
            //let date = dateFormatterToDate.dateFromString(po.poEta)
            let date = po.poEta.getDate()
            if let etaDate = date {
                //let year = Dates.getYearFromDate(date: etaDate)
                let year = etaDate.getYearInt()
                if year > 2000 {
                    //let dateFormatterToString:NSDateFormatter = NSDateFormatter()
                    //dateFormatterToString.dateFormat = "M/d/yy"
                    //poEtaString += dateFormatterToString.stringFromDate(etaDate)
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
            return self.getPoEta(isSort: false)
    }()
    
    lazy var poEtaSort : NSDate = {
        [unowned self] in
            let dateString = self.getPoEta(isSort: true)
            guard let sortDate = dateString.getGridDate() else {
                return NSDate.defaultPoEtaDate()
            }
            return sortDate
    }()
    
    private func getPoDate(isSort isSort: Bool) -> String {
        guard let onPo = poDict else {
            return ""
        }
        //let dateFormatterToDate:NSDateFormatter = NSDateFormatter()
        var minDate = NSDate.defaultPoDate()
        //dateFormatterToDate.dateFormat = "yyyyMMdd"
        var poDateString = ""
        for (index, po) in onPo.enumerate() {
            let date = po.poDate.getDate()
            //let date = dateFormatterToDate.dateFromString(po.poDate)
            if let poDate = date {
                let year = poDate.getYearInt()
                //let year = Dates.getYearFromDate(date: poDate)
                if year < 2000 {
                    poDateString += ""
                } else {
                    //let dateFormatterToString:NSDateFormatter = NSDateFormatter()
                    //dateFormatterToString.dateFormat = "M/d/yy"
                    //poDateString += dateFormatterToString.stringFromDate(poDate)
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
            //return Dates.getStringFromDate(date: minDate, format: "M/d/yy")
            return minDate.getDateGridString()
        } else {
            return poDateString
        }
    }
    
    lazy var poDate : String = {
        [unowned self] in
            return self.getPoDate(isSort: false)
    }()
    
    lazy var poDateSort : NSDate = {
        [unowned self] in
            let dateString = self.getPoDate(isSort: true)
            //guard let sortDate = Dates.getDateFromString(date: dateString, format: "M/d/yy") else {
            guard let sortDate = dateString.getGridDate() else {
                return NSDate.defaultPoDate()
            }
            return sortDate
    }()
    
    lazy var offSale : String = {
        [unowned self] in
            guard self.restrictOffSale == "Y" else {
                return ""
            }
            var offSaleString = "Offsale"
            if self.restrictOffSaleNotes.characters.count > 0 {
                offSaleString += "/\(self.restrictOffSaleNotes)"
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
            return self.restrictState.characters.count > 0 ? "\(self.restrictState); " : ""
    }()
    
    lazy var approval : String = {
        [unowned self] in
            guard self.restrictApproval.characters.count > 0 else {
                return ""
            }
            if self.restrictApproval=="SPECIAL ORDER" {
                return "\(self.restrictApproval); "
            } else if (self.restrictApproval as NSString).localizedCaseInsensitiveContainsString("Retail") {
                let retailApproval = self.restrictApproval.stringByReplacingOccurrencesOfString("Retail", withString: "")
                return "Retail Ask \(retailApproval); "
            } else {
                return "Ask \(self.restrictApproval); "
            }
    }()
    
    lazy var maxCases : String = {
        [unowned self] in
            guard let maxCasesInt = Int(self.restrictMax) where maxCasesInt > 0 else {
                return ""
            }
            return "\(self.restrictMax)c Max; "
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
            let restricted = "\(self.offSale)\(self.allocated)\(self.premise)\(self.state)\(self.approval)\(self.maxCases)\(self.noSample)\(self.noBackOrders)\(self.noMasterOrders)"
            guard restricted.characters.count > 0 else {
                return ""
            }
            return restricted[restricted.startIndex..<restricted.startIndex.advancedBy(restricted.characters.count - 2)]
    }()
    
    lazy var isRestricted : Bool = {
        [unowned self] in
        return self.restrictedList.characters.count > 0 && self.restrictedList != "NS"
    }()
    
    lazy var scoreWa : String = {
        [unowned self] in
            return self.scoreWaRaw.characters.count > 0 ? "\(self.scoreWaRaw)(WA);" : ""
    }()
    
    lazy var scoreWs : String = {
        [unowned self] in
            return self.scoreWsRaw.characters.count > 0 ? "\(self.scoreWsRaw)(WS);" : ""
    }()
    
    lazy var scoreIwc : String = {
        [unowned self] in
            return self.scoreIwcRaw.characters.count > 0 ? "\(self.scoreIwcRaw)(IWC);" : ""
    }()
    
    lazy var scoreBh : String = {
        [unowned self] in
            return self.scoreBhRaw.characters.count > 0 ? "\(self.scoreBhRaw)(BH);" : ""
    }()
    
    lazy var scoreVm : String = {
        [unowned self] in
            return self.scoreVmRaw.characters.count > 0 ? "\(self.scoreVmRaw)(VM);" : ""
    }()
    
    lazy var scoreOther : String  = {
        [unowned self] in
            return self.scoreOtherRaw.characters.count > 0 ? "\(self.scoreOtherRaw);" : ""
    }()
    
    lazy var scoreList : String  = {
        [unowned self] in
            let scores = "\(self.scoreWa)\(self.scoreWs)\(self.scoreIwc)\(self.scoreBh)\(self.scoreVm)\(self.scoreOther)"
            guard scores.characters.count > 0 else {
                return ""
            }
            return scores[scores.startIndex..<scores.startIndex.advancedBy(scores.characters.count - 1)]
    }()
    
    //lazy var getRowDataArray : [String] = {
    //    [unowned self] in
    //    var row : [String] = []
    //    let columnData = ColumnData()
    //    for column in columnData.data {
    //        if let columnProperty = column[kName] as? String,
    //            let columnValue = self.valueForKey(columnProperty) {
    //            row.append("\(columnValue)")
    //        }
    //    }
    //    return row
    //}()
    
    init(queryResult: FMResultSet?, poDict: [String:poDictType]?) {
        itemCode = queryResult?.stringForColumn("item_code") ?? ""
        self.poDict = poDict?[itemCode]
        quantityAvailable = queryResult?.doubleForColumn("qty_avail") ?? 0
        quantityOnHand = queryResult?.doubleForColumn("qty_oh") ?? 0
        onSo = queryResult?.doubleForColumn("on_so") ?? 0
        onMo = queryResult?.doubleForColumn("on_mo") ?? 0
        onBo = queryResult?.doubleForColumn("on_bo") ?? 0
        descriptionRaw = queryResult?.stringForColumn("desc") ?? ""
        brand = queryResult?.stringForColumn("brand") ?? ""
        masterVendor = queryResult?.stringForColumn("master_vendor") ?? ""
        vintage = queryResult?.stringForColumn("vintage") ?? ""
        uom = queryResult?.stringForColumn("uom") ?? ""
        size = queryResult?.stringForColumn("size") ?? ""
        damagedNotes = queryResult?.stringForColumn("damaged_notes") ?? ""
        closure = queryResult?.stringForColumn("closure") ?? ""
        type = queryResult?.stringForColumn("type") ?? ""
        varietal = queryResult?.stringForColumn("varietal") ?? ""
        organic = queryResult?.stringForColumn("organic") ?? ""
        biodynamic = queryResult?.stringForColumn("biodynamic") ?? ""
        focusRaw = queryResult?.stringForColumn("focus") ?? ""
        country = queryResult?.stringForColumn("country") ?? ""
        region = queryResult?.stringForColumn("region") ?? ""
        appellation = queryResult?.stringForColumn("appellation") ?? ""
        restrictOffSale = queryResult?.stringForColumn("restrict_offsale") ?? ""
        restrictOffSaleNotes = queryResult?.stringForColumn("restrict_offsale_notes") ?? ""
        restrictAllocated = queryResult?.stringForColumn("restrict_allocated") ?? ""
        restrictPremise = queryResult?.stringForColumn("restrict_premise") ?? ""
        restrictState = queryResult?.stringForColumn("restrict_state") ?? ""
        restrictApproval = queryResult?.stringForColumn("restrict_approval") ?? ""
        restrictMax = queryResult?.stringForColumn("restrict_max") ?? ""
        restrictSample = queryResult?.stringForColumn("restrict_sample") ?? ""
        restrictBo = queryResult?.stringForColumn("restrict_bo") ?? ""
        restrictMo = queryResult?.stringForColumn("restrict_mo") ?? ""
        date = queryResult?.stringForColumn("date") ?? ""
        priceString = queryResult?.stringForColumn("price_desc") ?? ""
        upc = queryResult?.stringForColumn("upc") ?? ""
        scoreWaRaw = queryResult?.stringForColumn("score_wa") ?? ""
        scoreWsRaw = queryResult?.stringForColumn("score_ws") ?? ""
        scoreVmRaw = queryResult?.stringForColumn("score_vm") ?? ""
        scoreIwcRaw = queryResult?.stringForColumn("score_iwc") ?? ""
        scoreBhRaw = queryResult?.stringForColumn("score_bh") ?? ""
        scoreOtherRaw = queryResult?.stringForColumn("score_other") ?? ""
    }
}
