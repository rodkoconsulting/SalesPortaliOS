
import Foundation

enum InvoiceListFilter: String {
    case Mtd = "MTD"
    case Ytd = "YTD"
    case OneYear = "1 YR"
    
    static let rawValues = [Mtd.rawValue, Ytd.rawValue, OneYear.rawValue]
}
