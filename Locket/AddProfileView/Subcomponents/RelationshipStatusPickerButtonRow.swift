//
//  RelationshipStatusPickerButtonRow.swift
//  Locket
//
//  Created by Justin Damhaut on 17/6/24.
//

import SwiftUI

struct RelationshipStatusPickerButtonRow: View {
    
    @Binding var filterSelection: RelationshipStatus
    var scale: CGFloat = CGFloat(0.65)
    
    
    var body: some View {
        HStack {
            RelationshipStatusPickerButton(selectedRelationshipStatus: $filterSelection, buttonRelationshipStatus: .crush, accentColor: .pink)
            Spacer()
            RelationshipStatusPickerButton(selectedRelationshipStatus: $filterSelection, buttonRelationshipStatus: .relationship, accentColor: .red)
            Spacer()
            RelationshipStatusPickerButton(selectedRelationshipStatus: $filterSelection, buttonRelationshipStatus: .friend, accentColor: .blue)
            Spacer()
            RelationshipStatusPickerButton(selectedRelationshipStatus: $filterSelection, buttonRelationshipStatus: .bestie, accentColor: .indigo)
        }
    }
}

#Preview {
    @Previewable @State var searchFilter: RelationshipStatus = .friend
    RelationshipStatusPickerButtonRow(filterSelection: $searchFilter)
}
