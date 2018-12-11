import RxChallengeDomain
import RxSwift
import SwiftyJSON

// MARK: - Typealias
public typealias VoidClosure = () -> (Void)
public typealias ObjectClosure<T> = (T) -> (Void)

// MARK: - Translation helper
public extension String {
    public func replacingVariables(_ variables: [String]) -> String {
        var replaced = self
        variables.enumerated().reversed().forEach {
            replaced = replaced.replacingOccurrences(of: "$var\($0.offset + 1)", with: $0.element)
        }
        return replaced
    }
}
