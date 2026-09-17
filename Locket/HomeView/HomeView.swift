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
        modelContext.delete(person)
    }
    private func deleteSelected() {
        for person in selectedPeople {
            modelContext.delete(person)
        }
        selectedPersonIDs.removeAll()
    }
    private func pinOrUnpinSelected() {
        let shouldUnpin = allSelectedArePinned
        for person in selectedPeople {
            if shouldUnpin ? person.isPinned() : !person.isPinned() {
                person.pinToggle()
                person.prioritySetter()
            }
        }
    }
    private func hideOrUnhideSelected() {
        let shouldUnhide = allSelectedAreHidden
        for person in selectedPeople {
            if shouldUnhide ? person.isHiddenProfile() : !person.isHiddenProfile() {
                person.hiddenToggle()
                person.prioritySetter()
            }
        }
    }
    private func selectOrDeselectAll() {
        if allSelected {
            selectedPersonIDs.removeAll()
        } else {
            selectedPersonIDs = Set(displayedPeople.map(\.personUUID))
        }
    }
    private func deselectAll() {
        selectedPersonIDs.removeAll()
    }
    private func toggleSelection(for person: person) {
        if selectedPersonIDs.contains(person.personUUID) {
            selectedPersonIDs.remove(person.personUUID)
        } else {
            selectedPersonIDs.insert(person.personUUID)
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
    @State var selfProfileIsPresented: Bool = false
    @State var selfProfileDeleting: Bool = false
    @State private var selectedPersonIDs: Set<UUID> = []
    
    @Namespace var homeViewNamespace
    @Binding var currentPage: locketPages
    @Environment(\.modelContext) var modelContext
    @Query(sort: \person.priority, order: .reverse) var unQueriedPerson: [person]
    
    var selfProfileExists: Bool {
        selfPerson != nil
    } // does self profile exist?
    var hiddenProfileExists: Bool {
        !hiddenPerson.isEmpty
    } // does hidden profile exist?
    var personmodel: [person]{
        let searchTerm = searchString.trimmingCharacters(in: .whitespacesAndNewlines)
        let relationship = filterStateToRelationshipStatus(state: searchFilter)
        let filtered = unQueriedPerson.filter { person in
            guard !person.isSelfProfile() else { return false }
            let matchesSearch = searchTerm.isEmpty || person.name.localizedCaseInsensitiveContains(searchTerm)
            let matchesRelationship = relationship == nil || person.relationshipStatus == relationship
            return matchesSearch && matchesRelationship
        }

        switch sortOrder {
        case .aToZ:
            return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .zToA:
            return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case .createdNewest:
            return filtered.sorted { $0.personModelCreationDate > $1.personModelCreationDate }
        case .createdOldest:
            return filtered.sorted { $0.personModelCreationDate < $1.personModelCreationDate }
        case .birthdayFirstToLast:
            return filtered.sorted { nextBirthday(for: $0.birthday) < nextBirthday(for: $1.birthday) }
        }
    } // unqueried person, filtered by searchstring and filterstate
    var selfPerson: person? {
        unQueriedPerson.first(where: { $0.isSelfProfile() })
    } // self person (own profile)
    var normalPerson: [person] {
        personmodel.filter { !$0.isHiddenProfile() }
    } // people taken from personmodel, unhidden
    var hiddenPerson: [person] {
        personmodel.filter { $0.isHiddenProfile() }
    } // people taken from personmodel, hidden
    var displayedPeople: [person] {
        hiddenShown ? personmodel : normalPerson
    }
    var selectedPeople: [person] {
        displayedPeople.filter { selectedPersonIDs.contains($0.personUUID) }
    }
    var allSelected: Bool {
        !displayedPeople.isEmpty && displayedPeople.allSatisfy { selectedPersonIDs.contains($0.personUUID) }
    }
    var oneSelected: Bool {
        !selectedPeople.isEmpty
    }
    var allSelectedArePinned: Bool {
        !selectedPeople.isEmpty && selectedPeople.allSatisfy { $0.isPinned() }
    }
    var allSelectedAreHidden: Bool {
        !selectedPeople.isEmpty && selectedPeople.allSatisfy { $0.isHiddenProfile() }
    }

    private func nextBirthday(for birthday: Date) -> Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let birthdayComponents = calendar.dateComponents([.month, .day], from: birthday)
        return calendar.nextDate(
            after: calendar.date(byAdding: .day, value: -1, to: today) ?? today,
            matching: birthdayComponents,
            matchingPolicy: .nextTime
        ) ?? .distantFuture
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
                                    slideImages: person.slideImages ?? [],
                                    socials: person.socials ?? [],
                                    description: person.personDescription,
                                    creationDate: person.personModelCreationDate,
                                    priority: person.priority,
                                    selfProfileExists: selfProfileExists
                                )
                                .navigationBarBackButtonHidden()
                                .navigationTransition(
                                    .zoom(
                                        sourceID: person.personUUID,
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
                                            toggleSelection(for: person)
                                        }, label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .frame(width:CGFloat(getWidth()), height:CGFloat(218*getWidth()/160))
                                                    .foregroundStyle(.blue.mix(with: .white, by: 0.1))
                                                    .opacity(selectedPersonIDs.contains(person.personUUID) ? 0.2 : 0)
                                                VStack {
                                                    HStack {
                                                        Spacer()
                                                        ZStack {
                                                            Circle()
                                                                .foregroundStyle(selectedPersonIDs.contains(person.personUUID) ? .blue : .gray.mix(with: .black, by: 0.2))
                                                                .opacity(selectedPersonIDs.contains(person.personUUID) ? 1 : 0.8)
                                                                .frame(width: 28, height: 28)
                                                                .padding(6)
                                                                .offset(y: 2)
                                                            Image(systemName: "checkmark")
                                                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                                                .offset(x: 0, y: 2)
                                                                .foregroundStyle(.white)
                                                                .opacity(selectedPersonIDs.contains(person.personUUID) ? 1 : 0)
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
                            .matchedTransitionSource(id: person.personUUID, in: homeViewNamespace)
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
                                            slideImages: person.slideImages ?? [],
                                            socials: person.socials ?? [],
                                            description: person.personDescription,
                                            creationDate: person.personModelCreationDate,
                                            priority: person.priority,
                                            selfProfileExists: selfProfileExists
                                        )
                                        .navigationBarBackButtonHidden()
                                        .navigationTransition(
                                            .zoom(
                                                sourceID: person.personUUID,
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
                                                    toggleSelection(for: person)
                                                }, label: {
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .frame(width:CGFloat(getWidth()), height:CGFloat(218*getWidth()/160))
                                                            .foregroundStyle(.blue.mix(with: .white, by: 0.1))
                                                            .opacity(selectedPersonIDs.contains(person.personUUID) ? 0.2 : 0)
                                                        VStack {
                                                            HStack {
                                                                Spacer()
                                                                ZStack {
                                                                    Circle()
                                                                        .foregroundStyle(selectedPersonIDs.contains(person.personUUID) ? .blue : .gray.mix(with: .black, by: 0.2))
                                                                        .opacity(selectedPersonIDs.contains(person.personUUID) ? 1 : 0.8)
                                                                        .frame(width: 28, height: 28)
                                                                        .padding(6)
                                                                        .offset(y: 2)
                                                                    Image(systemName: "checkmark")
                                                                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                                                        .offset(x: 0, y: 2)
                                                                        .foregroundStyle(.white)
                                                                        .opacity(selectedPersonIDs.contains(person.personUUID) ? 1 : 0)
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
                                    .matchedTransitionSource(id: person.personUUID, in: homeViewNamespace)
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
                    }
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
                            selfProfileIsPresented = true
                        }, label: {
                            if let selfPFPData = selfPerson?.shownThumbnail,
                               let selfPFP = StoredImageCache.image(from: selfPFPData) {
                                Image(uiImage: selfPFP)
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
                        .sheet(isPresented: $selfProfileIsPresented) {
                            SettingsView(selfProfileDeleting: $selfProfileDeleting, currentPage: $currentPage, bindPerson: selfPerson)
                                .presentationDragIndicator(.visible)
                        }
                        .onAppear() {
                            for person in unQueriedPerson {
                                if person.priority == -1 {
                                    modelContext.delete(person)
                                }
                            }
                        }
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
