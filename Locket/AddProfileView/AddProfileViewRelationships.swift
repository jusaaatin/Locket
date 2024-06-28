//
//  AddProfileViewRelationships.swift
//  Locket
//
//  Created by Justin Damhaut on 20/6/24.
//

import SwiftUI

struct AddProfileViewRelationships: View {
    
    @Binding var relationshipStatus: RelationshipStatus
    @Binding var currentRelationshipStartDate: Date
    
    var body: some View {
        VStack {
            RelationshipStatusPickerButtonRow(filterSelection: $relationshipStatus)
                .padding(.bottom, 8)
                .minimumScaleFactor(0.1)
            Divider()
            HStack {
                Text("Start Date")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                RelationshipStartDatePicker(selectedDate: $currentRelationshipStartDate)
                    .frame(width: 190)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    
    @Previewable @State var relationshipStatus: RelationshipStatus = .crush
    @Previewable @State var currentRelationshipStartDate: Date = .now
    
    AddProfileViewRelationships(relationshipStatus: $relationshipStatus, currentRelationshipStartDate: $currentRelationshipStartDate)
        .padding()
}
