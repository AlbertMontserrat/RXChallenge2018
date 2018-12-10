import RxChallengeUtils
import RxSwift
import SwiftyJSON

protocol NetworkProvider {
    func requestDecodable<D: Codable>(_ endpoint: Endpoint, customPath: String?) -> Single<D>
}

protocol NetworkCacheProvider {
    func requestDecodable<D: Codable>(_ endpoint: Endpoint) -> Single<D>
    func saveData(_ data: Data, for endpoint: Endpoint)
}
