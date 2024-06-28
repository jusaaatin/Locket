//
//  AddProfileViewNewSocials.swift
//  Locket
//
//  Created by Justin Damhaut on 20/6/24.
//

import SwiftUI
import Combine

struct AddProfileViewNewSocials: View {
    
    @Binding var isHidden: Bool
    @Binding var socialPlatform: socialPlatforms
    @Binding var stringPRE: String
    @Binding var stringMAIN: String
    @Binding var visibleSocialsCount: Int
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(role: .destructive, action: {
                    withAnimation(.bouncy) {
                        if !isHidden {
                            isHidden = true
                            visibleSocialsCount -= 1
                        }
                    }
                }, label: {
                    Image(systemName: "minus.circle")
                })
                Picker("Platform", selection:$socialPlatform) {
                    ForEach(socialPlatforms.allCases, id: \.id) { platform in
                        HStack{
                            Text("  \(platform.rawValue)")
                                .minimumScaleFactor(0.1)
                            Image(platform.rawValue.lowercased())
                                .minimumScaleFactor(0.1)
                            Spacer()
                        }
                        .frame(width: 300)
                    }
                }
                .pickerStyle(.menu)
                .tint(Color("Foreground-match"))
                Spacer()
            }
            .padding(.bottom, 5)
            HStack {
                if socialPlatform == .PhoneNumber {
                    HStack(alignment: .center) {
                        Text("+")
                        TextField("Code", text:$stringPRE)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .keyboardType(.numberPad)
                            .frame(width: 50)
                            .onReceive(Just(stringPRE)) { newValue in
                                let filteredAreaCode = newValue.filter { "0123456789-".contains($0) }
                                if filteredAreaCode != newValue {
                                    self.stringPRE = filteredAreaCode
                                }
                            }
                            .padding(.leading, -5)
                        TextField("Phone Number", text:$stringMAIN)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .keyboardType(.numberPad)
                            .onReceive(Just(stringMAIN)) { ZnewValue in
                                let filteredPN = ZnewValue.filter { "0123456789-".contains($0) }
                                if filteredPN != ZnewValue {
                                    self.stringMAIN = filteredPN
                                }
                        }
                            .padding(.leading, 3)
                    }
                } else {
                    Text("@")
                    TextField("Username", text:$stringMAIN)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .onReceive(Just(stringMAIN)) { ZnewValue in
                            let filteredPN = ZnewValue.filter { !"@".contains($0) }
                            if filteredPN != ZnewValue {
                                self.stringMAIN = filteredPN
                            }
                        }
                        .padding(.leading, -5)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var isHidden: Bool = false
    
    @Previewable @State var socialPlatform1: socialPlatforms = .PhoneNumber
    @Previewable @State var stringPRE: String = ""
    @Previewable @State var stringMAIN1: String = ""
    
    @Previewable @State var socialPlatform2: socialPlatforms = .Instagram
    @Previewable @State var stringMAIN2: String = ""
    
    @Previewable @State var visibleSocialsCount: Int = 1
    
    AddProfileViewNewSocials(isHidden: $isHidden, socialPlatform: $socialPlatform1, stringPRE: $stringPRE, stringMAIN: $stringMAIN1, visibleSocialsCount: $visibleSocialsCount)
    AddProfileViewNewSocials(isHidden: $isHidden, socialPlatform: $socialPlatform2, stringPRE: $stringPRE, stringMAIN: $stringMAIN2, visibleSocialsCount: $visibleSocialsCount)
}
