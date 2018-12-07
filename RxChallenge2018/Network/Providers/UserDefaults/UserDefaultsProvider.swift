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
    
    private func customRequest(_ endpoint: Endpoint, customPath: [JSONSubscriptType]? = nil) -> Single<JSONDict> {
        return Observable<String>.create { [weak self] observer in
            if let value = self?.provider.string(forKey: endpoint.key) {
                observer.onNext(value)
                observer.onCompleted()
            } else {
                observer.onError(NetworkError.notFound)
            }
            return Disposables.create()
        }.asSingle().parseToJSON()
    }
    
    func request(_ endpoint: Endpoint) -> Single<JSONDict> {
        return customRequest(endpoint)
    }
    
    func requestDecodable<D: Decodable>(_ endpoint: Endpoint, customPath: [JSONSubscriptType]? = nil) -> Single<D> {
        return customRequest(endpoint, customPath: customPath).map(D.self, atKeyPath: customPath)
    }
    
    func saveData(_ data: JSONDict, for endpoint: Endpoint) {
        
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
}

//MARK: - Single<JSON, Response> extensions
private extension Single where TraitType == SingleTrait, Element == JSONDict {

    func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: [JSONSubscriptType]? = nil) -> Single<D> {
        return flatMap { result in
            var json = JSON(result)
            if let path = keyPath {
                json = json[path]
            }
            do {
                let data = try json.rawData()
                return .just(try JSONDecoder().decode(D.self, from: data))
            }
            catch {
                throw NetworkError.malformedJSON
            }
        }
    }
}
