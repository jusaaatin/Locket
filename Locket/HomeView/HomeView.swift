//
//  HomeView.swift
//  Locket
//
//  Created by Justin Damhaut on 12/6/24.
//

import SwiftUI
import SwiftData

private func getWidth() -> Int {
    #if os(iOS)
    let screenWidth: Int = Int(UIScreen.main.bounds.width)
    if screenWidth < 500 {
        return ((screenWidth-66)/2)+6
    } else {return 200}
    #else
    return 200
    #endif
}


struct HomeView: View {

    private func returnAccentColor(isFgMatch: Bool, Hex: String) -> Color{
        if isFgMatch {
            return Color("Foreground-match")
        } else {
            return Color(hex: "\(Hex)") ?? Color("Foreground-match")
        }
    }
    private func filterStateToRelationshipStatus(state: filterState) -> RelationshipStatus? {
        switch state {
        case .showAll:
            return nil
        case .crush:
            return .crush
        case .relationship:
            return .relationship
        case .friend:
            return .friend
        case .bestie:
            return .bestie
        }
    }
    private func deletePerson(person: person) {
        print("delete triggered for \(person.name)")
        modelContext.delete(person)
    }
    private func deleteSelected() {
        if hiddenShown {
            for person in personmodel {
                if person.personid < 0 {
                    modelContext.delete(person)
                }
            }
        } else {
            for person in normalPerson {
                if person.personid < 0 {
                    modelContext.delete(person)
                }
            }
        }
    }
    private func pinOrUnpinSelected() {
        if hiddenShown {
            if allSelectedArePinned {
                // unpin all
                for person in personmodel.filter({$0.personid < 0}) {
                    //selected and pinned
                    person.pinToggle()
                }
            } else {
                // pin unpinned peopele
                for person in personmodel.filter({$0.personid < 0}) {
                    //selected
                    if !person.isPinned() {
                        // not pinned
                        person.pinToggle()
                    }
                }
            }
        } else {
            if allSelectedArePinned {
                // unpin all
                for person in normalPerson.filter({$0.personid < 0}) {
                    //selected and pinned
                    person.pinToggle()
                }
            } else {
                // pin unpinned peopele
                for person in normalPerson.filter({$0.personid < 0}) {
                    //selected
                    if !person.isPinned() {
                        // not pinned
                        person.pinToggle()
                    }
                }
            }
        }
    }
    private func hideOrUnhideSelected() {
        if hiddenShown {
            if allSelectedAreHidden {
                // unhide all
                for person in personmodel.filter({$0.personid < 0}) {
                    //selected and hidden
                    person.hiddenToggle()
                }
            } else {
                // hide unpinned peopele
                for person in personmodel.filter({$0.personid < 0}) {
                    //selected
                    if !person.isHiddenProfile() {
                        // not pinned
                        person.hiddenToggle()
                    }
                }
            }
        } else {
            if allSelectedAreHidden {
                // unhide all
                for person in normalPerson.filter({$0.personid < 0}) {
                    //selected and hidden
                    person.hiddenToggle()
                }
            } else {
                // hide unpinned peopele
                for person in normalPerson.filter({$0.personid < 0}) {
                    //selected
                    if !person.isHiddenProfile() {
                        // not pinned
                        person.hiddenToggle()
                    }
                }
            }
        }
    }
    private func selectOrDeselectAll() {
        if hiddenShown {
            if allSelected {
                for person in personmodel {
                    if person.personid < 0 {
                        person.personid.negate()
                    }
                }
            } else {
                for person in personmodel {
                    if person.personid > 0 {
                        person.personid.negate()
                    }
                }
            }
        } else {
            if allSelected {
                for person in normalPerson {
                    if person.personid < 0 {
                        person.personid.negate()
                    }
                }
            } else {
                for person in normalPerson {
                    if person.personid > 0 {
                        person.personid.negate()
                    }
                }
            }
        }
    }
    private func deselectAll() {
        if hiddenShown {
            for person in personmodel {
                if person.personid < 0 {
                    person.personid.negate()
                }
            }
        } else {
            for person in normalPerson {
                if person.personid < 0 {
                    person.personid.negate()
                }
            }
        }
    }
    
