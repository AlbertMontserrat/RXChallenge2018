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
    
    private func customRequest(_ endpoint: Endpoint) -> Single<String> {
        return Observable<String>.create { [weak self] observer in
            if let value = self?.provider.string(forKey: endpoint.key) {
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
    
    func saveData(_ data: String, for endpoint: Endpoint) {
        provider.set(data, forKey: endpoint.key)
    }
}

//MARK: - Single<Response> extensions
private extension Single where TraitType == SingleTrait, Element == String {
    func parseToJSON() -> Single<JSONDict> {
        return flatMap { string in
            guard let json = JSON(stringLiteral: string).dictionaryObject else { throw NetworkError.malformedJSON }
            return .just(json)
        }
    }
    
    func parseToArray() -> Single<JSONArray> {
        return flatMap { string in
            guard let json = JSON(stringLiteral: string).arrayObject else { throw NetworkError.malformedJSON }
            return .just(json)
        }
    }
}
