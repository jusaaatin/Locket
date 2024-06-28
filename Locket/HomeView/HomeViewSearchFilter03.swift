//
//  HomeViewSearchFilter03.swift
//  Locket
//
//  Created by Justin Damhaut on 13/6/24.
//

import SwiftUI



struct HomeViewSearchFilter03: View {
    
    @Binding var filterSelection: filterState
    @Binding var sortOrder: querySortOrder
    
    var scale: CGFloat = CGFloat(0.65)
    
    var body: some View {
        HStack {
            FilterButtonLeading(selectedRelationshipStatus: $filterSelection, selectedSortOrder: $sortOrder, accentColor: .gray)
                .scaleEffect(x: scale, y: scale)
                .frame(width: 152*scale, height:61*scale)
                .clipped()
            Spacer()
            filterButtonTrailingRow(filterSelection: $filterSelection)
        }
    }
}


#Preview {
    @Previewable @State var searchFilter: filterState = .showAll
    @Previewable @State var sortOrder: querySortOrder = .aToZ
    HomeViewSearchFilter03(filterSelection: $searchFilter, sortOrder: $sortOrder)
}