    private let twoColumnGrid = [
        GridItem(.adaptive(minimum: CGFloat(getWidth()), maximum: CGFloat(getWidth())), spacing: 22, alignment: .center)
    ]
    @State var searchString: String = ""
    @State var searchFilter: filterState = .showAll
    @State var sortOrder: querySortOrder = .aToZ
    @State var selecting = false
    @State var presentingDeleteAlert = false
    @State var hiddenShown = false // are hidden people being shown?
    @State var isPresented: Bool = false
    
    @Namespace var homeViewNamespace
    @Binding var currentPage: locketPages
    @Environment(\.modelContext) var modelContext
    @Query(sort: \person.priority, order: .reverse) var unQueriedPerson: [person]
    
    var selfProfileExists: Bool {
        if selfPerson == nil {
            return false
        } else {
            return true
        }
    } // does self profile exist?
    var hiddenProfileExists: Bool {
        if hiddenPerson == [] {
            return false
        } else {
            return true
        }
    } // does hidden profile exist?
    var personmodel: [person]{
        if searchString.isEmpty == false {
            if searchFilter == .showAll {
                return unQueriedPerson.filter { $0.name.contains(searchString) && $0.isSelfProfile() != true && $0.isHiddenProfile()}
            } else {
                return unQueriedPerson.filter { $0.name.contains(searchString) && $0.isSelfProfile() != true && $0.relationshipStatus == filterStateToRelationshipStatus(state: searchFilter)}
            }
        } else {
            if searchFilter == .showAll {
                return unQueriedPerson.filter {$0.isSelfProfile() != true}
            } else {
                return unQueriedPerson.filter {$0.isSelfProfile() != true && $0.relationshipStatus == filterStateToRelationshipStatus(state: searchFilter)}
            }
        }
    } // unqueried person, filtered by searchstring and filterstate
    var selfPerson: person? {
        for person in unQueriedPerson {
            if person.isSelfProfile() {
                return person
            }
        }
        return nil
    } // self person (own profile)
    var normalPerson: [person] {
        var innerNormalPerson: [person] = []
        for person in personmodel {
            if !person.isHiddenProfile() {
                innerNormalPerson.append(person)
            }
        }
        if innerNormalPerson != [] {
            return innerNormalPerson
        } else { return [] }
        
    } // people taken from personmodel, unhidden
    var hiddenPerson: [person] {
        var innerHiddenPerson: [person] = []
        for person in personmodel {
            if person.isHiddenProfile() {
                innerHiddenPerson.append(person)
            }
        }
        return innerHiddenPerson
        
    } // people taken from personmodel, hidden
    var allSelected: Bool {
        if hiddenShown {
            if personmodel == [] {
                return false
            } else {
                for person in personmodel {
                    if person.personid > 0 {
                        return false
                    }
                }
            }
        } else {
            if normalPerson == [] {
                return false
            } else {
                for person in normalPerson {
                    if person.personid > 0 {
                        return false
                    }
                }
            }
        }
        return true
    }
    var oneSelected: Bool {
        if hiddenShown {
            for person in personmodel {
                if person.personid < 0 {
                    return true
                }
            }
        } else {
            for person in normalPerson {
                if person.personid < 0 {
                    return true
                }
            }
        }
        return false
    }
    var allSelectedArePinned: Bool {
        if hiddenShown {
            if personmodel == [] {
                return false
            } else {
                for person in personmodel.filter({ $0.personid < 0 }) {
                    if !person.isPinned() {
                        return false
                    }
                }
            }
        } else {
            if normalPerson == [] {
                return false
            } else {
                for person in normalPerson.filter({ $0.personid < 0 }) {
                    if !person.isPinned() {
                        return false
                    }
                }
            }
        }
        return true
    }
    var allSelectedAreHidden: Bool {
        if hiddenShown {
            if personmodel == [] {
                return false
            } else {
                for person in personmodel.filter({ $0.personid < 0 }) {
                    if !person.isHiddenProfile() {
                        return false
                    }
                }
            }
        } else {
            if normalPerson == [] {
                return false
            } else {
                for person in normalPerson.filter({ $0.personid < 0 }) {
                    if !person.isHiddenProfile() {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    HomeViewSearchFilter(filterSelection: $searchFilter, sortOrder: $sortOrder)
                        .padding(.top, -3)
                        .padding(.bottom, 12)
                    LazyVGrid(columns: twoColumnGrid, spacing: 22) {
                        ForEach(normalPerson) { person in
                            @State var deleting = false
                            NavigationLink {
                                ProfileView(
                                    currentRSStatus: person.relationshipStatus,
                                    deleting: $deleting,
                                    currentPage: $currentPage,
                                    bindPerson: person,
                                    demoStartDate: person.currentRelationshipStartDate,
                                    demoEndDate: addOrSubtractYear(year: -1),
                                    name: person.name,
                                    birthday: person.birthday,
                                    instaUser: "username",
                                    telPrefix: "123",
                                    telNumber: "91234567",
                                    accentColor: returnAccentColor(
                                        isFgMatch: person.accentColorIsDefaultForeground,
                                        Hex: person.hexAccentColor),
                                    demo: false,
                                    mainImage: person.shownThumbnail,
                                    slideImages: person.slideImages ?? [Data](),
                                    socials: person.socials ?? [socials](), 
                                    description: person.personDescription, 
                                    creationDate: person.personModelCreationDate,
                                    priority: person.priority
                                )
                                .navigationBarBackButtonHidden()
                                .navigationTransition(
                                    .zoom(
                                        sourceID: person.personid,
                                        in: homeViewNamespace)
                                )
                                .onAppear {
                                    withAnimation(.snappy) { currentPage = .profile }
                                }
                            } label: {
                                ZStack {
                                    HomeViewProfilePreview(
                                        mainWidth: getWidth(),
                                        mainImage: "demofood12",
                                        name: person.name,
                                        birthday: person.birthday,
                                        relationshipStatus: person.relationshipStatus,
                                        accentColor: returnAccentColor(
                                            isFgMatch: person.accentColorIsDefaultForeground,
                                            Hex: person.hexAccentColor),
                                        shownThumbnail: person.shownThumbnail, 
                                        bindPerson: person,
                                        selecting: selecting)
                                    if selecting {
                                        Button(action: {
                                            print("pressed")
                                            person.personid.negate()
                                        }, label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .frame(width:CGFloat(getWidth()), height:CGFloat(218*getWidth()/160))
                                                    .foregroundStyle(.blue.mix(with: .white, by: 0.1))
                                                    .opacity(person.personid > 0 ? 0 : 0.2)
                                                VStack {
                                                    HStack {
                                                        Spacer()
                                                        ZStack {
                                                            Circle()
                                                                .foregroundStyle(person.personid > 0 ? .gray.mix(with: .black, by: 0.2) : .blue)
                                                                .opacity(person.personid > 0 ? 0.8 : 1)
                                                                .frame(width: 28, height: 28)
                                                                .padding(6)
                                                                .offset(y: 2)
                                                            Image(systemName: "checkmark")
                                                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                                                .offset(x: 0, y: 2)
                                                                .foregroundStyle(.white)
                                                                .opacity(person.personid > 0 ? 0 : 1)
                                                        }
                                                    }
                                                    Spacer()
                                                }
                                            }
                                        })
                                    }
                                }
                            }
                            .onAppear() {
                                if person.priority == -1 {
                                    deletePerson(person: person)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .matchedTransitionSource(id: person.personid, in: homeViewNamespace)
                        }
                        if hiddenProfileExists {
                            if hiddenShown {
                                ForEach(hiddenPerson) { person in
                                    @State var deleting = false
                                    NavigationLink {
                                        ProfileView(
                                            currentRSStatus: person.relationshipStatus,
                                            deleting: $deleting,
                                            currentPage: $currentPage,
                                            bindPerson: person,
                                            demoStartDate: person.currentRelationshipStartDate,
                                            demoEndDate: addOrSubtractYear(year: -1),
                                            name: person.name,
                                            birthday: person.birthday,
                                            instaUser: "username",
                                            telPrefix: "123",
                                            telNumber: "91234567",
                                            accentColor: returnAccentColor(
                                                isFgMatch: person.accentColorIsDefaultForeground,
                                                Hex: person.hexAccentColor),
                                            demo: false,
                                            mainImage: person.shownThumbnail,
                                            slideImages: person.slideImages ?? [Data](),
                                            socials: person.socials ?? [socials](),
                                            description: person.personDescription,
                                            creationDate: person.personModelCreationDate,
                                            priority: person.priority
                                        )
                                        .navigationBarBackButtonHidden()
                                        .navigationTransition(
                                            .zoom(
                                                sourceID: person.personid,
                                                in: homeViewNamespace)
                                        )
                                        .onAppear {
                                            withAnimation(.snappy) { currentPage = .profile }
                                        }
                                    } label: {
                                        ZStack {
                                            HomeViewProfilePreview(
                                                mainWidth: getWidth(),
                                                mainImage: "demofood12",
                                                name: person.name,
                                                birthday: person.birthday,
                                                relationshipStatus: person.relationshipStatus,
                                                accentColor: returnAccentColor(
                                                    isFgMatch: person.accentColorIsDefaultForeground,
                                                    Hex: person.hexAccentColor),
                                                shownThumbnail: person.shownThumbnail,
                                                bindPerson: person,
                                                selecting: selecting)
                                            if selecting {
                                                Button(action: {
                                                    print("pressed")
                                                    person.personid.negate()
                                                }, label: {
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .frame(width:CGFloat(getWidth()), height:CGFloat(218*getWidth()/160))
                                                            .foregroundStyle(.blue.mix(with: .white, by: 0.1))
                                                            .opacity(person.personid > 0 ? 0 : 0.2)
                                                        VStack {
                                                            HStack {
                                                                Spacer()
                                                                ZStack {
                                                                    Circle()
                                                                        .foregroundStyle(person.personid > 0 ? .gray.mix(with: .black, by: 0.2) : .blue)
                                                                        .opacity(person.personid > 0 ? 0.8 : 1)
                                                                        .frame(width: 28, height: 28)
                                                                        .padding(6)
                                                                        .offset(y: 2)
                                                                    Image(systemName: "checkmark")
                                                                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                                                        .offset(x: 0, y: 2)
                                                                        .foregroundStyle(.white)
                                                                        .opacity(person.personid > 0 ? 0 : 1)
                                                                }
                                                            }
                                                            Spacer()
                                                        }
                                                    }
                                                })
                                            }
                                        }
                                    }
                                    .onAppear() {
                                        if person.priority == -1 {
                                            deletePerson(person: person)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .matchedTransitionSource(id: person.personid, in: homeViewNamespace)
                                }
                            } else {
                                Button(action: {
                                    hiddenShown = true
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width:CGFloat(getWidth()), height:CGFloat(218*getWidth()/160))
                                            .foregroundStyle(.thickMaterial)
                                        Image(systemName: "eye.slash")
                                            .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                            
                                    }
                                }).buttonStyle(PlainButtonStyle())
                            }
                        }
                    }.id(UUID())
                    if hiddenShown && hiddenProfileExists {
                        Button(action: {
                            hiddenShown = false
                        }, label: {
                            HStack {
                                Image(systemName: "eye.slash")
                                Text("Hide Hidden People")
                            }
                            .foregroundStyle(.gray)
                            .padding()
                            .frame(width: 240)
                            .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }).buttonStyle(PlainButtonStyle())
                    }
                }
                .scrollIndicators(.hidden)
                .padding([.leading, .trailing])
                .navigationBarTitle("People", displayMode: .large)
                .toolbar(content:{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            withAnimation {
                                if selecting == true {
                                    deselectAll()
                                }
                                selecting.toggle()
                            }
                        }, label: {
                            HStack {
                                Text(selecting ? "Cancel" : "Select")
                                    .foregroundStyle(Color("Foreground-match"))
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                            }.frame(height: 18)
                            .padding([.leading, .trailing], 12)
                            .foregroundStyle(.black)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("Background-match").mix(with:.gray, by: 0.6).opacity(0.6))
                                    .frame(height: 32)
                            }
                            .padding(.trailing, -12)
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            

                        }, label: {
                            if let selfPFPData = selfPerson?.shownThumbnail {
                                let selfPFP = UIImage(data: selfPFPData)
                                Image(uiImage: selfPFP ?? UIImage())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:38, height:38)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(.thickMaterial, lineWidth: 3)
                                        )
                            } else {
                                Image("demofoodprofile")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:38, height:38)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(.thickMaterial, lineWidth: 3)
                                        )
                            }
                        })
                    }
                })
            }
            .sheet(isPresented: $isPresented) {
                AddProfileView(debugOn: false).interactiveDismissDisabled()
            }
            .searchable(text: $searchString)
            VStack {
                Spacer()
                HStack {
                    if selecting {
                        HStack {
                            Button(action: {
                                selectOrDeselectAll()
                            }, label: {
                                Text(allSelected ? "Deselect All" : "Select All")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    .frame(width: 100)
                                    .padding([.leading, .trailing], 8)
                                    .padding([.top, .bottom], 8)
                                    .background {
                                        RoundedRectangle(cornerRadius: 50)
                                                .foregroundStyle(.thinMaterial)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 50)
                                                        .stroke(Color.gray.mix(with:Color("Background-match"), by: 0.6), lineWidth: 3)
                                                )
                                    }
                            })
                            .alert("Delete selected people?", isPresented: $presentingDeleteAlert) { //delete
                                Button("Delete", role: .destructive) {
                                    deleteSelected()
                                    selecting = false
                                    deselectAll()
                                }
                            } message: {
                                Text("Are you sure you want to delete the selected people? Once deleted, these contacts can not be recovered")
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.leading)
                            Button(role: .destructive, action: {
                                presentingDeleteAlert = true
                            }, label: {
                                Text("Delete")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.red)
                                    .frame(width: 60)
                                    .padding([.leading, .trailing], 8)
                                    .padding([.top, .bottom], 8)
                                    .background {
                                        RoundedRectangle(cornerRadius: 50)
                                                .foregroundStyle(.thinMaterial)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 50)
                                                        .stroke(Color.gray.mix(with:Color("Background-match"), by: 0.6), lineWidth: 3)
                                                )
                                    }
                            })
                            .disabled(!oneSelected)
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                pinOrUnpinSelected()
                                selecting = false
                                deselectAll()
                            }, label: {
                                Image(systemName: allSelectedArePinned ? "pin.slash" : "pin.fill")
                                    .frame(width: 12, height: 16)
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .clipped()
                                    .padding([.leading, .trailing], 8)
                                    .padding([.top, .bottom], 8)
                                    .frame(width: 32, height: 32)
                                    .background {
                                        RoundedRectangle(cornerRadius: 50)
                                                .foregroundStyle(.thinMaterial)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 50)
                                                        .stroke(Color.gray.mix(with:Color("Background-match"), by: 0.6), lineWidth: 3)
                                                )
                                    }
                            })
                            .disabled(!oneSelected)
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                hideOrUnhideSelected()
                                selecting = false
                                deselectAll()
                            }, label: {
                                Image(systemName: allSelectedAreHidden ? "eye.fill" : "eye.slash")
                                    .frame(width: 16, height: 16)
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .clipped()
                                    .padding([.leading, .trailing], 8)
                                    .padding([.top, .bottom], 8)
                                    .frame(width: 32, height: 32)
                                    .background {
                                        RoundedRectangle(cornerRadius: 50)
                                                .foregroundStyle(.thinMaterial)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 50)
                                                        .stroke(Color.gray.mix(with:Color("Background-match"), by: 0.6), lineWidth: 3)
                                                )
                                    }
                            })
                            .disabled(!oneSelected)
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                        .offset(y: -25)
                    } else {
                        Spacer()
                        AddProfileButton(isPresented: $isPresented)
                            .shadow(color: .black.opacity(0.5), radius: 8)
                            .padding()
                            .padding(.trailing, 1)
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var editIsPresented = false
    @Previewable @State var currentPage: locketPages = .home
    HomeView(currentPage: $currentPage)
}

