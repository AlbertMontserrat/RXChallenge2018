import Foundation
import RxSwift
import SwiftyJSON

// MARK: - Typealias
public typealias VoidClosure = () -> (Void)
public typealias ObjectClosure<T> = (T) -> (Void)
public typealias JSONDict = [String: Any]
public typealias JSONArray = [Any]

// MARK: - Translation helper
extension String {
    func replacingVariables(_ variables: [String]) -> String {
        var replaced = self
        variables.enumerated().forEach {
            replaced = replaced.replacingOccurrences(of: "$var\($0.offset + 1)", with: $0.element)
        }
        return replaced
    }
}

//MARK: - Single extensions
extension Single where TraitType == SingleTrait, Element == JSONDict {
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

extension Single where TraitType == SingleTrait, Element == JSONArray {
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
