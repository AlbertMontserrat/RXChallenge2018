import Foundation
import RxSwift
import SwiftyJSON

enum NetworkError: Error {
    case unauthorized
    case notFound
    case malformedJSON
    case noMoreElements
    case undefined
}

protocol NetworkProvider {
    func request(_ endpoint: Endpoint) -> Single<JSONDict>
    func requestDecodable<D: Decodable>(_ endpoint: Endpoint, customPath: [JSONSubscriptType]?) -> Single<D>
}

protocol NetworkCacheProvider {
    func request(_ endpoint: Endpoint) -> Single<JSONDict>
    func requestDecodable<D: Decodable>(_ endpoint: Endpoint, customPath: [JSONSubscriptType]?) -> Single<D>
    func saveData(_ data: JSONDict, for endpoint: Endpoint)
}
