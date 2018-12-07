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
    func request(_ target: Endpoint) -> Single<JSONDict>
    func requestDecodable<D: Decodable>(_ target: Endpoint, customPath: [JSONSubscriptType]?) -> Single<D>
}
