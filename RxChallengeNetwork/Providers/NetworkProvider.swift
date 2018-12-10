import RxChallengeUtils
import RxSwift
import SwiftyJSON

protocol NetworkProvider {
    func request(_ endpoint: Endpoint) -> Single<JSONDict>
    func requestDecodable<D: Decodable>(_ endpoint: Endpoint, customPath: String?) -> Single<D>
    func requestDecodableArray<D: Decodable>(_ endpoint: Endpoint) -> Single<[D]>
}

protocol NetworkCacheProvider {
    func request(_ endpoint: Endpoint) -> Single<JSONDict>
    func requestDecodable<D: Decodable>(_ endpoint: Endpoint, customPath: String?) -> Single<D>
    func requestDecodableArray<D: Decodable>(_ endpoint: Endpoint) -> Single<[D]>
    func saveData(_ data: Data, for endpoint: Endpoint)
}
