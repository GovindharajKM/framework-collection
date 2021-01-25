//
//  User.swift
//  Assesment
//
//  Created by Govindharaj Murugan on 07/01/21.
//

import Foundation

public struct User: Decodable {

    
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
    public var name = ""
    public var publicRepos = 0
    public var publicGists = 0
    public var followers = 0
    public var following = 0
    public var createdAt = ""
    public var updatedAt = ""
    
    public init() {}
    
    enum CodingKeys : String, CodingKey {
        case login
        case id
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
        case name
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers
        case following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
