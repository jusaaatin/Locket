//
//  ProfileViewHeaderSubheader.swift
//  Locket
//
//  Created by Justin Damhaut on 10/6/24.
//

import SwiftUI




struct ProfileViewHeader01: View {
    
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
    
    
    var currentRSStatus: RelationshipStatus
    var name: String
    var startDate: Date
    var endDate: Date?
    var currentDate = Date.now
    var accentColor: Color
    
    var demo: Bool
    var mainImage: Data
    var slideImages: [Data]
    
    var body: some View {
        ProfileViewName(name: name, accentColor: accentColor, demo: demo, mainImage: mainImage, slideImages: slideImages)
            .frame(height: 514, alignment: .top)
        
        switch currentRSStatus {
        case .crush:
            Text("Crush for \(MinimumTimeFormatting(input: generateTimeInterval(startDate: startDate, endDate: nil)))")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.gray)
                .padding(.top, -65)
        case .relationship:
            Text("Dating for \(MinimumTimeFormatting(input: generateTimeInterval(startDate: startDate, endDate: nil)))")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.gray)
                .padding(.top, -65)
        case .friend:
            Text("Friends for \(MinimumTimeFormatting(input: generateTimeInterval(startDate: startDate, endDate: nil)))")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.gray)
                .padding(.top, -65)
        case .bestie:
            Text("Besties for \(MinimumTimeFormatting(input: generateTimeInterval(startDate: startDate, endDate: nil)))")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.gray)
                .padding(.top, -65)
        }
    }

}

#Preview {
    ProfileViewHeader01(currentRSStatus: .relationship, name: "Name", startDate: addOrSubtractDay(day: -3), endDate: addOrSubtractDay(day: 24), accentColor: .red, demo: true, mainImage: Data(), slideImages: [Data]())
}
