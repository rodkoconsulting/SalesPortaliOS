
import Foundation

enum ErrorCode: CustomStringConvertible, Error {
    case noInternet
    case httpError(statusCode: Int)
    case dbError
    case dbErrorSave
    case serverError
    case unknownError
    case noCredentials
    case noQuantity(itemCode: String)
    case moboException
    case billHoldException
    
    var description: String {
        switch self {
        case .noInternet:
            return "No Internet connection"
        case .httpError(let statusCode):
            switch statusCode {
            case 401:
                return "Invalid username / password"
            default:
                return "Server unavailable"
            }
        case .serverError:
            return "No Internet connection"
        case .dbError:
            return "Invalid data"
        case .dbErrorSave:
            return "Unable to save data.  Please resync"
        case .unknownError:
            return "Unknown error encountered"
        case .noCredentials:
            return "Invalid username / password"
        case .noQuantity(let itemCode):
            return itemCode + ": Insufficient quantity available"
        case .moboException:
            return "Can only ship MOBOs on Standard Orders"
        case .billHoldException:
            return "Can only ship Bill and Hold items on Bill and Hold orders"
        }
        

    }
    
    var isAuthError: Bool {
        switch self {
        case .httpError(statusCode: 401):
            return true;
        default:
            return false;
        }
    }
}
