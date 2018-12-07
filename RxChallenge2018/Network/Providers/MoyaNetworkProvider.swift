import Foundation
import Moya
import RxSwift
import SwiftyJSON

class MoyaNetworkProvider: NetworkProvider, PluginType {
    static var shared = MoyaNetworkProvider()
    private let provider: MoyaProvider<Endpoint>

    private init(provider: MoyaProvider<Endpoint> = MoyaProvider<Endpoint>()) {
        self.provider = provider
    }
    
    private func customRequest(_ target: Endpoint, customPath: [JSONSubscriptType]? = nil) -> Single<(JSONDict, Response)> {
        return provider.rx.request(target)
            .parseToJSON()
            .handleError()
    }
    
    func request(_ target: Endpoint) -> Single<JSONDict> {
        return customRequest(target).extractJSON()
    }
    
    func requestDecodable<D: Decodable>(_ target: Endpoint, customPath: [JSONSubscriptType]? = nil) -> Single<D> {
        return customRequest(target, customPath: customPath).map(D.self, atKeyPath: customPath)
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
            catch let error {
                print(error.localizedDescription)
                throw NetworkError.malformedJSON
            }
        }
    }
    
    func extractJSON() -> Single<JSONDict> {
        return map({$0.0})
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
}
