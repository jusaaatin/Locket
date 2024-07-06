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

func dateToDMY(input: Date, type: Int) -> String {
    let DMYFormatter = DateFormatter()
    if type == 1{
        DMYFormatter.dateFormat = "d"
    } else if type == 2 {
        DMYFormatter.dateFormat = "MM"
    } else {
        DMYFormatter.dateFormat = "y"
    }
    return DMYFormatter.string(from: input)
}

@Model
final class person: Identifiable {
    
    //backend
    var personUUID = UUID()
    var priority: Int
    @Attribute(.unique) var personid: Int
    var personModelCreationDate: Date //for sorting
    
    /* PRIORITIES
     Priority 10: Self Profile
     Priority 5: 4 but pinned
     Priority 4: Birthday Today OR Anniversary Today Conditional
     Priority 3: 2 but pinned
     Priority 2: Birthday Tomorrow OR Anniversary Tomorrow Conditional
     Priority 1: Pin
     Priority 0: Normal
     Priority -1: Send person to be deleted :(
     */
    
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
    
    func pinToggle() {
        if isPinned() { priority -= 1 }
        else { priority += 1 }
    }
    func isPinned() -> Bool {
        if priority == 1 || priority == 3 || priority == 5 /* pinned */{
            return true
        } else if priority == 0 || priority == 2 || priority == 4 /* unpinned */{
            return false
        } else { return false }
    }
    func isBirthdayToday() -> Bool {
        if dateToDMY(input: birthday, type: 1) == dateToDMY(input: Date.now, type: 1) && dateToDMY(input: birthday, type: 2) == dateToDMY(input: Date.now, type: 2) {
            return true
        } else { return false }
    }
    func isBirthdayTomorrow() -> Bool {
        if dateToDMY(input: birthday, type: 1) == dateToDMY(input: addOrSubtractDay(day: 1), type: 1) && dateToDMY(input: birthday, type: 2) == dateToDMY(input: Date.now, type: 2) {
            return true
        } else { return false }
    }
    func isAnniversaryToday() -> Bool {
        if dateToDMY(input: currentRelationshipStartDate, type: 1) == dateToDMY(input: Date.now, type: 1) && dateToDMY(input: currentRelationshipStartDate, type: 2) == dateToDMY(input: Date.now, type: 2) {
            return true
        } else { return false }
    }
    func isAnniversaryTomorrow() -> Bool {
        if dateToDMY(input: currentRelationshipStartDate, type: 1) == dateToDMY(input: addOrSubtractDay(day: 1), type: 1) && dateToDMY(input: currentRelationshipStartDate, type: 2) == dateToDMY(input: addOrSubtractDay(day: 1), type: 2) {
            return true
        } else { return false }
    }
    func isSelfProfile() -> Bool {
        if priority == 10 { return true }
        else { return false }
    }
    func prioritySetter(){
        priority = returnPriority()
    }
    func returnPriority() -> Int {
        if isPinned() {
            if isBirthdayToday() || isAnniversaryToday() {
                return 5
            } else if isBirthdayTomorrow() || isAnniversaryTomorrow() {
                return 3
            } else {
                return 1
            }
        } else {
            if isBirthdayToday() || isAnniversaryToday() {
                return 4
            } else if isBirthdayTomorrow() || isAnniversaryTomorrow() {
                return 2
            } else {
                return 0
            }
        }
    }

    
    init(personUUID: UUID = UUID(), priority: Int = 0, personid: Int = 0, personModelCreationDate: Date = .now, name: String = "", birthday: Date = .now, hexAccentColor: String = "FFFFFF", accentColorIsDefaultForeground: Bool = true, shownThumbnail: Data = Data(), slideImages: [Data]? = [Data](), socials: [socials]? = [], relationshipStatus: RelationshipStatus = .crush, currentRelationshipStartDate: Date = .now, personDescription: String = "") {
        self.personUUID = personUUID
        self.priority = priority
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
