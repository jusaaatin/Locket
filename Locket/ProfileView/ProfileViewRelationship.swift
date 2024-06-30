//
//  ProfileViewRelationship.swift
//  Locket
//
//  Created by Justin Damhaut on 29/6/24.
//

import SwiftUI



struct ProfileViewRelationship: View {
    
    var startDate: Date
    @State var currentRSStatus: RelationshipStatus
    
    func returnStatus() -> String {
        switch currentRSStatus {
        case .crush:
            return "Crush"
        case .relationship:
            return "Dating"
        case .bestie:
            return "Bestie"
        case .friend:
            return "Friend"
        }
}
    func returnStatusColor() -> Color {
        switch currentRSStatus {
        case .crush:
            return Color.pink
        case .relationship:
            return Color.red
        case .friend:
            return Color.cyan
        case .bestie:
            return Color.mint
        }
    }
    func dateToDMY(input: Date) -> String {
        let DMYFormatter = DateFormatter()
        DMYFormatter.dateFormat = "d MMM y"
        return DMYFormatter.string(from: input)
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
    
    var body: some View {
        HStack(alignment:.center) {
            switch currentRSStatus {
            case .crush:
                VStack {
                    Image(systemName: "heart")
                        .font(.system(size: 55, weight: .semibold, design: .rounded))
                        .foregroundStyle(returnStatusColor())
                    }
                case .relationship:
                VStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 55, weight: .semibold, design: .rounded))
                        .foregroundStyle(returnStatusColor())
                    }
                case .bestie:
                VStack {
                    Image(systemName: "figure.2")
                        .font(.system(size: 45, weight: .semibold, design: .rounded))
                        .foregroundStyle(returnStatusColor())
                    }
                case .friend:
                VStack {
                    Image(systemName: "person.2")
                        .font(.system(size: 45, weight: .semibold, design: .rounded))
                        .foregroundStyle(returnStatusColor())
                        .offset(y: 2)
                    }
            }
            VStack(alignment:.leading) {
                HStack {
                    Text("\(returnStatus())").foregroundStyle(returnStatusColor())
                    + Text(" ") +
                    Text("for \(MinimumTimeFormatting(input: generateTimeInterval(startDate: startDate, endDate: Date.now)))")
                        
                }.font(.system(size: 24, weight: .semibold, design: .rounded))
                HStack {
                    Text("Since \(dateToDMY(input: startDate))")
                }
            }
            Spacer()
        }
        .padding()
        .frame(height: 92)
   //     .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ProfileViewRelationship(startDate: addOrSubtractYear(year: -3), currentRSStatus: .crush)
        .padding()
}
