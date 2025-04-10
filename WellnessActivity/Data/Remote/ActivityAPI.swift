//
//  ActivityAPI.swift
//  WellnessActivity
//
//  Created by aymen on 10.04.25.
//

import RxSwift
import Moya
import RxMoya
import Foundation

enum ActivityAPI {
    case getActivities
    case addActivity(title: String, details: String?)
    case updateActivity(activity: Activity)
    case deleteActivity(activityId: String)
}

extension ActivityAPI: TargetType {
    var baseURL: URL {
        // Replace with your actual API endpoint.
        return URL(string: "https://api.hanakogmbh.com")!
    }
    
    var path: String {
        switch self {
        case .getActivities:
            return "/activities"
        case .addActivity:
            return "/activities"
        case .updateActivity(let activity):
            return "/activities/\(activity.id)"
        case .deleteActivity(let activityId):
            return "/activities/\(activityId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getActivities:
            return .get
        case .addActivity:
            return .post
        case .updateActivity:
            return .put
        case .deleteActivity:
            return .delete
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getActivities:
            let sampleActivities = [
                ["id": "1", "title": "Morning Yoga", "isCompleted": false, "details": "Start the day refreshed."],
                ["id": "2", "title": "Nutrition Seminar", "isCompleted": true, "details": "Improve dietary habits."]
            ]
            return try! JSONSerialization.data(withJSONObject: sampleActivities, options: [])
        case .addActivity, .updateActivity, .deleteActivity:
            return Data()
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getActivities, .deleteActivity:
            return .requestPlain
        case .addActivity(let title, let details):
            var params: [String: Any] = ["title": title]
            if let details = details {
                params["details"] = details
            }
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .updateActivity(let activity):
            return .requestParameters(parameters: [
                "title": activity.title,
                "isCompleted": activity.isCompleted,
                "details": activity.details ?? ""
            ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
