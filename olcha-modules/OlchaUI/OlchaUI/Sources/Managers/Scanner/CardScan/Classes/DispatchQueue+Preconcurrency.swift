import Foundation

extension DispatchQueue {
    // Legacy overloads to keep existing GCD call sites compiling cleanly under strict concurrency.
    @preconcurrency
    func async(execute work: @escaping () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }

    @preconcurrency
    func sync(execute work: () -> Void) {
        sync(flags: [], execute: work)
    }
}
