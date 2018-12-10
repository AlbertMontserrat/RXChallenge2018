import RxChallengeDomain
import RxChallengeUtils
import RxSwift
import RxCocoa
import SwiftyJSON

public class UserDefaultsProvider: NetworkCacheProvider {
    static var shared = UserDefaultsProvider()
    private let provider: UserDefaults
    
    private init(provider: UserDefaults = UserDefaults.standard) {
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
    
    func requestDecodable<D: Decodable>(_ endpoint: Endpoint) -> Single<D> {
        return customRequest(endpoint).mapDecodable()
    }
    
    func saveData(_ data: Data, for endpoint: Endpoint) {
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
