//
//  FilterButtonLeading.swift
//  Locket
//
//  Created by Justin Damhaut on 14/6/24.
//

import SwiftUI

struct FilterButtonLeading: View {
    
    @Binding var selectedRelationshipStatus: filterState
    @Binding var selectedSortOrder: querySortOrder
    
    let accentColor: Color
    
    private func returnLeft() -> String {
        switch selectedRelationshipStatus {
        case .showAll:
            return "line.3.horizontal.decrease"
        case .crush:
            return "heart"
        case .relationship:
            return "heart.fill"
        case .bestie:
            return "figure.2"
        case .friend:
            return "person.2"
        }
    }
    private func returnLeftSize() -> CGFloat {
        switch selectedRelationshipStatus {
        case .showAll:
            return CGFloat(24)
        case .crush:
            return CGFloat(26)
        case .relationship:
            return CGFloat(26)
        case .friend:
            return CGFloat(21)
        case .bestie:
            return CGFloat(20)
        }
    }
    private func returnRight() -> String {
        switch selectedRelationshipStatus {
        case .showAll:
            return "Filter"
        case .crush:
            return "Crushes"
        case .relationship:
            return "Partner"
        case .friend:
            return "Friends"
        case .bestie:
            return "Besties"
        }
    }
    private func filterMenuTickLogic(buttonRelationshipStatus: filterState) -> String {
        if selectedRelationshipStatus == buttonRelationshipStatus {
            return "checkmark"
        } else {
            return ""
        }
    }
    private func sortMenuTickLogic(buttonSortOrder: querySortOrder) -> String {
        if selectedSortOrder == buttonSortOrder {
            return "checkmark"
        } else {
            return ""
        }
    }
    
    
    var body: some View {
        Menu {
            Section("Sort People") {
                Button(action: {
                    withAnimation(.snappy) {
                        selectedSortOrder = .aToZ
                    }
                }) {
                    Label("A to Z", systemImage: sortMenuTickLogic(buttonSortOrder: .aToZ))
                }
                Button(action: {
                    withAnimation(.snappy) {
                        selectedSortOrder = .zToA
                    }
                }) {
                    Label("Z to A", systemImage: sortMenuTickLogic(buttonSortOrder: .zToA))
                }
                Button(action: {
                    withAnimation(.snappy) {
                        selectedSortOrder = .createdNewest
                    }
                }) {
                    Label("Created Newest", systemImage: sortMenuTickLogic(buttonSortOrder: .createdNewest))
                }
                Button(action: {
                    withAnimation(.snappy) {
                        selectedSortOrder = .createdOldest
                    }
                }) {
                    Label("Created Oldest", systemImage: sortMenuTickLogic(buttonSortOrder: .createdOldest))
                }
                Button(action: {
                    withAnimation(.snappy) {
                        selectedSortOrder = .birthdayFirstToLast
                    }
                }) {
                    Label("Nearest Birthday", systemImage: sortMenuTickLogic(buttonSortOrder: .birthdayFirstToLast))
                }
            }
            Section("Filter People"){
                Button(action: {
                    withAnimation(.snappy) {
                        selectedRelationshipStatus = .showAll
                    }
                }) {
                    Label("Show All People", systemImage: filterMenuTickLogic(buttonRelationshipStatus: .showAll))
                }
                Button(action: {
                    withAnimation(.snappy) {
                        selectedRelationshipStatus = .crush
                    }
                }) {
                    Label("Show Crushes", systemImage: filterMenuTickLogic(buttonRelationshipStatus: .crush))
                }
                Button(action: {
                    withAnimation(.snappy) {
                        selectedRelationshipStatus = .relationship
                    }
                }) {
                    Label("Show Partner", systemImage: filterMenuTickLogic(buttonRelationshipStatus: .relationship))
                }
                Button(action: {
                    withAnimation(.snappy) {
                        selectedRelationshipStatus = .friend
                    }
                }) {
                    Label("Show Friends", systemImage: filterMenuTickLogic(buttonRelationshipStatus: .friend))
                }
                Button(action: {
                    withAnimation(.snappy) {
                        selectedRelationshipStatus = .bestie
                    }
                }) {
                    Label("Show Besties", systemImage: filterMenuTickLogic(buttonRelationshipStatus: .bestie))
                }
            }
            Button(role: .destructive, action: {
                withAnimation(.snappy) {
                    selectedSortOrder = .aToZ
                    selectedRelationshipStatus = .showAll
                }
            }) {
                Label("Reset Filters", systemImage: "trash.fill")
                    
            }
        } label: {
            HStack {
                Image(systemName: returnLeft())
                    .font(.system(size: returnLeftSize()))
                Text(returnRight())
                    .font(.system(size:22))
                
            }
        }
        .frame(width: 152, height:61)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .buttonStyle(PlainButtonStyle())
        .clipped()
        .minimumScaleFactor(0.1)
    }
}

#Preview {
    @Previewable @State var searchFilter1: filterState = .showAll
    @Previewable @State var sortOrder: querySortOrder = .aToZ
    FilterButtonLeading(selectedRelationshipStatus: $searchFilter1, selectedSortOrder: $sortOrder , accentColor: .red)
}
