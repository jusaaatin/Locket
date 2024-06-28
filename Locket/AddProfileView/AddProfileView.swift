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
    @State private var resolvedAccentColor: Color.Resolved = Color.Resolved(red: 1.0, green: 1.0, blue: 1.0)
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
    
    func colorToResolved() {
        if accentColor != Color("Foreground-match") {
            accentColorIsDefaultForeground = false
            resolvedAccentColor = accentColor.resolve(in: environment)
        } else {
            accentColorIsDefaultForeground = true
        }
    }
    
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
                        Spacer()
                    }
                    AddProfileViewPerson(name: $name, accentColor: $accentColor, birthday: $birthday)
                        .padding()
                        .onChange(of: accentColor, initial: true, colorToResolved)
                    HStack {
                        Text("        Images")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.gray)
                            .padding(.bottom, -22)
                            .padding(.top)
                        Spacer()
                    }
                    AddProfileViewImages(shownThumbnail: $shownThumbnail, slideImages: $slideImages)
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
                        saveToSocialsArray()
                        if !debugOn {
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
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add Person")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddProfileView(debugOn: true)
}
