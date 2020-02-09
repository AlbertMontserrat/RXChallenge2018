import RxChallengeDomain
import RxChallengeUtils
import RxSwift
import RxCocoa
import SwiftyJSON

protocol DataStorage {
    func data(forKey defaultName: String) -> Data?
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: DataStorage {}

public class UserDefaultsProvider: NetworkCacheProvider {
    static var shared = UserDefaultsProvider()
    private let provider: DataStorage
    
    private init(provider: DataStorage = UserDefaults.standard) {
        self.provider = provider
    }
    
    private func customRequest(_ endpoint: Endpoint) -> Single<Data> {
        return Observable<Data>.create { [weak self] observer in
            if let value = self?.provider.data(forKey: endpoint.key) {
                observer.onNext(value)
                observer.onCompleted()
            } else {
                observer.onError(NetworkError.notFound)
            }
            return Disposables.create()
        }.asSingle()
    }
    
    public func requestDecodable<D: Decodable>(_ endpoint: RxChallengeDomain.Endpoint) -> Single<D> {
        return customRequest(endpoint).mapDecodable()
    }
    
    public func saveData(_ data: Data, for endpoint: RxChallengeDomain.Endpoint) {
        provider.set(data, forKey: endpoint.key)
    }
}

//MARK: - Single<Response> extensions
private extension Single where TraitType == SingleTrait, Element == Data {
    func mapDecodable<D: Decodable>() -> Single<D> {
        return map {
            guard let decoded = try? JSONDecoder().decode(D.self, from: $0) else { throw NetworkError.malformedJSON }
            return decoded
        }
    }
}

//MARK - Cache extension
private extension RxChallengeDomain.Endpoint {
    var key: String {
        return [httpMethod.rawValue, host.url.absoluteString, path, String(describing: parameters ?? [:])].joined(separator: "|")
    }
}
