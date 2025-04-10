//
//  Untitled.swift
//  WellnessActivity
//
//  Created by aymen on 10.04.25.
//

import RxSwift
import RxCocoa

class ActivityListViewModel {
    // MARK: - Inputs
    let newActivityTitle = PublishRelay<String>()
    let toggleActivityCompletion = PublishRelay<Activity>()
    let deleteActivity = PublishRelay<Activity>()
    
    // MARK: - Outputs
    let activities: BehaviorRelay<[Activity]> = BehaviorRelay(value: [])
    let error: PublishRelay<Error> = PublishRelay()
    
    private let activityRepository: ActivityRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(activityRepository: ActivityRepositoryProtocol) {
        self.activityRepository = activityRepository
        fetchActivities()
        bindInputs()
    }
    
     func fetchActivities() {
        activityRepository.fetchActivities()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] activities in
                self?.activities.accept(activities)
            }, onError: { [weak self] error in
                self?.error.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindInputs() {
        // Adding a new activity.
        newActivityTitle
            .flatMapLatest { [weak self] title -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                let newActivity = Activity(title: title, details: "New corporate health event")
                return self.activityRepository.addActivity(newActivity)
                    .observe(on: MainScheduler.instance)
            }
            .subscribe(onNext: { [weak self] in
                self?.fetchActivities()
            }, onError: { [weak self] error in
                self?.error.accept(error)
            })
            .disposed(by: disposeBag)
        
        // Toggle activity completion.
        toggleActivityCompletion
            .flatMapLatest { [weak self] activity -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                let updatedActivity = Activity(value: activity)
                updatedActivity.isCompleted = !activity.isCompleted
                return self.activityRepository.updateActivity(updatedActivity)
                    .observe(on: MainScheduler.instance)
            }
            .subscribe(onNext: { [weak self] in
                self?.fetchActivities()
            }, onError: { [weak self] error in
                self?.error.accept(error)
            })
            .disposed(by: disposeBag)
        
        // Delete an activity.
        deleteActivity
            .flatMapLatest { [weak self] activity -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.activityRepository.deleteActivity(activity)
                    .observe(on: MainScheduler.instance)
            }
            .subscribe(onNext: { [weak self] in
                self?.fetchActivities()
            }, onError: { [weak self] error in
                self?.error.accept(error)
            })
            .disposed(by: disposeBag)
    }
}
