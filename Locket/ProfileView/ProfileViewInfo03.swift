//
//  ProfileViewInfo03.swift
//  Locket
//
//  Created by Justin Damhaut on 10/6/24.
//

import SwiftUI
import Foundation

struct ProfileViewInfo03: View {
    
    func MinimumTimeFormatting(input: Int) -> String{
        let intervalDay = input
        let intervalWeek = (intervalDay/7)
        let intervalMonth = (intervalDay/30)
        let intervalYear = (intervalWeek/52)
        
        if intervalYear != 0 {
            if intervalYear > 1 {
                return ("\(intervalYear) years")
            } else {
                return ("\(intervalYear) year")
            }
        } else if intervalMonth != 0 {
            if intervalMonth > 1 {
                return ("\(intervalMonth) months")
            } else {
                return ("\(intervalMonth) month")
            }
        } else if intervalWeek != 0 {
            if intervalWeek > 1 {
                return ("\(intervalWeek) weeks")
            } else {
                return ("\(intervalWeek) week")
            }
        } else {
            if intervalDay != 0 && intervalDay > 1 {
                return ("\(intervalDay) days")
            } else {
                return ("1 day")
            }
        }
    }
    
    func generateTimeInterval(startDate: Date, endDate: Date?) -> Int {
        let startSince1970 = Int(startDate.timeIntervalSince1970)
        let currentSince1970 = Int(Date().timeIntervalSince1970)
        let startToNow: Int = (currentSince1970 - startSince1970)
        
        switch currentRSStatus {
        default:
            return startToNow/60/60/24
        }
    }
    
    func dateToDMY(input: Date) -> String {
        let DMYFormatter = DateFormatter()
        DMYFormatter.dateFormat = "d MMM y"
        return DMYFormatter.string(from: input)
    }
    
    @State private var line1state: Int = 1
    @State private var line2state: Int = 1
    @State private var line3state: Int = 1
    
    var startDate: Date
    var endDate: Date?
    var currentDate = Date.now
    
    //input person into
    var currentRSStatus: RelationshipStatus
    var birthday: Date
    var instaUser: String
    var telPrefix: String
    var telNumber: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack{
                    Image(systemName: "gift")
                    if line1state == 1 {
                        Text(dateToDMY(input: birthday))
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    line1state = 2
                                }
                            }
                    } else {
                        Text("\(MinimumTimeFormatting(input: generateTimeInterval(startDate: birthday, endDate: Date.now))) old")
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    line1state = 1
                                }
                            }
                    }

                }
                .padding(.bottom, 2)
                HStack{
                    Image(systemName: "alarm")
                    if line2state == 1 {
                        Text(" \(MinimumTimeFormatting(input: generateTimeInterval(startDate: startDate, endDate: endDate)))")
                            .padding(.leading, -8)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    line2state = 2
                                }
                            }
                    } else {
                        switch currentRSStatus { default:
                            Text("Since \(dateToDMY(input: startDate))")
                                .onTapGesture {
                                    withAnimation(.snappy) {
                                        line2state = 1
                                    }
                                }
                        }
                    }

                }
                .padding(.bottom, 2)
                HStack{
                    if line3state == 1 {
                        Image(systemName: "phone")
                        Link(destination: URL(string:"imessage:\(telPrefix)\(telNumber)")!, label:{
                            Text(telNumber)
                                .padding(.trailing, 2)
                                .foregroundStyle(Color("Foreground-match"))
                        })
                        Button {
                            withAnimation(.snappy) {
                                line3state = 2
                            }
                        } label: {
                            Image("instagram")
                          //      .foregroundStyle(.white)
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle(radius: 16))
                        .bold()
                        .frame(height: 4)
                    } else {
                        Image("instagram")
                        Link(destination: URL(string:"https://instagram.com/\(instaUser)")!, label:{
                            Text("@\(instaUser)")
                                .padding(.trailing, 2)
                                .foregroundStyle(Color("Foreground-match"))
                        })
                        Button {
                            withAnimation(.snappy) {
                                line3state = 1
                            }
                        } label: {
                            Image(systemName: "phone")
                             //   .foregroundStyle(.white)
                            
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle(radius: 16))
                        .bold()
                        .frame(height: 4)
                    }
                }
                .padding(.bottom, 2)
            }
            .fontDesign(.monospaced)
            
            Spacer()
            
            switch currentRSStatus {
            case .crush:
                VStack {
                    Image(systemName: "heart")
                        .font(.system(size: 60, weight: .semibold, design: .rounded))
                    }
                case .relationship:
                VStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60, weight: .semibold, design: .rounded))
                    }
                case .bestie:
                VStack {
                    Image(systemName: "figure.2")
                        .font(.system(size: 50, weight: .semibold, design: .rounded))
                    }
                case .friend:
                VStack {
                    Image(systemName: "person.2")
                        .font(.system(size: 50, weight: .semibold, design: .rounded))
                    }
            }
        }
        .padding(.leading, 40)
        .padding(.trailing, 40)
        .padding(.top, -30)
    }
}

#Preview {
    ProfileViewInfo03(startDate: addOrSubtractDay(day: -3), endDate: addOrSubtractYear(year: 3), currentRSStatus: .bestie, birthday: addOrSubtractYear(year: -15), instaUser: "username", telPrefix: "123", telNumber: "91234567")
}
