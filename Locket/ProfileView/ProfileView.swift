//
//  ProfileView.swift
//  Locket
//
//  Created by Justin Damhaut on 9/6/24.
//


import SwiftUI



struct ProfileView: View {
    
    //DEMO INFO
    @State var currentRSStatus: RelationshipStatus
    
    var demoStartDate: Date
    var demoEndDate: Date
    var name: String
    var birthday: Date
    var instaUser: String
    var telPrefix: String
    var telNumber: String
    var accentColor: Color
    
    var body: some View {
        ScrollView {
            ProfileViewHeader01(currentRSStatus: currentRSStatus, name: name, startDate: demoStartDate, endDate: demoEndDate, accentColor: accentColor)
            ProfileViewInfo03(startDate: demoStartDate, endDate: demoEndDate, currentRSStatus: currentRSStatus, birthday: birthday, instaUser: instaUser, telPrefix: telPrefix, telNumber: telNumber)
                .frame(height:80)
            Divider()
                .padding(-5)
            Picker("Status", selection: $currentRSStatus) {
                Image(systemName: "heart").tag(RelationshipStatus.crush)
                Image(systemName: "heart.fill").tag(RelationshipStatus.relationship)
                Image(systemName: "person.2").tag(RelationshipStatus.friend)
                Image(systemName: "figure.2").tag(RelationshipStatus.bestie)
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing])
            
        }
        .ignoresSafeArea()

 
    }
}

#Preview {
    ProfileView(currentRSStatus: .bestie, 
                demoStartDate: addOrSubtractYear(year: -5),
                demoEndDate: addOrSubtractYear(year: -1),
                name: "Name",
                birthday: addOrSubtractYear(year: -15),
                instaUser: "username",
                telPrefix: "123",
                telNumber: "91234567",
                accentColor: .white)
}
