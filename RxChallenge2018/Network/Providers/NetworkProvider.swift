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
    func requestDecodableArray<D: Decodable>(_ endpoint: Endpoint) -> Single<[D]>
}

protocol NetworkCacheProvider {
    func request(_ endpoint: Endpoint) -> Single<JSONDict>
    func requestDecodable<D: Decodable>(_ endpoint: Endpoint, customPath: [JSONSubscriptType]?) -> Single<D>
    func requestDecodableArray<D: Decodable>(_ endpoint: Endpoint) -> Single<[D]>
    func saveData(_ data: Data, for endpoint: Endpoint)
}
