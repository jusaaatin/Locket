//
//  Universal Declarations.swift
//  Locket
//
//  Created by Justin Damhaut on 10/6/24.
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit
#endif
import _PhotosUI_SwiftUI

// profileview header 01
func addOrSubtractDay(day:Int)->Date{
  return Calendar.current.date(byAdding: .day, value: day, to: Date())!
}

func addOrSubtractMonth(month:Int)->Date{
  return Calendar.current.date(byAdding: .month, value: month, to: Date())!
}

func addOrSubtractYear(year:Int)->Date{
  return Calendar.current.date(byAdding: .year, value: year, to: Date())!
}


// profile view
enum RelationshipStatus: Codable, Hashable {
    case crush, relationship, friend, bestie
    var id: Self { self }
}

enum paginator {
    case left, mid, right, none
    var id: Self { self }
}

// home view
enum filterState {
    case showAll, crush, relationship, friend, bestie
    var id: Self { self }
}

enum querySortOrder {
    case aToZ, zToA, createdNewest, createdOldest, birthdayFirstToLast
    var id: Self { self }
}

enum locketPages {
    case home, newProfile, profile, settings, editProfile
    var id: Self { self }
}


enum socialPlatforms: String, Codable, Hashable, Identifiable, CaseIterable{
    case PhoneNumber = "Phone",
         Instagram = "Instagram",
         Tiktok = "Tiktok",
         Telegram = "Telegram",
         Twitter = "Twitter",
         Discord = "Discord",
         Youtube = "Youtube",
         Twitch = "Twitch",
         Github = "Github",
         Bluesky = "Bluesky",
         Discourse = "Discourse",
         Facebook = "Facebook",
         Linkedin = "Linkedin",
         Mastodon = "Mastodon",
         Matrix = "Matrix",
         Microblog = "Microblog",
         Reddit = "Reddit",
         Slack = "Slack",
         Threads = "Threads"
    var id: Self { self }
}

// filter buttons
struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
        }
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}


extension String {
  func toRGBA() -> (r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
    var hexSanitized = self.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0
    
    let length = hexSanitized.count
    
    Scanner(string: hexSanitized).scanHexInt64(&rgb)
    
    if length == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
    }
    else if length == 8 {
      r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x000000FF) / 255.0
    }
    
    return (r, g, b, a)
  }
}

extension View {
    /// Focuses next field in sequence, from the given `FocusState`.
    /// Requires a currently active focus state and a next field available in the sequence.
    ///
    /// Example usage:
    /// ```
    /// .onSubmit { self.focusNextField($focusedField) }
    /// ```
    /// Given that `focusField` is an enum that represents the focusable fields. For example:
    /// ```
    /// @FocusState private var focusedField: Field?
    /// enum Field: Int, Hashable {
    ///    case name
    ///    case country
    ///    case city
    /// }
    /// ```
    func focusNextField<F: RawRepresentable>(_ field: FocusState<F?>.Binding) where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return }
        let nextValue = currentValue.rawValue + 1
        if let newValue = F.init(rawValue: nextValue) {
            field.wrappedValue = newValue
        }
    }

    /// Focuses previous field in sequence, from the given `FocusState`.
    /// Requires a currently active focus state and a previous field available in the sequence.
    ///
    /// Example usage:
    /// ```
    /// .onSubmit { self.focusNextField($focusedField) }
    /// ```
    /// Given that `focusField` is an enum that represents the focusable fields. For example:
    /// ```
    /// @FocusState private var focusedField: Field?
    /// enum Field: Int, Hashable {
    ///    case name
    ///    case country
    ///    case city
    /// }
    /// ```
    func focusPreviousField<F: RawRepresentable>(_ field: FocusState<F?>.Binding) where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return }
        let nextValue = currentValue.rawValue - 1
        if let newValue = F.init(rawValue: nextValue) {
            field.wrappedValue = newValue
        }
    }
}

public func DMYtoDate(day: String, month: String, year: String) -> Date {
    let combinedDate = "\(day)/\(month)/\(year)"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yy"
    return dateFormatter.date(from: combinedDate) ?? .now
}

let defaultColors: [Color] = [
    Color("Foreground-match"),
    .red,
    .orange,
    .yellow,
    .green,
    .mint,
    .teal,
    .cyan,
    .blue,
    .indigo,
    .purple,
    .brown
]

enum selectedColor: String, Codable, Hashable, Identifiable, CaseIterable {
    case white,
         red,
         orange,
         yellow,
         green,
         mint,
         teal,
         cyan,
         blue,
         indigo,
         purple,
         brown,
         picker
    var id: Self { self }
}

func pickercolorOutput(selected: selectedColor, pickerselection: Color) -> Color{
    switch selected {
    case .red:
        return Color.red
    case .orange:
        return Color.orange
    case .yellow:
        return Color.yellow
    case .green:
        return Color.green
    case .mint:
        return Color.mint
    case .teal:
        return Color.teal
    case .cyan:
        return Color.cyan
    case .blue:
        return Color.blue
    case .indigo:
        return Color.indigo
    case .purple:
        return Color.purple
    case .brown:
        return Color.brown
    case .picker:
        return pickerselection
    case .white:
        return Color("Foreground-match")
    }
}

