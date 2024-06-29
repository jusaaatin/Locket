//
//  ProfileViewHeader.swift
//  Locket
//
//  Created by Justin Damhaut on 10/6/24.
//

import SwiftUI

struct ProfileViewHeader: View {
    
    func MinimumTimeFormatting(input: Int) -> String {
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
    
    var currentRSStatus: RelationshipStatus
    var name: String
    var accentColor: Color
    
    var demo: Bool
    var mainImage: Data
    var slideImages: [Data]
    
    var birthday: Date
    
    var body: some View {
        ZStack {
            ProfileViewName(name: name, accentColor: accentColor, demo: demo, mainImage: mainImage, slideImages: slideImages)
                .frame(height: 514, alignment: .top)
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 100)
                    .offset(y: 30)
                    .foregroundStyle(
                        LinearGradient(gradient: Gradient(colors: [Color("Background-match").opacity(0), Color("Background-match").opacity(100)]), startPoint: .top, endPoint: .bottom))
            }
        }.frame(height: 514)
        HStack {
            Image(systemName: "gift")
            Text("\(dateToDMY(input: birthday)) • \(MinimumTimeFormatting(input: generateTimeInterval(startDate: birthday, endDate: Date.now))) old")
        }
        .font(.system(size: 16, weight: .semibold))
        .shadow(
            color: Color("Background-match"), /// shadow color
            radius: 5, /// shadow radius
            x: 0, /// x offset
            y: 2 /// y offset
        )
        .foregroundStyle(.gray)
        .padding(.top, -65)
    }

}

#Preview {
    ProfileViewHeader(currentRSStatus: .bestie, name: "name", accentColor: .white, demo: true, mainImage: Data(), slideImages: [Data](), birthday: addOrSubtractYear(year: -16))
}
