//
//  Publisher+Extensions.swift
//
//
//  Created by Kristóf Kálai on 2023. 08. 29..
//

import Combine
import Foundation

extension Publisher {
    /// Attempts to recreate a failed subscription with the upstream publisher up to the number of times you specify with the given delay.
    /// - Parameters:
    ///   - count: The number of times to attempt to recreate the subscription if the first subscription is failed.
    ///   - delay: Specifies the delay before the next retry. The parameter tells the index of the retry.
    ///   - transform: Specifies how to handle a result. There won't be any retry unless the return value is `.retryable`.
    /// - Returns:
    ///     A publisher that attempts to recreate its subscription to a failed upstream publisher.
    public func delayedRetry<T>(
        count: Int,
        delay: @escaping (Int) -> TimeInterval,
        transform: @escaping (Output) -> DelayedRetryResult<T>
    ) -> AnyPublisher<T, any Error> {
        var attempt = 0
        return tryMap {
            attempt += 1
            switch transform($0) {
            case let .nonRetryable(error): return .failure(error)
            case let .retryable(error): throw error
            case let .success(value): return .success(value)
            }
        }
        .catch { error -> AnyPublisher<Result, Error> in
            let delay: RunLoop.SchedulerTimeType.Stride = {
                if attempt - 1 == count {
                    return .zero
                }
                return .init(Swift.max(.zero, delay(attempt)))
            }()
            return Fail(error: error)
                .delay(for: delay, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        .retry(count)
        .tryMap { try $0.get() }
        .eraseToAnyPublisher()
    }
}
