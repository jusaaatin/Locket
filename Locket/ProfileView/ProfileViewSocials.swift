//
//  ProfileViewSocials.swift
//  Locket
//
//  Created by Justin Damhaut on 29/6/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ProfileViewSocials: View {
    
    @State var socials: [socials]
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
    
    @State var socialsCounter = -1
    @State var socialPlatform: [socialPlatforms] = []
    @State var rawStringPRE: [String] = []
    @State var rawStringMAIN: [String] = []
    @State var appendedStringPRE: [String] = []
    @State var appendedStringMAIN: [String] = []
    @State var copying: [Bool] = []
    @State var justAppeared = true
    
    private let pasteboard = UIPasteboard.general
    
    func loadAllSocials() {
        for social in socials {
            socialsCounter += 1
            copying.append(false)
            socialPlatform.append(social.socialPlatform)
            rawStringPRE.append(social.stringPRE)
            rawStringMAIN.append(social.stringMAIN)
            appendedStringPRE.append("+\(social.stringPRE) ")
            appendedStringMAIN.append("@\(social.stringMAIN)")
        }
    }
    
    func copySocials(count: Int) {
        let iRawPRE = rawStringPRE[count]
        let iRawMAIN = rawStringMAIN[count]
        let iAppendedPRE = appendedStringPRE[count]
        let iAppendedMAIN = appendedStringMAIN[count]
        
        copying[count] = true
        
        if socialPlatform[count] == .PhoneNumber {
            appendedStringPRE[count] = "Copied!"
            rawStringMAIN[count] = ""
            pasteboard.string = "+\(iRawPRE) \(iRawMAIN)"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                appendedStringPRE[count] = iAppendedPRE
                rawStringMAIN[count] = iRawMAIN
                copying[count] = false
            }
        } else {
            appendedStringMAIN[count] = "Copied!"
            pasteboard.string = "\(iRawMAIN)"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                appendedStringMAIN[count] = iAppendedMAIN
                copying[count] = false
            }
        }
    }
    
    var body: some View {
        VStack {
            if socialsCounter > -1 {
                ForEach(0 ... socialsCounter, id: \.self) { count in
                    HStack {
                        Group {
                            if socialPlatform[count] == .Instagram {
                                Image(socialPlatform[count].rawValue.lowercased())
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundStyle(LinearGradient(colors: [.purple, .red,  .yellow], startPoint: .topTrailing, endPoint: .bottomLeading))
                            } else if socialPlatform[count] == .PhoneNumber {
                                Image(socialPlatform[count].rawValue.lowercased())
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color.green)
                            } else {
                                Image(socialPlatform[count].rawValue.lowercased())
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .symbolRenderingMode(.multicolor)
                            }
                            Text("\(socialPlatform[count].rawValue): ")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                            Group {
                                if socialPlatform[count] == .PhoneNumber {
                                    Text(appendedStringPRE[count])
                                    +
                                    Text(rawStringMAIN[count])
                                } else {
                                    Text(appendedStringMAIN[count])
                                }
                            }
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                            .contentTransition(.numericText())
                            .foregroundStyle(copying[count] ? .blue.mix(with: .white, by: 0.1) : Color("Foreground-match"))
                            .transaction { t in
                                if justAppeared == false {
                                    t.animation = .default
                                }
                            }
                        }.onTapGesture {
                            if copying[count] == false && justAppeared == false{
                                copySocials(count: count)
                            }
                        }
                        Spacer()
                        Button(action: {
                            if let url = URL(string: returnSocialWebsite(platform: socialPlatform[count], pre: rawStringPRE[count], main: rawStringMAIN[count])) {
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
                    if !(socialsCounter == count) {
                        Divider()
                    }
                }
            } else {
                HStack {
                    Spacer()
                    Image(systemName: "person.fill.questionmark")
                        .foregroundStyle(.gray)
                    Text("No Socials :(")
                        .foregroundStyle(.gray)
                    Spacer()
                }.frame(height: 20)
            }
        }
        .onAppear {
            loadAllSocials()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                justAppeared = false
            }
        }
        .padding()
        .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ProfileViewSocials(socials: 
                        [
                        socials(socialPlatform: .PhoneNumber, stringPRE: "65", stringMAIN: "91234567"),
                         socials(socialPlatform: .Instagram, stringPRE: "", stringMAIN: "Username"),
                        socials(socialPlatform: .Discord, stringPRE: "", stringMAIN: "Username"),
                        socials(socialPlatform: .Slack, stringPRE: "", stringMAIN: "Username"),
                        socials(socialPlatform: .Telegram, stringPRE: "", stringMAIN: "Username"),
                        socials(socialPlatform: .Youtube, stringPRE: "", stringMAIN: "Username")
                        ], demo: true)
}
