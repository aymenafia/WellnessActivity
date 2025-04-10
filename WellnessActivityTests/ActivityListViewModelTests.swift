//
//  ActivityListViewModelTests.swift
//  WellnessActivity
//
//  Created by aymen on 10.04.25.
//
import XCTest
import RxSwift
import RxCocoa

@testable import WellnessActivity

class ActivityListViewModelTests: XCTestCase {
    var viewModel: ActivityListViewModel!
    var mockRepo: MockActivityRepository!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        // Create an instance of the mock repository.
        mockRepo = MockActivityRepository()
        // Initialize the view model with the mock repository.
        viewModel = ActivityListViewModel(activityRepository: mockRepo)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepo = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testAddingActivityUpdatesList() {
        let expectation = self.expectation(description: "Activity should be added")
        
        // Subscribe to the activities behavior relay and skip the initial empty emission.
        viewModel.activities
            .skip(1)
            .subscribe(onNext: { activities in
                XCTAssertEqual(activities.count, 1)
                XCTAssertEqual(activities.first?.title, "Test Activity")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        // Trigger adding a new activity via the view model input.
        viewModel.newActivityTitle.accept("Test Activity")
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testToggleActivityCompletionUpdatesActivity() {
        // Prepopulate the repository with a single activity.
        let activity = Activity(title: "Test Activity")
        mockRepo.activities = [activity]
        
        // Call fetchActivities to update the view model.
        viewModel.fetchActivities()
        
        let expectation = self.expectation(description: "Activity completion toggled")
        
        viewModel.activities
            .skip(1)
            .subscribe(onNext: { activities in
                if let updated = activities.first {
                    // Since the test toggles from false to true.
                    XCTAssertTrue(updated.isCompleted)
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        // Simulate toggling completion.
        viewModel.toggleActivityCompletion.accept(activity)
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testDeleteActivityRemovesActivity() {
        // Prepopulate the repository with one activity.
        let activity = Activity(title: "Test Activity")
        mockRepo.activities = [activity]
        
        // Update the view model list.
        viewModel.fetchActivities()
        
        let expectation = self.expectation(description: "Activity should be deleted")
        
        viewModel.activities
            .skip(1)
            .subscribe(onNext: { activities in
                XCTAssertEqual(activities.count, 0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        // Trigger deletion.
        viewModel.deleteActivity.accept(activity)
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
