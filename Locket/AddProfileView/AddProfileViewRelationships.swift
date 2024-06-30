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
    
    @Binding var rDay: String
    @Binding var rMonth: String
    @Binding var rYear: String
    
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
                RelationshipStartDatePicker(startDay: $rDay, startMonth: $rMonth, startYear: $rYear, selectedDate: $currentRelationshipStartDate)
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
    
    @Previewable @State var rDay = ""
    @Previewable @State var rMonth = ""
    @Previewable @State var rYear = ""
    
    AddProfileViewRelationships(relationshipStatus: $relationshipStatus, currentRelationshipStartDate: $currentRelationshipStartDate, rDay: $rDay, rMonth: $rMonth, rYear: $rYear)
        .padding()
}
