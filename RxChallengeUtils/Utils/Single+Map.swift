import RxChallengeDomain
import RxSwift
import SwiftyJSON

//MARK: - Single extensions
public extension Single where TraitType == SingleTrait, Element == JSONDict {
    func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: [JSONSubscriptType]? = nil) -> Single<D> {
        return flatMap { jsonDict in
            var json = JSON(jsonDict)
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

public extension Single where TraitType == SingleTrait, Element == JSONArray {
    func map<D: Decodable>(_ type: D.Type) -> Single<[D]> {
        return flatMap { jsonDict in
            let json = JSON(jsonDict)
            do {
                let data = try json.rawData()
                return .just(try JSONDecoder().decode([D].self, from: data))
            }
            catch {
                throw NetworkError.malformedJSON
            }
        }
    }
}
