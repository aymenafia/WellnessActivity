//
//  MockActivityRepository.swift
//  WellnessActivity
//
//  Created by aymen on 10.04.25.
//

import XCTest
import RxSwift
import RxCocoa
@testable import WellnessActivity

// MARK: - Mock Repository

class MockActivityRepository: ActivityRepositoryProtocol {
    var activities: [Activity] = []
    
    func fetchActivities() -> Observable<[Activity]> {
        return Observable.just(activities)
    }
    
    func addActivity(_ activity: Activity) -> Observable<Void> {
        activities.append(activity)
        return Observable.just(())
    }
    
    func updateActivity(_ activity: Activity) -> Observable<Void> {
        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
            activities[index] = activity
        }
        return Observable.just(())
    }
    
    func deleteActivity(_ activity: Activity) -> Observable<Void> {
        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
            activities.remove(at: index)
        }
        return Observable.just(())
    }
}
