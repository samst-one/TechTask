import Foundation

public enum NetworkError: LocalizedError {
    case errorOccured
    case unauthorized
    case invalidAuth
    case malformedUrl

    public var errorDescription: String? {
        switch self {
            case .errorOccured:
                return "An unknown error has occured."
            case .unauthorized:
                return "Your authentication credentials are invalid"
            case .invalidAuth:
                return "Your authentication failed, probably because the access token has expired, or you tried to access a resource outside the scope of the token."
            case .malformedUrl:
                return "The URL could not be built for this request."
        }
    }
}
