//
//  ProfileView.swift
//  Locket
//
//  Created by Justin Damhaut on 9/6/24.
//


import SwiftUI



struct ProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State var currentRSStatus: RelationshipStatus
    @Binding var deleting: Bool
    @Binding var currentPage: locketPages
    
    var bindPerson: person
    
    @State var updater: Int = 1
    
    @State var demoStartDate: Date
    @State var demoEndDate: Date
    @State var name: String
    @State var birthday: Date
    @State var instaUser: String
    @State var telPrefix: String
    @State var telNumber: String
    @State var accentColor: Color
    
    @State var demo: Bool
    @State var mainImage: Data
    @State var slideImages: [Data]
    
    @State var socials: [socials]
    
    @State var description: String
    
    @State var creationDate: Date

    @State var showDeleteConfirmation = false
    @State var showDuplicateConfirmation = false

    @State var priority: Int
    
    private func returnAccentColor(isFgMatch: Bool, Hex: String) -> Color{
        if isFgMatch {
            return Color("Foreground-match")
        } else {
            return Color(hex: "\(Hex)") ?? Color("Foreground-match")
        }
    }
    
    func dateToDMY(input: Date) -> String {
        let DMYFormatter = DateFormatter()
        DMYFormatter.dateFormat = "d MMM y"
        return DMYFormatter.string(from: input)
    }
    func generatePersonID() -> Int{
        let currentDate: Date = .now
        let currentSince1970 = currentDate.timeIntervalSince1970
        return Int(currentSince1970)
    }
    func accentColorDefaultFgCheck() -> Bool{
        if accentColor == Color("Foreground-match") {
            return true
        } else { return false }
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                ScrollView {
                    VStack {
                        ProfileViewHeader(currentRSStatus: currentRSStatus, name: name, accentColor: accentColor, demo: demo, mainImage: mainImage, slideImages: slideImages, birthday: birthday)
                            .onDisappear() {
                                withAnimation(.snappy) { currentPage = .home }
                            }
                            .id(updater)
                            .onAppear {
                                withAnimation(.snappy) { currentPage = .profile }
                                print("appeared")
                                
                                currentRSStatus = bindPerson.relationshipStatus
                                demoStartDate = bindPerson.currentRelationshipStartDate
                                name = bindPerson.name
                                birthday = bindPerson.birthday
                                accentColor = returnAccentColor(
                                    isFgMatch: bindPerson.accentColorIsDefaultForeground,
                                    Hex: bindPerson.hexAccentColor)
                                mainImage = bindPerson.shownThumbnail
                                slideImages = bindPerson.slideImages ?? [Data]()
                                socials = bindPerson.socials ?? []
                                priority = bindPerson.priority
                                updater += 1
                                
                                if bindPerson.priority == -1 {
                                    dismiss()
                                }
                            }
                        ProfileViewRelationship(startDate: demoStartDate, currentRSStatus: currentRSStatus)
                            .padding([.leading, .trailing, .bottom])
                            .padding(.top, -30)
                            .onAppear {
                                withAnimation(.snappy) { currentPage = .profile }
                            }
                            .id(updater)
                        HStack {
                            Text("        Socials")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.gray)
                                .padding(.top, -44)
                                .padding(.bottom, -5)
                            Spacer()
                        }.padding(.top, 40)
                        ProfileViewSocials(socials: socials, demo: demo)
                            .id(updater)
                            .padding([.bottom, .leading, .trailing])
                            .padding(.top, -30)
                        HStack {
                            Text("        Images")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.gray)
                                .padding(.top, -44)
                                .padding(.bottom, -5)
                            Spacer()
                        }.padding(.top, 40)
                        ProfileViewImages(demo: false, mainImage: mainImage, slideImages: slideImages)
                            .id(updater)
                            .padding([.bottom, .leading, .trailing])
                            .padding(.top, -30)
                        HStack {
                            Text("        Description")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.gray)
                                .padding(.top, -44)
                                .padding(.bottom, -5)
                            Spacer()
                        }.padding(.top, 40)
                        ProfileViewDescription(description: description)
                            .id(updater)
                            .padding([.bottom, .leading, .trailing])
                            .padding(.top, -30)
                        Text("\(name)'s contact created on \(dateToDMY(input: creationDate))")
                            .padding()
                            .multilineTextAlignment(.center)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.gray.opacity(0.8))
                        Image(systemName: "figure.walk.motion")
                            .font(.system(size: 60, weight: .semibold, design: .rounded))
                            .foregroundStyle(.gray.opacity(0.5))
                            .padding()
                            .padding(.bottom, 30)
                            .alert("Delete \(name)?", isPresented: $showDeleteConfirmation) { //delete
                                Button("Delete", role: .destructive) {
                                    modelContext.delete(bindPerson)
                                    dismiss()
                                }
                            } message: {
                                Text("Are you sure you want to delete \(name)? Once deleted, this contact can not be recovered")
                            }
                            .alert("Duplicate \(name)?", isPresented: $showDuplicateConfirmation) {
                                Button("Cancel", role: .cancel) { }
                                Button("Duplicate") {
                                    let insertedperson = person(
                                        personid: generatePersonID(),
                                        name: name,
                                        birthday: birthday,
                                        hexAccentColor: accentColor.toHex() ?? "FFFFFF",
                                        accentColorIsDefaultForeground: accentColorDefaultFgCheck(),
                                        shownThumbnail: mainImage,
                                        slideImages: slideImages,
                                        socials: socials,
                                        relationshipStatus: currentRSStatus,
                                        currentRelationshipStartDate: demoStartDate,
                                        personDescription: description)
                                    modelContext.insert(insertedperson)
                                    print("success on duplicating")
                                    print("\(name)")
                                }
                            } message: {
                                Text("Are you sure you want to duplicate \(name)?")
                            }
                    }
                }.scrollIndicators(.hidden)
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
                                .frame(width: 32, height: 32)
                        }.frame(width: 42, height: 42)
                    }
                    Spacer()
                    NavigationLink {
                        EditProfileView(debugOn: false, bindedPerson: bindPerson)
                            .navigationBarBackButtonHidden()
                            .id(UUID())
                    } label: {
                        HStack {
                            Text("Edit").bold()
                        }
                        .padding([.leading, .trailing])
                        .foregroundStyle(.black)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white.mix(with:.gray, by: 0.2).opacity(0.6))
                                .frame(height: 32)
                        }
                    }
                    .id(UUID())
                    Menu {
                        Section {
                            Button(action: {
                                bindPerson.pinToggle()
                            }, label: {
                                Label(bindPerson.isPinned() ? "Unpin \(name)" : "Pin \(name)", systemImage: bindPerson.isPinned() ? "pin.fill" : "pin")
                            })
                        }
                        Section {
                            Button(action: {
                                showDuplicateConfirmation = true
                            }, label: {
                                Label("Duplicate \(name)", systemImage: "square.on.square")
                            })
                            Button(role: .destructive, action: {
                                showDeleteConfirmation = true
                            }, label: {
                                Label("Delete \(name)", systemImage: "trash")
                            })
                        }
                    } label: {
                        HStack {
                            Image(systemName: "ellipsis")
                        }
                        .padding([.leading, .trailing])
                        .foregroundStyle(.black)
                        .background {
                            Circle()
                                .fill(.white.mix(with:.gray, by: 0.2).opacity(0.6))
                                .frame(width: 32, height: 32)
                        }
                        .frame(width: 42, height: 42)
                    }.padding(.leading, -4)
                    .id(UUID())
                }.padding().offset(y: 45)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    @Previewable @State var editIsPresented = false
    @Previewable @State var deleting = false
    @Previewable @State var currentPage: locketPages = .profile
    ProfileView(currentRSStatus: .crush, deleting: $deleting,
                currentPage: $currentPage, 
                bindPerson: person(),
                demoStartDate: addOrSubtractYear(year: -5),
                demoEndDate: addOrSubtractYear(year: -1),
                name: "Brain",
                birthday: addOrSubtractYear(year: -15),
                instaUser: "username",
                telPrefix: "123",
                telNumber: "91234567",
                accentColor: .white,
                demo: true,
                mainImage: Data(),
                slideImages: [Data](), socials:
                    [
                    socials(socialPlatform: .PhoneNumber, stringPRE: "65", stringMAIN: "91234567"),
                     socials(socialPlatform: .Instagram, stringPRE: "", stringMAIN: "Username"),
                    socials(socialPlatform: .Discord, stringPRE: "", stringMAIN: "Username"),
                    socials(socialPlatform: .Slack, stringPRE: "", stringMAIN: "Username"),
                    socials(socialPlatform: .Telegram, stringPRE: "", stringMAIN: "Username"),
                    socials(socialPlatform: .Youtube, stringPRE: "", stringMAIN: "Username")
                    ], 
                description: "dhkjlsklhjasfhjkfsa hjsfd jhsfaj fskldj kadfjl jadsfjkhdfajkhl hdfkljh fadsh ladf",
                creationDate: .now, 
                priority: 0
    )
}
