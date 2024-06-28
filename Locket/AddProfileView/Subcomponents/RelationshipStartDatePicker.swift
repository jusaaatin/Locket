//
//  RelationshipStartDatePicker.swift
//  Locket
//
//  Created by Justin Damhaut on 20/6/24.
//

import SwiftUI
import Foundation
import Combine


enum currentlyFocused: Int, Hashable{
    case day, month, year
}



struct RelationshipStartDatePicker: View {
    
    func dateToDMY(input: Date, type: Int) -> Int {
        let DMYFormatter = DateFormatter()
        if type == 1 {
            DMYFormatter.dateFormat = "d"
        } else if type == 2 {
            DMYFormatter.dateFormat = "M"
        } else {
            DMYFormatter.dateFormat = "y"
        }
        return Int(DMYFormatter.string(from: input)) ?? 0
    }
    

    
    @State var startDay: String = ""
    @State var startMonth: String = ""
    @State var startYear: String = ""
    @Binding var selectedDate: Date
    
   
    
    @FocusState private var currentFocused: currentlyFocused?
    
    var body: some View {
        HStack {
            TextField("D", text: $startDay)
                .keyboardType(.numberPad)
                .padding(4)
                .frame(width: 40)
                .background(Color.gray.mix(with:Color("Background-match"), by: 0.6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .multilineTextAlignment(.center)
                .focused($currentFocused, equals: .day)
                .onReceive(Just(startDay)) { AnewValue in
                    let filteredPN = AnewValue.filter { "0123456789".contains($0) }
                    if filteredPN != AnewValue {
                        self.startDay = filteredPN
                    }

                }
                .onChange(of: startDay) { oldValue, newValue in
                    if startDay.count == 2 {
                        self.focusNextField($currentFocused)
                    }
                }
                .onSubmit { self.focusNextField($currentFocused) }
                .onChange(of: currentFocused) { oldValue, newValue in
                    if newValue == .day {
                        startDay = ""
                    } else if newValue == .month {
                        startMonth = ""
                    } else if newValue == .year {
                        startYear = ""
                    }
                }
            Text("/")
            TextField("M", text: $startMonth)
                .keyboardType(.numberPad)
                .padding(4)
                .frame(width: 40)
                .background(Color.gray.mix(with:Color("Background-match"), by: 0.6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .multilineTextAlignment(.center)
                .focused($currentFocused, equals: .month)
                .onReceive(Just(startMonth)) { BnewValue in
                    let filteredBN = BnewValue.filter { "0123456789".contains($0) }
                    if filteredBN != BnewValue {
                        self.startMonth = filteredBN
                    }
                }
                .onChange(of: startMonth) { oldValue, newValue in
                    if startMonth.count == 2 {
                        self.focusNextField($currentFocused)
                    }
                }
                .onSubmit { self.focusNextField($currentFocused) }
            Text("/")
            TextField("YYYY", text: $startYear)
                .keyboardType(.numberPad)
                .padding(4)
                .frame(width: 60)
                .background(Color.gray.mix(with:Color("Background-match"), by: 0.6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .multilineTextAlignment(.center)
                .focused($currentFocused, equals: .year)
                .onReceive(Just(startYear)) { CnewValue in
                    let filteredCN = CnewValue.filter { "0123456789".contains($0) }
                    if filteredCN != CnewValue {
                        self.startYear = filteredCN
                    }
                }
                .onChange(of: startYear) { oldValue, newValue in
                    if startYear.count == 4 {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                        //check that input does not exceed current date
                        if dateToDMY(input: .now, type: 3) < Int(startYear) ?? 0 {
                            startYear = "\(dateToDMY(input:.now, type:3))"
                        }
                        if dateToDMY(input: .now, type: 3 ) == Int(startYear) ?? 0 {
                            if dateToDMY(input: .now, type: 2) < Int(startMonth) ?? 0 {
                                startMonth = "\(dateToDMY(input:.now, type:2))"
                            }
                            if dateToDMY(input: .now, type: 2) == Int(startMonth) ?? 0 {
                                if dateToDMY(input: .now, type: 1) < Int(startDay) ?? 0 {
                                    startDay = "\(dateToDMY(input:.now, type:1))"
                                }
                            }
                        }
                        if startMonth.count == 1 {
                            startMonth = "0\(startMonth)"
                        } //reformat month
                        if startDay.count == 1 {
                            startDay = "0\(startDay)"
                        } //reformat day
                        if Int(startYear) ?? 5 % 4 == 0 {
                            //leap year
                            if startMonth == "01" || startMonth == "03" || startMonth == "05" || startMonth == "07" || startMonth == "08" || startMonth == "10" || startMonth == "12" || Int(startMonth) ?? 22 > 12 {
                                //long month
                                if Int(startDay) ?? 0 > 31 {
                                    startDay = "31"
                                }
                            } else if startMonth == "04" || startMonth == "06" || startMonth == "09" || startMonth == "11" {
                                if Int(startDay) ?? 0 > 30 {
                                    startDay = "30"
                                }
                            } else {
                                if Int(startDay) ?? 0 > 28 {
                                    startDay = "28"
                                }
                            }
                        } else {
                            // non leap
                            if startMonth == "01" || startMonth == "03" || startMonth == "05" || startMonth == "07" || startMonth == "08" || startMonth == "10" || startMonth == "12" || Int(startMonth) ?? 22 > 12 {
                                //long month
                                if Int(startDay) ?? 0 > 31 {
                                    startDay = "31"
                                }
                            } else if startMonth == "04" || startMonth == "06" || startMonth == "09" || startMonth == "11" {
                                if Int(startDay) ?? 0 > 30 {
                                    startDay = "30"
                                }
                            } else {
                                if Int(startDay) ?? 0 > 29 {
                                    startDay = "29"
                                }
                            }
                        } //day check
                        if Int(startMonth) ?? 22 > 12 {
                            startMonth = "12"
                        } //month check
                        
                        selectedDate = DMYtoDate(day: startDay, month: startMonth, year: startYear)
                    }
                }
        }
        
    }
}

#Preview {
    @Previewable @State var selectedDate: Date = .now
    RelationshipStartDatePicker(selectedDate: $selectedDate)
    
    DatePicker("DEBUG", selection: $selectedDate)
        .padding(.top, 20)
}
