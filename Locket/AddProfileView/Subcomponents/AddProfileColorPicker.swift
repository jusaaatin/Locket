//
//  AddProfileColorPicker.swift
//  Locket
//
//  Created by Justin Damhaut on 21/6/24.
//

import SwiftUI

struct AddProfileColorPicker: View {
    
    @State var selectedColor: selectedColor = .white
    @State var colorPickerSelection: Color = .indigo
    var hexInput: String
    var accentIsDefaultFg: Bool
    
    private func colorbuttontoenum(color:  Color) {
        if color == .red {
            selectedColor = .red
        }
        if color == .orange {
            selectedColor = .orange
        }
        if color == .yellow {
            selectedColor = .yellow
        }
        if color == .green {
            selectedColor = .green
        }
        if color == .mint {
            selectedColor = .mint
        }
        if color == .teal {
            selectedColor = .teal
        }
        if color == .cyan {
            selectedColor = .cyan
        }
        if color == .blue {
            selectedColor = .blue
        }
        if color == .indigo {
            selectedColor = .indigo
        }
        if color == .purple {
            selectedColor = .purple
        }
        if color == .brown {
            selectedColor = .brown
        }
        if color == Color("Foreground-match") {
            selectedColor = .white
        }
    }
    
    @Binding var finalColorOutput: Color
    
    func loadHex() {
        selectedColor = .picker
        colorPickerSelection = Color(hex: hexInput) ?? Color.indigo
        print(hexInput)
        print("\(colorPickerSelection)")
        print("\(accentIsDefaultFg)")
    }
    
    var body: some View {
        HStack {
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(defaultColors, id: \.self) { color in
                            Button(action: {
                                withAnimation() {
                                    colorbuttontoenum(color: color)
                                }
                            }, label: {
                                if selectedColor.rawValue == String("\(color)") {
                                    Circle()
                                        .stroke(color.mix(with:.white, by: 0.4), lineWidth:6)
                                        .fill(color)
                                        .frame(width:34, height:34)
                                        .scaleEffect(0.8)
                                } else if selectedColor == .white && color == Color("Foreground-match") {
                                    Circle()
                                        .stroke(color.mix(with:Color("Background-match"), by: 0.4), lineWidth:6)
                                        .fill(color)
                                        .frame(width:34, height:34)
                                        .scaleEffect(0.8)
                                } else {
                                    Circle()
                                        .foregroundStyle(color)
                                        .frame(width:26, height:26)
                                        .scaleEffect(1)
                                }
                            })
                            .frame(width: 26)
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)

                }
                .grayscale(selectedColor != .picker ? 0 : 0.5)
                .opacity(selectedColor != .picker ? 1 : 0.5)
                HStack {
                    Rectangle()
                        .frame(width: 20, height: 35)
                        .foregroundStyle(
                            LinearGradient(gradient: Gradient(colors: [Color.gray.mix(with:Color("Background-match"), by: 0.7).opacity(100), Color.gray.mix(with:Color("Background-match"), by: 0.7).opacity(0)]), startPoint: .leading, endPoint: .trailing))
                    Spacer()
                    Rectangle()
                        .frame(width: 20, height: 35)
                        .foregroundStyle(
                            LinearGradient(gradient: Gradient(colors: [Color.gray.mix(with:Color("Background-match"), by: 0.7).opacity(0), Color.gray.mix(with:Color("Background-match"), by: 0.7).opacity(100)]), startPoint: .leading, endPoint: .trailing))
                }

            }
            ColorPicker("", selection:$colorPickerSelection)
                .frame(width: 40, height: 44)
                .grayscale(selectedColor == .picker ? 0 : 0.5)
                .opacity(selectedColor == .picker ? 1 : 0.5)
                .onChange(of: colorPickerSelection) { oldValue, newValue in
                    selectedColor = .picker
                    finalColorOutput = pickercolorOutput(selected: selectedColor, pickerselection: colorPickerSelection)
                }
                .padding(.leading, -20)
                .onChange(of: selectedColor) { oldValue, newValue in
                    finalColorOutput = pickercolorOutput(selected: selectedColor, pickerselection: colorPickerSelection)
                }
        }
        .onAppear() {
            loadHex()
        }
        Text(hexInput)
        Text("\(colorPickerSelection)")
        Text("\(accentIsDefaultFg)")
    }
}

#Preview {
    @Previewable @State var accentcolor = Color.indigo
    AddProfileColorPicker(hexInput: "FFFFFF", accentIsDefaultFg: false, finalColorOutput: $accentcolor)
    Text("DEBUG")
        .foregroundStyle(accentcolor)
}
