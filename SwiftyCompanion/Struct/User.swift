//
//  User.swift
//  SwiftyCompanion
//
//  Created by Flash Jessi on 9/8/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import Foundation

struct Cursus:Decodable {
    let name: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }
}

struct Skills: Decodable {
    let id: Int
    let name: String
    let level: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case level = "level"
    }
}

struct CursusUser: Decodable {
    let grade: String?
    let level: Float
    let cursus: Cursus
    let skills: [Skills]
    
    var name: String {
        get {
            return cursus.name
        }
    }
    
    var id: Int {
        get {
            return cursus.id
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case grade = "grade"
        case level = "level"
        case cursus = "cursus"
        case skills = "skills"
    }
}

struct Project: Decodable {
    let id: Int
    let name: String
    let parentId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case parentId = "parent_id"
    }
}

struct ProjectsUsers: Decodable {
    let finalMark: Int?
    let status: String
    let validated: Bool?
    let project: Project
    let cursusIds: [Int]
    let marked: Bool
    
    enum CodingKeys: String, CodingKey {
        case finalMark = "final_mark"
        case status = "status"
        case validated = "validated?"
        case project = "project"
        case cursusIds = "cursus_ids"
        case marked = "marked"
    }
}

struct Achievements: Decodable {
    let id: Int
    let name: String
    let description: String
    let tier: String
    let kind: String
    let visible: Bool
    let image: String
    let nbrOfSuccess: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case tier = "tier"
        case kind = "kind"
        case visible = "visible"
        case image = "image"
        case nbrOfSuccess = "nbr_of_success"
    }
}

struct Titles: Decodable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

struct TitlesUsers: Decodable {
    let titleId: Int
    let selected: Bool
    
    enum CodingKeys: String, CodingKey {
        case titleId = "title_id"
        case selected = "selected"
    }
}

struct Campus: Decodable {
    let city: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case city = "city"
        case country = "country"
    }
}

struct User: Decodable {
    let email: String
    let login: String?
    let firstName: String
    let secondName: String
    let fullName: String
    let evaluationPoint: Int
    let location: String?
    let wallet: Int
    let cursusUsers: [CursusUser]
    let projectsUsers: [ProjectsUsers]
    let achievements: [Achievements]
    let titles: [Titles]
    let titlesUsers: [TitlesUsers]
    let campus: [Campus]
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case login = "login"
        case firstName = "first_name"
        case secondName = "last_name"
        case fullName = "usual_full_name"
        case evaluationPoint = "correction_point"
        case location = "location"
        case wallet = "wallet"
        case cursusUsers = "cursus_users"
        case projectsUsers = "projects_users"
        case achievements = "achievements"
        case titles = "titles"
        case titlesUsers = "titles_users"
        case campus = "campus"
    }
}
