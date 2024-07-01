//
//  Models.swift
//  Locket
//
//  Created by Justin Damhaut on 15/6/24.
//

import Foundation
import SwiftData
import SwiftUI
import _PhotosUI_SwiftUI

@Model
final class person: Identifiable {
    
    //backend
    var personUUID = UUID()
    var priority: Int //0 normal, 1 for conditional activate etc
    @Attribute(.unique) var personid: Int
    var personModelCreationDate: Date //for sorting
    
    //person
    var name: String //justin
    var birthday: Date //birthday
    var hexAccentColor: String //color.red .green .blue for rgb values
    var accentColorIsDefaultForeground: Bool //true -> foregroundmatch, false -> anything else
    
    //images
    @Attribute(.externalStorage) var shownThumbnail: Data //images
    @Attribute(.externalStorage) var slideImages: [Data]? //images
    
    //socials
    @Relationship(deleteRule: .cascade) var socials: [socials]?
    
    //relationship
    var relationshipStatus: RelationshipStatus //besties
    var currentRelationshipStartDate: Date
    
    //description
    var personDescription: String
    
    init(personUUID: UUID = UUID(), priority: Int = 0, personid: Int = 0, personModelCreationDate: Date = .now, name: String = "", birthday: Date = .now, hexAccentColor: String = "FFFFFF", accentColorIsDefaultForeground: Bool = true, shownThumbnail: Data = Data(), slideImages: [Data]? = [Data](), socials: [socials]? = [], relationshipStatus: RelationshipStatus = .crush, currentRelationshipStartDate: Date = .now, personDescription: String = "") {
        self.personUUID = personUUID
        self.priority = priority
        /*
         Priority 2:
         Priority 1:
         Priority 0: Normal
         Priority -1: Send person to be deleted :(
         */
        self.personid = personid
        self.personModelCreationDate = personModelCreationDate
        self.name = name
        self.birthday = birthday
        self.hexAccentColor = hexAccentColor
        self.accentColorIsDefaultForeground = accentColorIsDefaultForeground
        self.shownThumbnail = shownThumbnail
        self.slideImages = slideImages
        self.socials = socials
        self.relationshipStatus = relationshipStatus
        self.currentRelationshipStartDate = currentRelationshipStartDate
        self.personDescription = personDescription
    }
  
}



@Model
final class events {
    var eventName: String //date on the beach
    var eventType: String //date/movie night etc
    var eventDescription: String? //today i went on a date etc......
    var eventDate: Date
    var eventIcon: String //sf symbol
 //   var eventAccentColor: Color //.blue
    
    var eventLocationLong: Float?
    var eventLocationLat: Float?
    
    var eventThumbnailImage: Data //import one image for your event
    var eventSlideImages: [Data]?
    
    var peopleid: [Int]? //everyone involved in the event
    
    var eventModelCreationDate: Date //for sorting
    
    init(eventName: String, eventType: String, eventDescription: String? = nil, eventDate: Date, eventIcon: String, eventAccentColor: Color, eventLocationLong: Float? = nil, eventLocationLat: Float? = nil, eventThumbnailImage: Data, eventSlideImages: [Data]? = nil, peopleid: [Int]? = nil, eventModelCreationDate: Date) {
        self.eventName = eventName
        self.eventType = eventType
        self.eventDescription = eventDescription
        self.eventDate = eventDate
        self.eventIcon = eventIcon
  //      self.eventAccentColor = eventAccentColor
        self.eventLocationLong = eventLocationLong
        self.eventLocationLat = eventLocationLat
        self.eventThumbnailImage = eventThumbnailImage
        self.eventSlideImages = eventSlideImages
        self.peopleid = peopleid
        self.eventModelCreationDate = eventModelCreationDate
    }
}



@Model
class socials {
    // user details
    var socialPlatform: socialPlatforms
    var stringPRE: String // area code eg 123
    var stringMAIN: String //insta username OR phone number 91234567
    
    init(socialPlatform: socialPlatforms, stringPRE: String, stringMAIN: String) {
        self.socialPlatform = socialPlatform
        self.stringPRE = stringPRE
        self.stringMAIN = stringMAIN
    }
}
