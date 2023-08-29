//
//  URLSession+Extensions.swift
//  
//
//  Created by Kristóf Kálai on 2023. 08. 29..
//

import Combine
import Foundation

extension URLSession {
    /// Attempts to recreate a failed subscription with the upstream publisher up to the number of times you specify with the given delay.
    /// - Parameters:
    ///   - url: The URL for which to create a data task.
    ///   - count: The number of times to attempt to recreate the subscription if the first subscription is failed.
    ///   - delay: Specifies the delay before the next retry. The parameter tells the index of the retry.
    ///   - transform: Specifies how to handle a result. There won't be any retry unless the return value is `.retryable`.
    /// - Returns:
    ///     A publisher that attempts to recreate its subscription to a failed upstream publisher.
    public func dataTaskWithDelayedRetry<T>(
        url: URL,
        count: Int,
        delay: @escaping (Int) -> TimeInterval,
        transform: @escaping (DataTaskPublisher.Output) -> DelayedRetryResult<T>
    ) -> AnyPublisher<T, any Error> {
        dataTaskPublisher(for: url)
            .delayedRetry(count: count, delay: delay, transform: transform)
    }
}
