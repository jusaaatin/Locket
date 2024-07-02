//
//  EditProfileView.swift
//  Locket
//
//  Created by Justin Damhaut on 30/6/24.
//

import SwiftUI
import Combine
import Photos
import PhotosUI

struct EditProfileView: View {
    @Environment(\.self) var environment
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State var debugOn: Bool
    
    //person
    @State private var name: String = ""
    @State private var accentColor: Color = Color("Foreground-match")
    @State private var hexInputColor: String = ""
    @State private var birthday: Date = .now
    @State private var bDay: String = ""
    @State private var bMonth: String = ""
    @State private var bYear: String = ""
    @State private var initialAccentIsDefFg: Bool = false
    @State private var priority = 0
    
    
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
    @State var rDay: String = ""
    @State var rMonth: String = ""
    @State var rYear: String = ""
    
    //description??
    @State private var personDescription: String = ""

    
    //checklistOk
    @State private var nameNotOk = false
    @State private var birthdayNotOk = false
    @State private var thumbnailNotOk = false
    @State private var socialsNotOk = false
    
    @State private var birthdayChanged = false
    
    //alerts
    @State private var showDeleteAlert = false
    @State private var showDuplicateAlert = false
    
    let bindedPerson: person
    
    

    
    func saveToSocialsArray() {
        for i in 0...additionalSocialsCount {
            if !isHidden[i] {
                socialsArray.append(socials(socialPlatform: socialPlatform[i], stringPRE: stringPRE[i], stringMAIN: stringMAIN[i]))
            }
        }
    }
    func saveToCheckerSocialsArray() {
        for i in 0...additionalSocialsCount {
            if !isHidden[i] {
                checkerSocialsArray.append(socials(socialPlatform: socialPlatform[i], stringPRE: stringPRE[i], stringMAIN: stringMAIN[i]))
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
    func saveEdits() {
        bindedPerson.name = name
        bindedPerson.birthday = birthday
        bindedPerson.hexAccentColor = accentColor.toHex() ?? "FFFFFF"
        bindedPerson.accentColorIsDefaultForeground = accentColorDefaultFgCheck()
        bindedPerson.shownThumbnail = shownThumbnail
        bindedPerson.slideImages = slideImages
        bindedPerson.socials = socialsArray
        bindedPerson.relationshipStatus = relationshipStatus
        bindedPerson.currentRelationshipStartDate = currentRelationshipStartDate
        bindedPerson.personDescription = personDescription
        bindedPerson.priority = priority
    }
    func returnSocialString(social: [socials], which: Int) -> [String] {
        if which == 1 {
            return social.map { $0.stringPRE }
        } else {
            return social.map { $0.stringMAIN }
        }
    }
    func returnSocialType(social: [socials]) -> [socialPlatforms] {
        return social.map { $0.socialPlatform}
    }
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
                    AddProfileViewPerson(name: $name, accentColor: $accentColor, birthday: $birthday, startDay: $bDay, startMonth: $bMonth, startYear: $bYear, hexInput: bindedPerson.hexAccentColor, accentColorIsDefFg: bindedPerson.accentColorIsDefaultForeground)
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
                        Text("        Relationship")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.gray)
                            .padding(.bottom, -22)
                            .padding(.top)
                        Spacer()
                    }
                    AddProfileViewRelationships(relationshipStatus: $relationshipStatus, currentRelationshipStartDate: $currentRelationshipStartDate, rDay: $rDay, rMonth: $rMonth, rYear: $rYear)
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
                    HStack {
                        Button(action: {
                            showDuplicateAlert = true
                        }, label: {
                            HStack {
                                Image(systemName: "square.on.square")
                                Text("Duplicate")
                            }
                            .padding()
                            .frame(width: 140)
                            .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        })
                        Button(role: .destructive, action: {
                            showDeleteAlert = true
                        }, label: {
                            HStack {
                                Image(systemName: "trash.fill")
                                Text("Delete")
                            }
                            .padding()
                            .frame(width: 140)
                            .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        })
                    }
                    .alert("Delete \(bindedPerson.name)?", isPresented: $showDeleteAlert) { //delete
                        Button("Delete", role: .destructive) {
                            priority = -1
                            saveEdits()
                            dismiss()
                        }
                    } message: {
                        Text("Are you sure you want to delete \(bindedPerson.name)? Once deleted, this contact can not be recovered")
                    }
                    .alert("Duplicate \(bindedPerson.name)?", isPresented: $showDuplicateAlert) { //delete
                        Button("Cancel", role: .cancel) { }
                        Button("Duplicate") {
                            if !debugOn {
                                saveToCheckerSocialsArray()
                                if checklistOk() && socialsChecklistOk(){
                                    nameNotOk = false
                                    birthdayNotOk = false
                                    thumbnailNotOk = false
                                    saveToSocialsArray()
                                    let insertedperson = person(
                                        personid: generatePersonID(),
                                        name: name,
                                        birthday: birthday,
                                        hexAccentColor: accentColor.toHex() ?? "FFFFFF",
                                        accentColorIsDefaultForeground: accentColorDefaultFgCheck(),
                                        shownThumbnail: shownThumbnail,
                                        slideImages: slideImages,
                                        socials: socialsArray,
                                        relationshipStatus: relationshipStatus,
                                        currentRelationshipStartDate: currentRelationshipStartDate,
                                        personDescription: personDescription)
                                    modelContext.insert(insertedperson)
                                    print("success on duplicating")
                                    print("\(name)")
                                    checkerSocialsArray.removeAll()
                                    dismiss()
                                } else if !checklistOk() || !socialsChecklistOk(){
                                    if name == "" {nameNotOk = true} else {nameNotOk = false}
                                    if bDay.count == 2 && bMonth.count == 2 && bYear.count == 4 {birthdayNotOk = false} else {birthdayNotOk = true}
                                    if shownThumbnail == Data() {thumbnailNotOk = true} else {thumbnailNotOk = false}
                                    if socialsChecklistOk() {socialsNotOk = false} else {socialsNotOk = true}
                                    checkerSocialsArray.removeAll()
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
                    } message: {
                        Text("Are you sure you want to duplicate \(bindedPerson.name)?")
                    }
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 60, weight: .semibold, design: .rounded))
                        .foregroundStyle(.gray.opacity(0.5))
                        .padding()
                        .padding(.bottom, 30)
                }
            }.scrollIndicators(.hidden)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        if !debugOn {
                            saveToCheckerSocialsArray()
                            if checklistOk() && socialsChecklistOk(){
                                nameNotOk = false
                                birthdayNotOk = false
                                thumbnailNotOk = false
                                saveToSocialsArray()
                                print("success")
                                print("\(name)")
                                checkerSocialsArray.removeAll()
                                saveEdits()
                                dismiss()
                            } else if !checklistOk() || !socialsChecklistOk(){
                                if name == "" {nameNotOk = true} else {nameNotOk = false}
                                if bDay.count == 2 && bMonth.count == 2 && bYear.count == 4 {birthdayNotOk = false} else {birthdayNotOk = true}
                                if shownThumbnail == Data() {thumbnailNotOk = true} else {thumbnailNotOk = false}
                                if socialsChecklistOk() {socialsNotOk = false} else {socialsNotOk = true}
                                checkerSocialsArray.removeAll()
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
                            dismiss()
                        }
                        
                    }
                }
            }
            .navigationTitle("Edit \(bindedPerson.name)")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                name = bindedPerson.name
                bDay = dateToDMY(input: bindedPerson.birthday, type: 1)
                bMonth = dateToDMY(input: bindedPerson.birthday, type: 2)
                bYear = dateToDMY(input: bindedPerson.birthday, type: 3)
                hexInputColor = bindedPerson.hexAccentColor
                initialAccentIsDefFg = bindedPerson.accentColorIsDefaultForeground
                shownThumbnail = bindedPerson.shownThumbnail
                slideImages = bindedPerson.slideImages ?? [Data]()
                socialPlatform.removeAll()
                stringPRE.removeAll()
                stringMAIN.removeAll()
                isHidden.removeAll()
                additionalSocialsCount = -1
                visibleSocialsCount = 0
                socialPlatform.append(contentsOf: returnSocialType(social: bindedPerson.socials ?? [socials]()))
                stringPRE.append(contentsOf: returnSocialString(social: bindedPerson.socials ?? [socials](), which: 1))
                stringMAIN.append(contentsOf: returnSocialString(social: bindedPerson.socials ?? [socials](), which: 2))
                if let socialsCountSH = bindedPerson.socials{
                    additionalSocialsCount += socialsCountSH.count
                    visibleSocialsCount += socialsCountSH.count
                    if socialsCountSH.count != 0 {
                        for _ in 1 ... socialsCountSH.count {
                            isHidden.append(false)
                        }
                    }
                }
                relationshipStatus = bindedPerson.relationshipStatus
                rDay = dateToDMY(input: bindedPerson.currentRelationshipStartDate, type: 1)
                rMonth = dateToDMY(input: bindedPerson.currentRelationshipStartDate, type: 2)
                rYear = dateToDMY(input: bindedPerson.currentRelationshipStartDate, type: 3)
                personDescription = bindedPerson.personDescription
            }
        }
    }
}
/*
#Preview {
    EditProfileView(debugOn: false, bindedPerson: person())
}
*/
