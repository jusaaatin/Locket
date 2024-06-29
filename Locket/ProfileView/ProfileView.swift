//
//  ProfileView.swift
//  Locket
//
//  Created by Justin Damhaut on 9/6/24.
//


import SwiftUI



struct ProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var currentRSStatus: RelationshipStatus
    @Binding var deleting: Bool
    @Binding var currentPage: locketPages
    
    var demoStartDate: Date
    var demoEndDate: Date
    var name: String
    var birthday: Date
    var instaUser: String
    var telPrefix: String
    var telNumber: String
    var accentColor: Color
    
    var demo: Bool
    var mainImage: Data
    var slideImages: [Data]
    
    var socials: [socials]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                ProfileViewHeader(currentRSStatus: currentRSStatus, name: name, accentColor: accentColor, demo: demo, mainImage: mainImage, slideImages: slideImages, birthday: birthday)
                    .onDisappear() {
                        withAnimation(.snappy) { currentPage = .home }
                    }
                ProfileViewRelationship(startDate: demoStartDate, currentRSStatus: currentRSStatus)
                    .padding([.leading, .trailing, .bottom])
                    .padding(.top, -30)
                HStack {
                    Text("        Socials")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.gray)
                        .padding(.top, -44)
                    Spacer()
                }.padding(.top, 40)
                
            }
            HStack {
                Button {
                    withAnimation(.snappy) { currentPage = .home }
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                    }
                    .padding([.leading, .trailing])
                    .foregroundStyle(.black)
                    .background {
                        Circle()
                            .fill(.white.mix(with:.gray, by: 0.2).opacity(0.6))
                            .frame(height: 32)
                    }
                }
            }.padding().offset(y: 45)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    @Previewable @State var deleting = false
    @Previewable @State var currentPage: locketPages = .profile
    ProfileView(currentRSStatus: .crush, deleting: $deleting,
                currentPage: $currentPage, demoStartDate: addOrSubtractYear(year: -5),
                demoEndDate: addOrSubtractYear(year: -1),
                name: "Brain",
                birthday: addOrSubtractYear(year: -15),
                instaUser: "username",
                telPrefix: "123",
                telNumber: "91234567",
                accentColor: .white,
                demo: true,
                mainImage: Data(),
                slideImages: [Data](), socials: [socials]()
    )
}
