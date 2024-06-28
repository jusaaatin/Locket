//
//  AddProfileView.swift
//  Locket
//
//  Created by Justin Damhaut on 16/6/24.
//

import SwiftUI
import Combine
import Photos
import PhotosUI

struct AddProfileView: View {
    @Environment(\.self) var environment
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State var debugOn: Bool
    
    //person
    @State private var name: String = ""
    @State private var accentColor: Color = Color("Foreground-match")
    @State private var accentColorIsDefaultForeground: Bool = true //true means foregroundmatch false means any other color
    @State private var birthday: Date = .now
    
    //images
    @State var shownThumbnail: Data = Data()
    @State var slideImages: [Data] = []
    
    //socials
    @State var isHidden: [Bool] = [false]
    @State var socialPlatform: [socialPlatforms] = [.PhoneNumber]
    @State var stringPRE: [String] = [""]
    @State var stringMAIN: [String] = [""]
    @State var additionalSocialsCount: Int = 0
    @State var visibleSocialsCount: Int = 1
    @State var socialsArray: [socials] = []
    
    //relationship
    @State private var relationshipStatus: RelationshipStatus = .crush
    @State private var currentRelationshipStartDate: Date = .now
    
    //description??
    @State private var personDescription: String = ""
    
    @State private var demoColor: Color = .white
    
    //checklistOk
    @State private var nameNotOk = false
    @State private var birthdayNotOk = false
    @State private var thumbnailNotOk = false
    
    @State private var birthdayChanged = false
    
    func saveToSocialsArray() {
        for i in 0...additionalSocialsCount {
            socialsArray.append(socials(socialPlatform: socialPlatform[i], stringPRE: stringPRE[i], stringMAIN: stringMAIN[i]))
        }
    }
    
    func generatePersonID() -> Int{
        let currentDate: Date = .now
        let currentSince1970 = currentDate.timeIntervalSince1970
        return Int(currentSince1970)
    }
    
    func checklistOk() -> Bool {
        if name != "" && shownThumbnail != Data() && birthday != .now {
            // compulsory fields filled in: ok
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if debugOn {
                        Text("DEBUG IS ON")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.red)
                            .padding(.bottom, -22)
                            .padding(.top)
                        Spacer()
                    }
                    HStack {
                        Text("        Person")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.gray)
                            .padding(.bottom, -22)
                            .padding(.top)
                        if nameNotOk && !birthdayNotOk {
                            Text("  -     Please Fill In Name")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.red)
                                .padding(.bottom, -22)
                                .padding(.top)
                        }
                        if birthdayNotOk && !nameNotOk{
                            Text("  -     Please Fill In Birthday")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.red)
                                .padding(.bottom, -22)
                                .padding(.top)
                        }
                        if nameNotOk && birthdayNotOk {
                            Text("  -     Please Fill In Name and Birthday")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.red)
                                .padding(.bottom, -22)
                                .padding(.top)
                        }
                        Spacer()
                    }
                    AddProfileViewPerson(name: $name, accentColor: $accentColor, birthday: $birthday)
                        .onChange(of: birthday) { old, new in
                            if old != new {
                                birthdayChanged = true
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.red.opacity(nameNotOk || birthdayNotOk ? 0.5 : 0), lineWidth: 2)
                        )
                        .padding()
                    HStack {
                        Text("        Images")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.gray)
                            .padding(.bottom, -22)
                            .padding(.top)
                        if thumbnailNotOk {
                            Text("  -     Please Add a Thumbnail Image")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.red)
                                .padding(.bottom, -22)
                                .padding(.top)
                        }
                        Spacer()
                    }
                    AddProfileViewImages(shownThumbnail: $shownThumbnail, slideImages: $slideImages)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.red.opacity(thumbnailNotOk ? 0.5 : 0), lineWidth: 2)
                        )
                        .padding()
                    HStack {
                        Text("        Socials")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.gray)
                            .padding(.top)
                        Spacer()
                    }
                    AddProfileViewSocials(isHidden: $isHidden, 
                                          socialPlatform: $socialPlatform,
                                          stringPRE: $stringPRE,
                                          stringMAIN: $stringMAIN,
                                          additionalSocialsCount: $additionalSocialsCount,
                                          visibleSocialsCount: $visibleSocialsCount,
                                          debugOn: $debugOn)
                        .padding([.leading, .trailing])
                    HStack {
                        Text("        Relationship")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.gray)
                            .padding(.bottom, -22)
                            .padding(.top)
                        Spacer()
                    }
                    AddProfileViewRelationships(relationshipStatus: $relationshipStatus, currentRelationshipStartDate: $currentRelationshipStartDate)
                        .padding()
                    HStack {
                        Text("        More")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.gray)
                            .padding(.bottom, -22)
                            .padding(.top)
                        Spacer()
                    }
                    AddProfileViewNotes(description: $personDescription).padding()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        if !debugOn {
                            if checklistOk() {
                                nameNotOk = false
                                birthdayNotOk = false
                                thumbnailNotOk = false
                                saveToSocialsArray()
                                let person = person(
                                    personid: generatePersonID(),
                                    name: name,
                                    birthday: birthday,
                                    hexAccentColor: accentColor.toHex() ?? "FFFFFF",
                                    accentColorIsDefaultForeground: accentColorIsDefaultForeground,
                                    shownThumbnail: shownThumbnail,
                                    slideImages: slideImages,
                                    socials: socialsArray,
                                    relationshipStatus: relationshipStatus,
                                    currentRelationshipStartDate: currentRelationshipStartDate,
                                    personDescription: personDescription)
                                modelContext.insert(person)
                                print("success")
                                print("\(name)")
                                dismiss()
                            } else {
                                if name == "" {nameNotOk = true} else {nameNotOk = false}
                                if birthdayChanged == false {birthdayNotOk = true} else {birthdayNotOk = false}
                                if shownThumbnail == Data() {thumbnailNotOk = true} else {thumbnailNotOk = false}
                            }
                        } else if debugOn {
                            print("""
                            PersonID: \(generatePersonID())
                            name: \(name)
                            birthday: \(birthday)
                            hexAccentColor: \(accentColor.toHex() ?? "FFFFFF")
                            accentColorIsDefaultBackground: \(accentColorIsDefaultForeground)
                            relationship status: \(relationshipStatus)
                            currentrelationshipstartdate: \(currentRelationshipStartDate)
                            persondescription: \(personDescription)
                            """)
                        }
                        
                    }
                }
            }
            .navigationTitle("Add Person")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddProfileView(debugOn: false)
}
