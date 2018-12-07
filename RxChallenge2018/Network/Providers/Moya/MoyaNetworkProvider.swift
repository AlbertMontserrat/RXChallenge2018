import Foundation
import Moya
import RxSwift
import SwiftyJSON

class MoyaNetworkProvider: NetworkProvider, PluginType {
    static var shared = MoyaNetworkProvider()
    private let provider: MoyaProvider<Endpoint>
    private let cacheProvider: NetworkCacheProvider

    private init(provider: MoyaProvider<Endpoint> = MoyaProvider<Endpoint>(), cacheProvider: NetworkCacheProvider = UserDefaultsProvider.shared) {
        self.provider = provider
        self.cacheProvider = cacheProvider
    }
    
    private func customRequest(_ endpoint: Endpoint) -> Single<Response> {
        return provider.rx.request(endpoint)
            .handleError()
            .cacheResponse(endpoint: endpoint, cacheProvider: cacheProvider)
    }
    
    func request(_ endpoint: Endpoint) -> Single<JSONDict> {
        return customRequest(endpoint)
            .parseToJSON()
            .catchError({ [weak self] error -> PrimitiveSequence<SingleTrait, JSONDict> in
                guard let cacheProvider = self?.cacheProvider else { throw error }
                guard let error = error as? NetworkError else {
                    return cacheProvider.request(endpoint)
                }
                throw error
            })
    }
    
    func requestDecodable<D: Decodable>(_ endpoint: Endpoint, customPath: [JSONSubscriptType]? = nil) -> Single<D> {
        return customRequest(endpoint)
            .parseToJSON()
            .map(D.self, atKeyPath: customPath)
            .catchError({ [weak self] error -> PrimitiveSequence<SingleTrait, D> in
                guard let cacheProvider = self?.cacheProvider else { throw error }
                return cacheProvider.requestDecodable(endpoint, customPath: customPath)
            })
    }
    
    func requestDecodableArray<D>(_ endpoint: Endpoint) -> PrimitiveSequence<SingleTrait, [D]> where D : Decodable {
        return customRequest(endpoint)
            .parseToArray()
            .map(D.self)
            .catchError({ [weak self] error -> PrimitiveSequence<SingleTrait, [D]> in
                guard let cacheProvider = self?.cacheProvider else { throw error }
                return cacheProvider.requestDecodableArray(endpoint)
            })
    }
}

//MARK: - Endpoint Moya extension
extension Endpoint: TargetType {
    var method: Moya.Method {
        switch httpMethod {
        case .options:
            return .options
        case .get:
            return .get
        case .head:
            return .head
        case .post:
            return .post
        case .put:
            return .put
        case .patch:
            return .patch
        case .delete:
            return .delete
        case .trace:
            return .trace
        case .connect:
            return .connect
        }
    }
    
    var task: Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: parametersEncoding)
        } else {
            return .requestPlain
        }
    }
}

//MARK: - Single<Response> extensions
private extension Single where TraitType == SingleTrait, Element == Response {
    func parseToJSON() -> Single<JSONDict> {
        return flatMap { response in
            guard let json = try response.mapJSON() as? JSONDict else { throw NetworkError.malformedJSON }
            return .just(json)
        }
    }
    
    func parseToArray() -> Single<JSONArray> {
        return flatMap { response in
            guard let json = try response.mapJSON() as? JSONArray else { throw NetworkError.malformedJSON }
            return .just(json)
        }
    }
    
    func handleError() -> Single<Response> {
        return flatMap { response in
            switch response.statusCode {
            case 200..<300: return .just(response)
            case 401: throw NetworkError.unauthorized
            case 404: throw NetworkError.notFound
            case 422: throw NetworkError.noMoreElements
            default: throw NetworkError.undefined
            }
        }
    }
    
    func cacheResponse(endpoint: Endpoint, cacheProvider: NetworkCacheProvider) -> Single<Response> {
        return self.do(onSuccess: {
            cacheProvider.saveData($0.data, for: endpoint)
        })
    }
}
