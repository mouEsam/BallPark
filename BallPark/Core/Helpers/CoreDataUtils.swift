//
//  NSManagedContextUtils.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 27/05/2023.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveIfNeeded() throws {
        if hasChanges {
            try save()
        }
    }
    
    func trySave() -> Result<Void, Error> {
        do {
            return .success(try save())
        } catch {
            return .failure(error)
        }
    }
    
    func trySaveIfNeeded() -> Result<Void, Error> {
        do {
            return .success(try saveIfNeeded())
        } catch {
            return .failure(error)
        }
    }
    
    func tryFetch<T>(_ request: NSFetchRequest<T>) -> Result<[T], Error> {
        do {
            return .success(try fetch(request))
        } catch {
            return .failure(error)
        }
    }
}
