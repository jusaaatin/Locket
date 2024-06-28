//
//  tabBar.swift
//  Locket
//
//  Created by Justin Damhaut on 11/6/24.
//

import SwiftUI

struct tabBar: View {

    @Binding public var currentPage: paginator
    @State private var gearChangeTrigger = 1
    
    func returnTabElementColor(tabelement: paginator) -> Color {
        if currentPage == tabelement {
            return .blue
        } else {
            return .white
        }
    }
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.snappy) {
                    currentPage = .left
                }
            } label: {
                if currentPage == .left {
                    Image(systemName: "house.fill")
                        .padding()
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundStyle(.blue)
                } else {
                    Image(systemName: "house")
                        .padding()
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            
            Button {
                withAnimation(.snappy) {
                    currentPage = .mid
                }
            } label: {
                if currentPage == .mid {
                    Image(systemName: "plus")
                        .padding()
                        .frame(width:60, height:40)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue.gradient)
                                .stroke(.blue, lineWidth: 2)
                        )
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                } else {
                    Image(systemName: "plus")
                        .padding()
                        .frame(width:60, height:40)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.gray, lineWidth: 2)
                        )
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            
            Button {
                if currentPage != .right {
                    gearChangeTrigger += 1
                }
                withAnimation(.snappy) {
                    currentPage = .right
                }
            } label: {
                Image(systemName: "gear")
                    .padding()
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(returnTabElementColor(tabelement: .right))
               //     .symbolEffect(.rotate, value: gearChangeTrigger)
            }
        }
        .frame(height: 60)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding()
        .shadow(radius: 5)
    }
}

#Preview {
    @Previewable @State var currentPage: paginator = .left
    tabBar(currentPage: $currentPage)
}

