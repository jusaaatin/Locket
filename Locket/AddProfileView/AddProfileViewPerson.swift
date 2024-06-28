//
//  AddProfileViewPerson.swift
//  Locket
//
//  Created by Justin Damhaut on 21/6/24.
//

import SwiftUI

struct AddProfileViewPerson: View {
    
    @Binding var name: String
    @Binding var accentColor: Color
    
    @Binding var birthday: Date
    
    var body: some View {
        VStack {
            HStack {
                Text("Name")
                    .padding(.trailing, 12)
                    .fontWeight(.semibold)
                Spacer()
                TextField("", text: $name)
                    .foregroundStyle(accentColor)
                    .frame(height: 6)
                    .padding()
                    .background(Color.gray.mix(with:Color("Background-match"), by: 0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Divider()
            HStack {
                Text("Birthday")
                    .fontWeight(.semibold)
                Spacer()
                RelationshipStartDatePicker(selectedDate: $birthday)
                    .frame(width: 182)
            }
            Divider()
            HStack {
                Text("Color")
                    .fontWeight(.semibold)
                AddProfileColorPicker(selectedColor: .white, finalColorOutput: $accentColor)
            }
        }
        .padding()
        .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    @Previewable @State var name: String = ""
    @Previewable @State var accentColor: Color = .white
    @Previewable @State var birthday: Date = .now
    
    AddProfileViewPerson(name: $name, accentColor: $accentColor, birthday: $birthday)
        .padding()
}
