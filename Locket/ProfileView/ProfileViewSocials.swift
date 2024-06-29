//
//  ProfileViewSocials.swift
//  Locket
//
//  Created by Justin Damhaut on 29/6/24.
//

import SwiftUI

struct ProfileViewSocials: View {
    
    var socials: [socials]
    var demo: Bool
    
    func returnSocialWebsite(platform: socialPlatforms, pre: String, main: String) -> String{
        switch platform {
        case .PhoneNumber:
            return "imessage:\(pre)\(main)"
        case .Instagram:
            return "https://instagram.com/\(main)"
        case .Tiktok:
            return "https://tiktok.com/@\(main)"
        case .Telegram:
            return "https://telegram.me/\(main)"
        case .Twitter:
            return "https://twitter.com/\(main)"
        case .Discord:
            return "https://discord.com/channels/@me/"
        case .Youtube:
            return "https://youtube.com/\(main)"
        case .Twitch:
            return "https://twitch.tv/\(main)"
        case .Github:
            return "https://github.com/\(main)"
        case .Bluesky:
            return "https://bsky.app/profile/\(main)"
        case .Discourse:
            return "https://meta.discourse.org/u/\(main)/"
        case .Facebook:
            return "https://facebook.com/\(main)"
        case .Linkedin:
            return "https://linkedin.com/in/\(main)"
        case .Mastodon:
            return "https://mastodon.social/@\(main)"
        case .Matrix:
            return "https://matrix.to/\(main)"
        case .Microblog:
            return "https://micro.blog"
        case .Reddit:
            return "https://reddit.com/user/\(main)"
        case .Slack:
            return "https://slack.com"
        case .Threads:
            return "https://threads.net/@\(main)"
        }
    }
    
    var body: some View {
        VStack {
            if socials.count > 0 {
                ForEach(socials) { social in
                    HStack {
                        if social.socialPlatform == .Instagram {
                            Image(social.socialPlatform.rawValue.lowercased())
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundStyle(LinearGradient(colors: [.purple, .red,  .yellow], startPoint: .topTrailing, endPoint: .bottomLeading))
                        } else if social.socialPlatform == .PhoneNumber {
                            Image(social.socialPlatform.rawValue.lowercased())
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color.green)
                        } else {
                            Image(social.socialPlatform.rawValue.lowercased())
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .symbolRenderingMode(.multicolor)
                        }
                        Text("\(social.socialPlatform.rawValue): ")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                        Group {
                            if social.socialPlatform == .PhoneNumber {
                                Text("+\(social.stringPRE) ")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                                +
                                Text("\(social.stringMAIN)")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                            } else {
                                Text("@\(social.stringMAIN)")
                                    .font(.system(size: 18, weight: .regular, design: .rounded))
                            }
                        }.minimumScaleFactor(0.1).lineLimit(1)
                        Spacer()
                        Button(action: {
                            if let url = URL(string: returnSocialWebsite(platform: social.socialPlatform, pre: social.stringPRE, main: social.stringMAIN)) {
                                UIApplication.shared.open(url)
                            }
                        }, label: {
                            Image(systemName: "arrow.up.forward")
                        })
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle(radius: 16))
                        .bold()
                        .frame(height: 4)
                    }.padding([.top, .bottom], 5)
                    if !(socials.last == social) {
                        Divider()
                    }
                }
            } else {
                HStack {
                    Spacer()
                    Image(systemName: "person.fill.questionmark")
                    Text("No Socials :(")
                    Spacer()
                }.frame(height: 20)
            }
        }
        .padding()
        .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ProfileViewSocials(socials: 
                        [/*
                        socials(socialPlatform: .PhoneNumber, stringPRE: "65", stringMAIN: "91234567"),
                         socials(socialPlatform: .Instagram, stringPRE: "", stringMAIN: "Username"),
                        socials(socialPlatform: .Discord, stringPRE: "", stringMAIN: "Username"),
                        socials(socialPlatform: .Slack, stringPRE: "", stringMAIN: "Username"),
                        socials(socialPlatform: .Telegram, stringPRE: "", stringMAIN: "Username"),
                        socials(socialPlatform: .Youtube, stringPRE: "", stringMAIN: "Username")
                      */  ], demo: true)
}
