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
    
    private func customRequest(_ endpoint: Endpoint, customPath: [JSONSubscriptType]? = nil) -> Single<(JSONDict, Response)> {
        return provider.rx.request(endpoint)
            .parseToJSON()
            .cacheResponse(endpoint: endpoint, cacheProvider: cacheProvider)
            .handleError()
    }
    
    func request(_ endpoint: Endpoint) -> Single<JSONDict> {
        return customRequest(endpoint)
            .extractJSON()
            .catchError({ [weak self] error -> PrimitiveSequence<SingleTrait, JSONDict> in
                guard let cacheProvider = self?.cacheProvider else { throw error }
                guard let error = error as? NetworkError else {
                    return cacheProvider.request(endpoint)
                }
                throw error
            })
    }
    
    func requestDecodable<D: Decodable>(_ endpoint: Endpoint, customPath: [JSONSubscriptType]? = nil) -> Single<D> {
        return customRequest(endpoint, customPath: customPath)
            .map(D.self, atKeyPath: customPath)
            .catchError({ [weak self] error -> PrimitiveSequence<SingleTrait, D> in
                guard let cacheProvider = self?.cacheProvider else { throw error }
                guard let error = error as? NetworkError else {
                    return cacheProvider.requestDecodable(endpoint, customPath: customPath)
                }
                throw error
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
    func parseToJSON() -> Single<(JSONDict, Response)> {
        return flatMap { response in
            guard let json = try response.mapJSON() as? JSONDict else { throw NetworkError.malformedJSON }
            return .just((json, response))
        }
    }
}

//MARK: - Single<JSON, Response> extensions
private extension Single where TraitType == SingleTrait, Element == (JSONDict, Response) {
    
    func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: [JSONSubscriptType]? = nil) -> Single<D> {
        return flatMap { result in
            var json = JSON(result.0)
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
    
    func extractJSON() -> Single<JSONDict> {
        return map { $0.0 }
    }
    
    func handleError() -> Single<(JSONDict, Response)> {
        return flatMap { json, response in
            switch response.statusCode {
            case 401: throw NetworkError.unauthorized
            case 404: throw NetworkError.notFound
            case 422: throw NetworkError.noMoreElements
            default: return .just((json, response))
            }
        }
    }
    
    func cacheResponse(endpoint: Endpoint, cacheProvider: NetworkCacheProvider) -> Single<(JSONDict, Response)> {
        return self.do(onSuccess: { cacheProvider.saveData($0.0, for: endpoint) })
    }
}
