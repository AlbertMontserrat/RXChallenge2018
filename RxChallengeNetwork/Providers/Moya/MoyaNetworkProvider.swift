import RxChallengeDomain
import RxChallengeUtils
import Moya
import RxSwift
import SwiftyJSON

public class MoyaNetworkProvider: NetworkProvider {
    public static var shared = MoyaNetworkProvider()
    private let provider: MoyaProvider<Endpoint>
    private let cacheProvider: NetworkCacheProvider

    private init(provider: MoyaProvider<Endpoint> = MoyaProvider<Endpoint>(), cacheProvider: NetworkCacheProvider = UserDefaultsProvider.shared) {
        self.provider = provider
        self.cacheProvider = cacheProvider
    }
    
    func requestDecodable<D>(_ endpoint: Endpoint, customPath: String? = nil) -> Single<D> where D : Codable {
        return provider.rx.request(endpoint)
            .handleError()
            .map(D.self, atKeyPath: customPath)
            .cacheResponse(endpoint: endpoint, cacheProvider: cacheProvider)
            .catchError({ [weak self] error -> Single<D> in
                guard let cacheProvider = self?.cacheProvider else { throw error }
                return cacheProvider.requestDecodable(endpoint)
            })
    }
}

//MARK: - Endpoint Moya extension
extension Endpoint: TargetType {
    public var method: Moya.Method {
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
    
    private var parametersEncoding: ParameterEncoding {
        switch parameterEncoding {
        case .url:
            return URLEncoding.default
        case .json:
            return JSONEncoding.default
        }
    }
    
    public var task: Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: parametersEncoding)
        } else {
            return .requestPlain
        }
    }
}

//MARK: - Single<Response> extensions
private extension Single where TraitType == SingleTrait, Element == Response {
    func handleError() -> Single<Response> {
        return flatMap { response in
            print("")
            switch response.statusCode {
            case 200..<300: return .just(response)
            case 401: throw NetworkError.unauthorized
            case 404: throw NetworkError.notFound
            case 422: throw NetworkError.noMoreElements
            default: throw NetworkError.undefined
            }
        }
    }
}

//MARK: - Single<Codable> extensions
private extension Single where TraitType == SingleTrait, Element: Codable {
    func cacheResponse(endpoint: Endpoint, cacheProvider: NetworkCacheProvider) -> Single<Element> {
        return self.do(onSuccess: {
            guard let data = try? JSONEncoder().encode($0) else { return }
            cacheProvider.saveData(data, for: endpoint)
        })
    }
}
