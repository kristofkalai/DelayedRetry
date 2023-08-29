//
//  DelayedRetryResult.swift
//
//
//  Created by Kristóf Kálai on 2023. 08. 29..
//

public enum DelayedRetryResult<T> {
    case nonRetryable(Error)
    case retryable(Error)
    case success(T)
}
