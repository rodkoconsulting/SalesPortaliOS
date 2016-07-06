
import Foundation

enum ErrorCode: CustomStringConvertible, ErrorType {
    case NoInternet
    case HttpError(statusCode: Int)
    case DbError
    case ServerError
    case UnknownError
    case NoCredentials
    case NoQuantity(itemCode: String)
    
    var description: String {
        switch self {
        case .NoInternet:
            return "No internet connection"
        case .HttpError(let statusCode):
            switch statusCode {
            case 401:
                return "Invalid username / password"
            default:
                return "Server unavailable"
            }
        case .ServerError:
            return "No Internet connection"
        case .DbError:
            return "Invalid data"
        case .UnknownError:
            return "Unknown error encountered"
        case .NoCredentials:
            return "Invalid username / password"
        case .NoQuantity(let itemCode):
            return "\(itemCode): Insufficient quantity available"
        }
        

    }
    
    func isAuthError() -> Bool {
        switch self {
        case .HttpError(statusCode: 401):
            return true;
        default:
            return false;
        }
    }
}
