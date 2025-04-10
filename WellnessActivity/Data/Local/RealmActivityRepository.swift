//
//  RealmActivityRepository.swift
//  WellnessActivity
//
//  Created by aymen on 10.04.25.
//

import RxSwift
import RealmSwift

// Local persistence implementation using Realm.
class RealmActivityRepository: ActivityRepositoryProtocol {
    private let realm = try! Realm()
    
    func fetchActivities() -> Observable<[Activity]> {
        return Observable.create { observer in
            let activities = self.realm.objects(Activity.self)
            observer.onNext(Array(activities))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func addActivity(_ activity: Activity) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.realm.write {
                    self.realm.add(activity)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func updateActivity(_ activity: Activity) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.realm.write {
                    self.realm.add(activity, update: .modified)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func deleteActivity(_ activity: Activity) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.realm.write {
                    self.realm.delete(activity)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
