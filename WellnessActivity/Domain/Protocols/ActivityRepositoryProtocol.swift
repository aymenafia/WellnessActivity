//
//  ActivityRepositoryProtocol.swift
//  WellnessActivity
//
//  Created by aymen on 10.04.25.
//

import RxSwift

// Protocol defining CRUD operations for Activity.
protocol ActivityRepositoryProtocol {
    func fetchActivities() -> Observable<[Activity]>
    func addActivity(_ activity: Activity) -> Observable<Void>
    func updateActivity(_ activity: Activity) -> Observable<Void>
    func deleteActivity(_ activity: Activity) -> Observable<Void>
}
