//
//  RealmManager.swift
//  SingularityDemoApp
//
//  Created by venu Gopal on 03/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import Foundation
import RealmSwift

struct PersistenceError: Error {
    
    enum ErorsCodes: Int {
        case objectMissing = 0
        
        func getDescription() -> String {
            switch self {
            case .objectMissing:
                return "Realm object is missing"
            }
        }
    }
    
    var code: Int
    var description: String
}

public class RealmManager: NSObject {
    static let shared = RealmManager()
    private var realm: Realm = try! Realm()
    
    override init() {
        super.init()

    }
    
    func saveObjects<T>(_ objects: [T], update: Bool) where T : Object {
        try? realm.write {
            realm.add(objects, update: .all)
        }
    }
    
    func saveObject<T>(_ object: T, update: Bool) where T : Object {
        try? realm.write {
            if update {
                realm.add(object, update: .all)
            } else {
                realm.add(object)
            }
        }
    }
    
    func fetchObjects(_ type: Object.Type) -> [Object]? {
        let results = realm.objects(type)
        return Array(results)
    }
    
    func fetchObjects<T>(_ type: T.Type, predicate: NSPredicate) -> [T]? where T: Object {
        guard let realm = try? Realm() else { return nil }
        return Array(realm.objects(type).filter(predicate))
    }
    
    // MARK: Remove
    func removeObjects<T>(_ objects: [T]) where T: Object {
        if let realm = try? Realm() {
            try? realm.write {
                realm.delete(objects)
            }
        }
    }
    
    func removeObject<T>(_ object: T) where T: Object {
        if let realm = try? Realm() {
            try? realm.write {
                realm.delete(object)
            }
        }
    }
    
    func removeAllObjectsOfType<T>(_ type: T.Type) where T: Object {
        if let realm = try? Realm() {
            try? realm.write {
                realm.delete(realm.objects(T.self))
            }
        }
    }
    
    func removeAll() {
        if let realm = try? Realm() {
            try? realm.write({
                realm.deleteAll()
            })
        }
    }
    
    func updateObjects<T>(_ objects: [T]) throws where T: Object {
        if let realm = try? Realm() {
            
            let primaryKeys = objects.map({ element -> Any in
                return element.value(forKey: T.primaryKey()!) as Any
            })
            
            let response = realm.objects(T.self).filter("%@ IN %@", T.primaryKey()!, primaryKeys)
            
            if response.count != objects.count {
                let erorrDescription = PersistenceError.ErorsCodes.objectMissing
                throw PersistenceError(code: erorrDescription.rawValue,
                                       description: erorrDescription.getDescription())
            }
            
            try? realm.write {
                realm.add(objects, update: .all)
            }
        }
    }
    
    func updateObject<T>(_ object: T) throws where T: Object {
        if let realm = try? Realm() {
            let result = realm.object(ofType: T.self, forPrimaryKey: object.value(forKeyPath: T.primaryKey()!) as AnyObject)
            
            if let object = result {
                try? realm.write {
                    realm.add(object, update: .all)
                }
            } else {
                let erorrDescription = PersistenceError.ErorsCodes.objectMissing
                throw PersistenceError(code: erorrDescription.rawValue,
                                       description: erorrDescription.getDescription())
            }
        }
    }
    
}
