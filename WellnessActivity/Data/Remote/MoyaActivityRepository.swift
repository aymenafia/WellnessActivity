//
//  RealmActivityRepository.swift
//  WellnessActivity
//
//  Created by aymen on 10.04.25.
//

import RxSwift
import Moya
import RxMoya

class MoyaActivityRepository: ActivityRepositoryProtocol {
    private let provider = MoyaProvider<ActivityAPI>()
    
    func fetchActivities() -> Observable<[Activity]> {
        return provider.rx.request(.getActivities)
            .filterSuccessfulStatusCodes()
            .map([ActivityDTO].self)
            .map { dtos in dtos.map { Activity(dto: $0) } }
            .asObservable()
    }
    
    func addActivity(_ activity: Activity) -> Observable<Void> {
        return provider.rx.request(.addActivity(title: activity.title, details: activity.details))
            .filterSuccessfulStatusCodes()
            .map { _ in }
            .asObservable()
    }
    
    func updateActivity(_ activity: Activity) -> Observable<Void> {
        return provider.rx.request(.updateActivity(activity: activity))
            .filterSuccessfulStatusCodes()
            .map { _ in }
            .asObservable()
    }
    
    func deleteActivity(_ activity: Activity) -> Observable<Void> {
        return provider.rx.request(.deleteActivity(activityId: activity.id))
            .filterSuccessfulStatusCodes()
            .map { _ in }
            .asObservable()
    }
}
