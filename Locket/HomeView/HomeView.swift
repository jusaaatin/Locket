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

    
    private let twoColumnGrid = [
        GridItem(.adaptive(minimum: CGFloat(getWidth()), maximum: CGFloat(getWidth())), spacing: 22, alignment: .center)
    ]
    
    private func returnAccentColor(isFgMatch: Bool, Hex: String) -> Color{
        if isFgMatch {
            return Color("Foreground-match")
        } else {
            return Color(hex: "\(Hex)") ?? Color("Foreground-match")
        }
    }
    
    @State var searchString: String = ""
    @State var searchFilter: filterState = .showAll
    @State var sortOrder: querySortOrder = .aToZ
    @Namespace var homeViewNamespace
    @Binding var currentPage: locketPages
    @Environment(\.modelContext) var modelContext
    @Query var unQueriedPerson: [person]
    @State var isPresented: Bool = false
    
    var person: [person]{
        guard searchString.isEmpty == false else { return unQueriedPerson }
        return unQueriedPerson.filter { $0.name.contains(searchString)}
    }
    
    private func deletePerson(person: person) {
        print("delete triggered for \(person.name)")
        modelContext.delete(person)
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    HomeViewSearchFilter03(filterSelection: $searchFilter, sortOrder: $sortOrder)
                        .padding(.top, -3)
                        .padding(.bottom, 12)
                    LazyVGrid(columns: twoColumnGrid, spacing: 22) {
                        ForEach(person) { person in
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
                                    priority: person.priority
                                )
                                .navigationBarBackButtonHidden()
                                .navigationTransition(
                                    .zoom(
                                        sourceID: person,
                                        in: homeViewNamespace)
                                )
                                .onAppear {
                                    withAnimation(.snappy) { currentPage = .profile }
                                }
                            } label: {
                                HomeViewProfilePreview04(
                                    mainWidth: getWidth(),
                                    mainImage: "demofood12",
                                    name: person.name,
                                    birthday: person.birthday,
                                    relationshipStatus: person.relationshipStatus,
                                    conditionalActivate: false,
                                    accentColor: returnAccentColor(
                                        isFgMatch: person.accentColorIsDefaultForeground,
                                        Hex: person.hexAccentColor),
                                    shownThumbnail: person.shownThumbnail)
                            }
                            .onAppear() {
                                if person.priority == -1 {
                                    deletePerson(person: person)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .matchedTransitionSource(id: person, in: homeViewNamespace)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding([.leading, .trailing])
                .navigationTitle("Locket")
                .toolbar(content:{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            
                        }, label: {
                            Image("demofoodprofile")
                                .resizable()
                                .scaledToFill()
                                .frame(width:42, height:42)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(.thickMaterial, lineWidth: 3)
                                )
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
                    Spacer()
                    addProfileButton(isPresented: $isPresented)
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

