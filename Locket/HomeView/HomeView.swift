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
    
    private let twoColumnGrid = [
        GridItem(.adaptive(minimum: CGFloat(getWidth()), maximum: CGFloat(getWidth())), spacing: 22, alignment: .center)
    ]
    @State var searchString: String = ""
    @State var searchFilter: filterState = .showAll
    @State var sortOrder: querySortOrder = .aToZ
    @Namespace var homeViewNamespace
    @Binding var currentPage: locketPages
    @Environment(\.modelContext) var modelContext
    @Query(sort: \person.priority, order: .reverse) var unQueriedPerson: [person]
    @State var isPresented: Bool = false
    @State var selfProfileExists: Bool = false
    var personmodel: [person]{
        if searchString.isEmpty == false {
            if searchFilter == .showAll {
                return unQueriedPerson.filter { $0.name.contains(searchString) && $0.isSelfProfile() != true}
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
    }
    var selfPerson: person? {
        for person in unQueriedPerson {
            if person.isSelfProfile() {
                selfProfileExists = true
                return person
            }
        }
        selfProfileExists = false
        return nil
    }
    @State var selecting = true
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    HomeViewSearchFilter(filterSelection: $searchFilter, sortOrder: $sortOrder)
                        .padding(.top, -3)
                        .padding(.bottom, 12)
                    LazyVGrid(columns: twoColumnGrid, spacing: 22) {
                        ForEach(personmodel) { person in
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
                                HomeViewProfilePreview(
                                    mainWidth: getWidth(),
                                    mainImage: "demofood12",
                                    name: person.name,
                                    birthday: person.birthday,
                                    relationshipStatus: person.relationshipStatus,
                                    accentColor: returnAccentColor(
                                        isFgMatch: person.accentColorIsDefaultForeground,
                                        Hex: person.hexAccentColor),
                                    shownThumbnail: person.shownThumbnail, bindPerson: person, selecting: selecting)
                            }
                            .onAppear() {
                                if person.priority == -1 {
                                    deletePerson(person: person)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .matchedTransitionSource(id: person.personid, in: homeViewNamespace)
                        }
                    }.id(UUID())
                }
                .scrollIndicators(.hidden)
                .padding([.leading, .trailing])
                .navigationBarTitle("People", displayMode: .large)
                .toolbar(content:{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            
                        }, label: {
                            HStack {
                                Text("Select")
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
                    Button(action: {
                        
                    }, label: {
                        Text("Deselect All")
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
                    .buttonStyle(PlainButtonStyle())
                    .padding(.leading)
                    Button(role: .destructive, action: {
                        
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
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing)
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

#Preview {
    @Previewable @State var editIsPresented = false
    @Previewable @State var currentPage: locketPages = .home
    HomeView(currentPage: $currentPage)
}

