//
//  AddSelfProfileView.swift
//  Locket
//
//  Created by Justin Damhaut on 10/20/24.
//

import SwiftUI
import Combine
import Photos
import PhotosUI

struct AddSelfProfileView: View {
    @Environment(\.self) var environment
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State var debugOn: Bool
    
    //person
    @State private var name: String = ""
    @State private var accentColor: Color = Color("Foreground-match")
    @State private var birthday: Date = .now
    @State private var bDay: String = ""
    @State private var bMonth: String = ""
    @State private var bYear: String = ""
    
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
    @State var checkerSocialsArray: [socials] = []
    
    //relationship
    @State private var relationshipStatus: RelationshipStatus = .crush
    @State private var currentRelationshipStartDate: Date = .now
    @State private var rDay: String = ""
    @State private var rMonth: String = ""
    @State private var rYear: String = ""
    
    //description??
    @State private var personDescription: String = ""
    
    @State private var demoColor: Color = .white
    
    //checklistOk
    @State private var nameNotOk = false
    @State private var birthdayNotOk = false
    @State private var thumbnailNotOk = false
    @State private var socialsNotOk = false
    
    @State private var birthdayChanged = false
    
    @State var imageLoadingDone = true
    
    func saveToSocialsArray() {
        if additionalSocialsCount >= 0 {
            for i in 0...additionalSocialsCount {
                if !isHidden[i] {
                    if socialPlatform[i] == .PhoneNumber {
                        if stringPRE[i] != "" && stringMAIN[i] != "" {
                            socialsArray.append(socials(socialPlatform: socialPlatform[i], stringPRE: stringPRE[i], stringMAIN: stringMAIN[i]))
                        }
                    } else {
                        if stringMAIN[i] != "" {
                            socialsArray.append(socials(socialPlatform: socialPlatform[i], stringPRE: stringPRE[i], stringMAIN: stringMAIN[i]))
                        }
                    }

                }
            }
        }
    }
    func accentColorDefaultFgCheck() -> Bool{
        if accentColor == Color("Foreground-match") {
            return true
        } else { return false }
    }
    func generatePersonID() -> Int{
        let currentDate: Date = .now
        let currentSince1970 = currentDate.timeIntervalSince1970
        return Int(currentSince1970)
    }
    func checklistOk() -> Bool {
        if (
            name != "" &&
            shownThumbnail != Data() &&
            bDay.count == 2 &&
            bMonth.count == 2 &&
            bYear.count == 4
        ){
            return true
        } else {
            return false
        }
    }
    func socialsChecklistOk() -> Bool {
        for social in checkerSocialsArray {
            if social.socialPlatform == .PhoneNumber {
                if social.stringPRE == "" || social.stringMAIN == "" {
                    checkerSocialsArray.removeAll()
                    return false
                }
            } else {
                if social.stringMAIN == "" {
                    checkerSocialsArray.removeAll()
                    return false
                }
            }
        }
        checkerSocialsArray.removeAll()
        return true
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
                    AddProfileViewPerson(name: $name, accentColor: $accentColor, birthday: $birthday, startDay: $bDay, startMonth: $bMonth, startYear: $bYear, hexInput: "FFFFFF", accentColorIsDefFg: true)
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
                        Text(thumbnailNotOk ? "        Images" : "        Thumbnail and Slide Images (Max 15)")
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
                    AddProfileViewImages(imageLoadingDone: $imageLoadingDone, shownThumbnail: $shownThumbnail, slideImages: $slideImages, debug: debugOn)
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
                        if socialsNotOk {
                            Text("  -     Please Fill In All Fields")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.red)
                                .padding(.top)
                        }
                        Spacer()
                    }
                    AddProfileViewSocials(isHidden: $isHidden,
                                          socialPlatform: $socialPlatform,
                                          stringPRE: $stringPRE,
                                          stringMAIN: $stringMAIN,
                                          additionalSocialsCount: $additionalSocialsCount,
                                          visibleSocialsCount: $visibleSocialsCount,
                                          debugOn: $debugOn, socialsNotOk: $socialsNotOk)
                        .padding([.leading, .trailing])
                    HStack {
                        Text("        More")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.gray)
                            .padding(.bottom, -22)
                            .padding(.top)
                        Spacer()
                    }
                    AddProfileViewNotes(description: $personDescription).padding()
                    Image(systemName: "figure.gymnastics")
                        .font(.system(size: 60, weight: .semibold, design: .rounded))
                        .foregroundStyle(.gray.opacity(0.5))
                        .padding()
                        .padding(.bottom, 30)
                }
            }.scrollIndicators(.hidden)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        
                        print("here")
                        if name == "" {nameNotOk = true} else {nameNotOk = false}
                        if bDay.count == 2 && bMonth.count == 2 && bYear.count == 4 {birthdayNotOk = false} else {birthdayNotOk = true}
                        if shownThumbnail == Data() {thumbnailNotOk = true} else {thumbnailNotOk = false}
                    
                        
                        if !debugOn && imageLoadingDone {
                             if checklistOk(){
                                nameNotOk = false
                                birthdayNotOk = false
                                thumbnailNotOk = false
                                saveToSocialsArray()
                                let person = person(
                                    priority: 18,
                                    personid: generatePersonID(),
                                    name: name,
                                    birthday: birthday,
                                    hexAccentColor: accentColor.toHex() ?? "FFFFFF",
                                    accentColorIsDefaultForeground: accentColorDefaultFgCheck(),
                                    shownThumbnail: shownThumbnail,
                                    slideImages: slideImages,
                                    socials: socialsArray,
                                    relationshipStatus: .bestie,
                                    currentRelationshipStartDate: Date.now,
                                    personDescription: personDescription)
                                modelContext.insert(person)
                                print("success")
                                print("\(name) self")
                                dismiss()
                            }
                        } else if debugOn {
                            print("""
                            PersonID: \(generatePersonID())
                            name: \(name)
                            birthday: \(birthday)
                            hexAccentColor: \(accentColor.toHex() ?? "FFFFFF")
                            accentColorIsDefaultBackground: \(accentColorDefaultFgCheck())
                            relationship status: \(relationshipStatus)
                            currentrelationshipstartdate: \(currentRelationshipStartDate)
                            persondescription: \(personDescription)
                            """)
                        }
                    }
                }
            }
            .navigationTitle("Add Self")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddSelfProfileView(debugOn: false)
}
