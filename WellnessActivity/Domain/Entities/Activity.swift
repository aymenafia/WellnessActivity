//
//  Acitivity.swift
//  WellnessActivity
//
//  Created by aymen on 10.04.25.
//

import Foundation
import RealmSwift

// Domain entity representing an Activity.
// In our app, an Activity could be a wellness session, corporate health workshop, etc.
class Activity: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var isCompleted: Bool = false
    // Additional properties can be added as needed.
    @objc dynamic var details: String? = nil // For example, a description or additional info.
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(title: String, details: String? = nil) {
        self.init()
        self.title = title
        self.details = details
    }
}

// DTO for network transfer.
struct ActivityDTO: Codable {
    let id: String
    let title: String
    let isCompleted: Bool
    let details: String?
}

extension Activity {
    convenience init(dto: ActivityDTO) {
        self.init()
        self.id = dto.id
        self.title = dto.title
        self.isCompleted = dto.isCompleted
        self.details = dto.details
    }
    
    func toDTO() -> ActivityDTO {
        return ActivityDTO(id: self.id,
                           title: self.title,
                           isCompleted: self.isCompleted,
                           details: self.details)
    }
}
