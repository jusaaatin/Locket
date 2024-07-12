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
    @Binding var socialsNotOk: Bool
    
    func returnNextSocial(input: socialPlatforms) -> socialPlatforms{
        switch input {
        case .PhoneNumber:
            return .Instagram
        case .Instagram:
            return .Tiktok
        case .Tiktok:
            return .Telegram
        case .Telegram:
            return .Twitter
        case .Twitter:
            return .Discord
        case .Discord:
            return .Youtube
        case .Youtube:
            return .Twitch
        case .Twitch:
            return .Github
        case .Github:
            return .Bluesky
        case .Bluesky:
            return .Discourse
        case .Discourse:
            return .Facebook
        case .Facebook:
            return .Linkedin
        case .Linkedin:
            return .Mastodon
        case .Mastodon:
            return .Matrix
        case .Matrix:
            return .Microblog
        case .Microblog:
            return .Reddit
        case .Reddit:
            return .Slack
        case .Slack:
            return .Threads
        case .Threads:
            return .PhoneNumber
        }
    }
    
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
                            socialPlatform.append(returnNextSocial(input: socialPlatform[additionalSocialsCount]))
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
        .frame(height: visibleSocialsCount == 0 ? 20 : CGFloat(94*visibleSocialsCount - 20))
        .clipped()
        .padding()
        .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.red.opacity(socialsNotOk ? 0.5 : 0), lineWidth: 2)
        )
        
        HStack {
            Spacer()
            Button(action: {
                withAnimation(.bouncy) {
                    isHidden.append(false)
                    socialPlatform.append(returnNextSocial(input: socialPlatform[additionalSocialsCount]))
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
    @Previewable @State var socialsNotOk: Bool = false
    
    ScrollView {
        AddProfileViewSocials(isHidden: $isHidden, socialPlatform: $socialPlatform, stringPRE: $stringPRE, stringMAIN: $stringMAIN, additionalSocialsCount: $additionalSocialsCount, visibleSocialsCount: $visibleSocialsCount, debugOn: $debugOn, socialsNotOk: $socialsNotOk)
            .padding([.leading, .trailing])
    }
}
