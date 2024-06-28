//
//  filterButtonTrailingRow.swift
//  Locket
//
//  Created by Justin Damhaut on 14/6/24.
//

import SwiftUI

struct filterButtonTrailingRow: View {
    
    @Binding var filterSelection: filterState
    var scale: CGFloat = CGFloat(0.65)
    
    
    var body: some View {
        HStack {
            Filterbutton(selectedRelationshipStatus: $filterSelection, buttonRelationshipStatus: .crush, accentColor: .pink)
                .scaleEffect(x: scale, y: scale)
                .frame(width: 78*scale, height:61*scale)
                .clipped()
            Filterbutton(selectedRelationshipStatus: $filterSelection, buttonRelationshipStatus: .relationship, accentColor: .red)
                .scaleEffect(x: scale, y: scale)
                .frame(width: 78*scale, height:61*scale)
                .clipped()
            Filterbutton(selectedRelationshipStatus: $filterSelection, buttonRelationshipStatus: .friend, accentColor: .blue)
                .scaleEffect(x: scale, y: scale)
                .frame(width: 78*scale, height:61*scale)
                .clipped()            
            Filterbutton(selectedRelationshipStatus: $filterSelection, buttonRelationshipStatus: .bestie, accentColor: .indigo)
                .scaleEffect(x: scale, y: scale)
                .frame(width: 78*scale, height:61*scale)
                .clipped()
        }
    }
}

#Preview {
    @Previewable @State var searchFilter: filterState = .showAll
    filterButtonTrailingRow(filterSelection: $searchFilter)
}
