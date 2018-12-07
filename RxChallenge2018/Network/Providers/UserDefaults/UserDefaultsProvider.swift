import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class UserDefaultsProvider: NetworkCacheProvider {
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
    
    func request(_ endpoint: Endpoint) -> Single<JSONDict> {
        return customRequest(endpoint).parseToJSON()
    }
    
    func requestDecodable<D: Decodable>(_ endpoint: Endpoint, customPath: [JSONSubscriptType]? = nil) -> Single<D> {
        return customRequest(endpoint).parseToJSON().map(D.self, atKeyPath: customPath)
    }
    
    func requestDecodableArray<D>(_ endpoint: Endpoint) -> PrimitiveSequence<SingleTrait, [D]> where D : Decodable {
        return customRequest(endpoint).parseToArray().map(D.self)
    }
    
    func saveData(_ data: Data, for endpoint: Endpoint) {
        provider.set(data, forKey: endpoint.key)
    }
}

//MARK: - Single<Response> extensions
private extension Single where TraitType == SingleTrait, Element == Data {
    func parseToJSON() -> Single<JSONDict> {
        return flatMap { data in
            guard let json = try JSON(data: data).dictionaryObject else { throw NetworkError.malformedJSON }
            return .just(json)
        }
    }
    
    func parseToArray() -> Single<JSONArray> {
        return flatMap { data in
            guard let json = try JSON(data: data).arrayObject else { throw NetworkError.malformedJSON }
            return .just(json)
        }
    }
}
