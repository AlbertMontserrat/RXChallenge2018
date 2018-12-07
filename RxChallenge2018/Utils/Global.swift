import Foundation
import RxSwift
import SwiftyJSON

// MARK: Typealias
public typealias VoidClosure = () -> (Void)
public typealias ObjectClosure<T> = (T) -> (Void)
public typealias JSONDict = [String: Any]
public typealias JSONArray = [Any]
public typealias DecodableJSON<T: Decodable> = [String:T]

// MARK: - Date format
public enum DateFormat: String {
    case short = "yyyy-MM-dd"
    case yearMonth = "yyyy-MM"
    case long = "yyyy-MM-dd HH:mm:ss"
    case iso8601 = "yyyy-MM-dd'T'HH:mm:sszzz"
}

extension DateFormat {
    var dateFormatter: DateFormatter {
        return DateFormatter(dateFormat: rawValue)
    }
}

private extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}

extension Dictionary where Key == String, Value: Any {
    var hash: String {
        return self.keys.sorted().map { [$0, String(describing: self[$0])].joined(separator: ":") }.joined(separator: ",")
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
