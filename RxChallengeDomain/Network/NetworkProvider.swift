import RxSwift
import SwiftyJSON

public protocol NetworkProvider {
    func requestDecodable<D: Codable>(_ endpoint: Endpoint, customPath: String?) -> Single<D>
}

public protocol NetworkCacheProvider {
    func requestDecodable<D: Codable>(_ endpoint: Endpoint) -> Single<D>
    func saveData(_ data: Data, for endpoint: Endpoint)
}
