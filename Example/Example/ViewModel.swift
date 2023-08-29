//
//  ViewModel.swift
//  Example
//
//  Created by Kristóf Kálai on 2023. 08. 29..
//

import Combine
import DelayedRetry
import Foundation

private func fibonacci(_ n: Int) -> Int {
    n < 2 ? n : (fibonacci(n - 1) + fibonacci(n - 2))
}

final class ViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    func test() {
        enum DelayError: Error {
            case wrongOutput
            case nonRecoverableOutput
        }

        URLSession.shared.dataTaskWithDelayedRetry(
            url: URL(string: "https://www.google.com")!,
            count: 5,
            delay: { retryIndex in
                TimeInterval(fibonacci(retryIndex))
            },
            transform: { output in
                if .random() {
                    print("Result: retryable")
                    return .retryable(DelayError.wrongOutput)
                } else if .random() {
                    print("Result: nonRetryable")
                    return .nonRetryable(DelayError.nonRecoverableOutput)
                }
                print("Result: success")
                return .success(output)
            }
        )
        .sink { completion in
            switch completion {
            case .finished: print("Finished")
            case let .failure(error): print("Failure: \(error.localizedDescription)")
            }
        } receiveValue: { (value: URLSession.DataTaskPublisher.Output) in
            print("Received value: \(value)")
        }
        .store(in: &cancellables)
    }
}
