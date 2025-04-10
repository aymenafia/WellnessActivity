//
//  SyncActivityRepository.swift
//  WellnessActivity
//
//  Created by aymen on 10.04.25.
//

import RxSwift

class SyncActivityRepository: ActivityRepositoryProtocol {
    private let local: ActivityRepositoryProtocol
    private let remote: ActivityRepositoryProtocol
    
    init(local: ActivityRepositoryProtocol, remote: ActivityRepositoryProtocol) {
        self.local = local
        self.remote = remote
    }
    
    func fetchActivities() -> Observable<[Activity]> {
        // Emit local activities immediately.
        let localActivities = local.fetchActivities()
        
        // Fetch remote activities, update local storage sequentially, then fetch the updated list.
        let remoteActivities = remote.fetchActivities()
            .flatMap { remoteActivities -> Observable<Void> in
                let updateCompletables: [Completable] = remoteActivities.map { activity in
                    self.local.updateActivity(activity).ignoreElements().asCompletable()
                }
                let chainedUpdates = updateCompletables.reduce(Completable.empty()) { partialResult, next in
                    partialResult.andThen(next)
                }
                return chainedUpdates.andThen(Observable.just(()))
            }
            .flatMap { _ in self.local.fetchActivities() }
        
        return Observable.concat([localActivities, remoteActivities])
    }
    
    func addActivity(_ activity: Activity) -> Observable<Void> {
        return local.addActivity(activity)
            .flatMap { self.remote.addActivity(activity) }
    }
    
    func updateActivity(_ activity: Activity) -> Observable<Void> {
        return local.updateActivity(activity)
            .flatMap { self.remote.updateActivity(activity) }
    }
    
    func deleteActivity(_ activity: Activity) -> Observable<Void> {
        return local.deleteActivity(activity)
            .flatMap { self.remote.deleteActivity(activity) }
    }
}
