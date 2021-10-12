import Foundation

#if os(iOS)
@available(iOS 15.0.0, *)
extension IOTAAccount {
    public func sync() async -> Result<Bool, IOTAResponseError> {
        return await withCheckedContinuation({ sself in
            sync { sself.resume(returning: $0) }
        })
    }
}
#endif
