//
//  ProfileInfo.swift
//  SwiftyCompanion
//
//  Created by Flash Jessi on 9/17/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit

class ProfileInfo {
    
    let user: User
    
    init(with user: User) {
        self.user = user
    }
    
    func titleUser(user: User?) -> String? {
        guard let titles = user?.titles, let titlesUsers = user?.titlesUsers, let user = user?.login else { return nil }
        var id = 0
        for item in titlesUsers {
            if item.selected {
                id = item.titleId
            }
        }
        for item in titles {
            if item.id == id {
                let array = item.name.components(separatedBy: " ")
                var name = String()
                for i in array {
                    if (i == "%login" || i == "%login,") && name != "" {
                        name = name + " " + user
                    } else if (i == "%login" || i == "%login,") {
                        name = name + user
                    }else {
                        name = name + " " + i
                    }
                }
                return name
            }
        }
        return nil
    }
    
    func getProjects(user: User, cursus: Int) -> [ProjectsUsers] {
        if cursus == 9999 {
            return [ProjectsUsers(finalMark: 9999, status: "final", validated: true, project: Project(id: 9999, name: "Not found yet", parentId: nil), cursusIds: [999], marked: true)]
        }
        let projectsUsers = user.projectsUsers.filter{ $0.cursusIds.first == cursus}.filter{ $0.project.parentId == nil}
        return projectsUsers
    }
    
    func getSkills(user: User, cursus: Int) -> [Skills] {
        if cursus == 9999 {
            return [Skills(id: 9999, name: "Not found yet", level: 0.0)]
        }
        let skillsUsers = user.cursusUsers.filter{ $0.id == cursus}.first?.skills
        return skillsUsers!
    }
    
}
