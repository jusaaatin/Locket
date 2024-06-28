//
//  AddProfileViewSocials.swift
//  Locket
//
//  Created by Justin Damhaut on 20/6/24.
//

import SwiftUI

struct AddProfileViewSocials: View {
    
    @Binding var isHidden: [Bool]
    @Binding var socialPlatform: [socialPlatforms]
    @Binding var stringPRE: [String]
    @Binding var stringMAIN: [String]
    @Binding var additionalSocialsCount: Int
    @Binding var visibleSocialsCount: Int
    @Binding var debugOn: Bool
    
    //IMPORTANT: First social on is zero on every array as well as count
    
    var body: some View {
        VStack {
            if additionalSocialsCount != -1 {
                ForEach(0 ... additionalSocialsCount, id: \.self) { count in
                    if isHidden[count] == false {
                        HStack {
                            AddProfileViewNewSocials(isHidden: $isHidden[count], socialPlatform: $socialPlatform[count], stringPRE: $stringPRE[count], stringMAIN: $stringMAIN[count], visibleSocialsCount: $visibleSocialsCount)
                            if debugOn {
                                Text("\(count)")
                            }
                        }
                        let isIndexValid = isHidden.indices.contains(count+1)
                        if additionalSocialsCount > count && visibleSocialsCount != 1 && isIndexValid{
                            Divider()
                        }
                    }
                }.padding(.bottom, 6)
            }
            if visibleSocialsCount == 0{
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.bouncy) {
                            isHidden.append(false)
                            if visibleSocialsCount == 0 {
                                socialPlatform.append(.PhoneNumber)
                            } else {
                                socialPlatform.append(.Instagram)
                            }
                            stringPRE.append("")
                            stringMAIN.append("")
                            additionalSocialsCount += 1
                            visibleSocialsCount += 1
                        }
                    }, label: {
                        Image(systemName: "person.fill.questionmark")
                        Text("No Socials :(")
                    }).buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .foregroundStyle(.gray)
            }
        }
        .frame(height: visibleSocialsCount == 0 ? 20 : CGFloat(90*visibleSocialsCount - 20))
        .clipped()
        .padding()
        .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        
        HStack {
            Spacer()
            Button(action: {
                withAnimation(.bouncy) {
                    isHidden.append(false)
                    if visibleSocialsCount == 0 {
                        socialPlatform.append(.PhoneNumber)
                    } else {
                        socialPlatform.append(.Instagram)
                    }
                    stringPRE.append("")
                    stringMAIN.append("")
                    additionalSocialsCount += 1
                    visibleSocialsCount += 1
                }
            }, label: {
                Image(systemName: "plus")
                Text("Add Social")
            })
            Spacer()
        }
        .frame(height: 20)
        .padding()
        .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        
        if debugOn {
            Text("DEBUG ON")
            Text("visible \(visibleSocialsCount)")
            Text("additional \(additionalSocialsCount)")
            Text("isHidden \(isHidden)")
        }
    }
}

#Preview {
    @Previewable @State var isHidden: [Bool] = [false]
    @Previewable @State var socialPlatform: [socialPlatforms] = [.PhoneNumber]
    @Previewable @State var stringPRE: [String] = [""]
    @Previewable @State var stringMAIN: [String] = [""]
    @Previewable @State var additionalSocialsCount: Int = 0
    @Previewable @State var visibleSocialsCount: Int = 1
    @Previewable @State var debugOn: Bool = true
    
    ScrollView {
        AddProfileViewSocials(isHidden: $isHidden, socialPlatform: $socialPlatform, stringPRE: $stringPRE, stringMAIN: $stringMAIN, additionalSocialsCount: $additionalSocialsCount, visibleSocialsCount: $visibleSocialsCount, debugOn: $debugOn)
            .padding([.leading, .trailing])
    }
}
