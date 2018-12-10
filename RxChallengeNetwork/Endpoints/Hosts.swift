import Foundation

enum Hosts {
    case typicode
    
    func getBaseURL() -> URL {
        var baseURL: String {
            switch self {
            case .typicode: return "https://jsonplaceholder.typicode.com"
            }
        }
        guard let url = URL(string: baseURL) else { fatalError() }
        return url
    }
}
