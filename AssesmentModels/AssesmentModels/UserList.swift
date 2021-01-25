//
//  UserList.swift
//  Assesment
//
//  Created by Govindharaj Murugan on 06/01/21.
//

import Foundation

// MARK: - UserList
public struct UserList: Decodable {
    
    public init() {}
    
    public var totalCount: Int = 0
    public var incompleteResults: Bool = false
    public var items: [Item] = [Item]()
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
    
}

// MARK: - Item
public struct Item: Codable {
    
    public init() {}
    
    public var login = ""
    public var id = 0
    public var nodeID = ""
    public var avatarURL = ""
    public var gravatarID = ""
    public var url = ""
    public var htmlURL = ""
    public var followersURL = ""
    public var followingURL = ""
    public var gistsURL = ""
    public var starredURL = ""
    public var subscriptionsURL = ""
    public var organizationsURL = ""
    public var reposURL = ""
    public var eventsURL = ""
    public var receivedEventsURL = ""
    public var type = ""
    public var siteAdmin = false
    public var score = 0

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type = "type"
        case siteAdmin = "site_admin"
        case score = "score"
    }
}

public enum TypeEnum: String, Codable {
    case user = "User"
}

