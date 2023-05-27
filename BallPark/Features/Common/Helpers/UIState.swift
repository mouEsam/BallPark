//
//  UIState.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation

protocol WithData<T> {
    associatedtype T
    var data: T { get }
}

protocol WithError {
    var error: Error? { get }
}

enum SourceType {
    case local
    case remote
}

protocol AnySourcedData<T>: WithData, WithError {
    func cast<S>(_ type: S.Type) -> any AnySourcedData<S>
}

struct SourcedData<T>: AnySourcedData {
    let data: T
    let error: Error?
    let source: SourceType
    
    func cast<S>(_ type: S.Type) -> any AnySourcedData<S> {
        return SourcedData<S>(data: data as! S, error: error, source: source)
    }
}

extension AnySourcedData {
    static func local(_ data: T, _ error: Error? = nil) -> SourcedData<T> {
        return SourcedData<T>(data: data, error: error, source: .local)
    }
    
    static func remote(_ data: T, _ error: Error? = nil) -> SourcedData<T> {
        return SourcedData<T>(data: data, error: error, source: .remote)
    }
}

enum UIState<T> {
    case initial
    case loading
    case loaded(data: any AnySourcedData<T>)
    case error(error: Error)
    
    var data: T? {
        if case let .loaded(data) = self {
            return data.data
        }
        return nil
    }
    
    var error: (any Error)? {
        if case let .error(error: error) = self {
            return error
        }
        return nil
    }
}

extension Result {
    func toLocal(_ error: Error? = nil) -> UIState<Success> {
        if case .success(let data) = self {
            return .loaded(data: SourcedData<Success>.local(data, error))
        } else if case .failure(let error) = self {
            return .error(error: error)
        } else if let error = error {
            return .error(error: error)
        } else {
            return .initial
        }
    }
    
    func toRemote(_ error: Error? = nil) -> UIState<Success> {
        if case .success(let data) = self {
            return .loaded(data: SourcedData<Success>.remote(data, error))
        } else if case .failure(let error) = self {
            return .error(error: error)
        } else if let error = error {
            return .error(error: error)
        } else {
            return .initial
        }
    }
}
    
extension Result where Success: AnySourcedData, Failure: Error {
    func toUiState<S>() -> UIState<S> {
        if case .success(let data) = self {
            return .loaded(data: data.cast(S.self))
        } else if case .failure(let error) = self {
            return .error(error: error)
        } else {
            return .initial
        }
    }
}
