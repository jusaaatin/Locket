//
//  ProfileViewImages.swift
//  Locket
//
//  Created by Justin Damhaut on 1/7/24.
//

import SwiftUI

struct ProfileViewImages: View {
    
    @State var demo: Bool
    @State var mainImage: Data
    @State var slideImages: [Data]
    
    @State var allImages: [Data] = []
    @State var demoImages: [String] = []
    
    let DEMOfoodCarouselImages = [
        "demofood1",
        "demofood2",
        "demofood3",
        "demofood4",
        "demofood5",
        "demofood6",
        "demofood7",
        "demofood8",
        "demofood9",
        "demofood10",
        "demofood11",
    ]

    let DEMOfoodCarouselImageMain = [
        "demofood12"
    ]
    
    let screenWidth: Int = Int(UIScreen.main.bounds.width)
    
    private func getWidth() -> CGFloat {
        return CGFloat(0.2*Double(screenWidth))
    }
    
    private func dataToUiImage(data: Data) -> UIImage {
        return UIImage(data: data) ?? UIImage()
    }
    
    var body: some View {
        
        let twoColumnGrid = [
            GridItem(.adaptive(minimum: CGFloat(getWidth()), maximum: CGFloat(getWidth())), alignment: .center)
        ]
        
        VStack {
            LazyVGrid(columns: twoColumnGrid) {
                if demo {
                    ForEach(demoImages.prefix(11), id: \.self) { image in
                        Button(action: {
                            
                        }, label: {
                            Image(image)
                                .resizable()
                                .minimumScaleFactor(0.1)
                                .scaledToFill()
                                .frame(width:CGFloat(getWidth()), height: CGFloat(getWidth()))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .clipped()
                        })
                    }
                } else {
                    ForEach(allImages.prefix(11), id: \.self) { image in
                        Button(action: {
                            
                        }, label: {
                            Image(uiImage: dataToUiImage(data: image))
                                .resizable()
                                .minimumScaleFactor(0.1)
                                .scaledToFill()
                                .frame(width:CGFloat(getWidth()), height: CGFloat(getWidth()))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .clipped()
                        })
                    }
                }
                if allImages.count > 11 || demoImages.count > 11 {
                    Button(action: {
                        
                    }, label: {
                        ZStack {
                            MeshGradient(
                                width: 3,
                                height: 3,
                                points: [
                                [0.0, 0.0], [0.5, 0], [1.0, 0.0],
                                [0.0, 0.5], [0.7, 0.5], [1.0, 0.5],
                                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                            ], colors: [
                                .red.mix(with: .purple, by: 0.4), .red.mix(with: .orange, by: 0.2), .orange.mix(with: .red, by: 0.8),
                                .red.mix(with: .pink, by: 0.8), .pink.mix(with: .orange, by: 0.4), .pink,
                                .pink.mix(with: .red, by: 0.5), .pink.mix(with: .purple, by: 0.6), .orange.mix(with: .purple, by: 0.6)
                            ],
                                         
                                smoothsColors: true,
                                colorSpace: .perceptual
                            ).opacity(0.8)
                                .frame(width:getWidth(), height:getWidth())
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .blur(radius: 4)
                            Image(systemName: "trash.fill")
                                .foregroundStyle(.white).opacity(0.6)
                                .font(.system(size: 28))
                        }
                        .frame(width:getWidth(), height:getWidth())
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .clipped()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.thickMaterial.opacity(0.8), lineWidth: 3)
                        )
                    })
                }
            }.minimumScaleFactor(0.1)
        }
        .padding([.top, .bottom], 8)
        //se size75 8 375
        //pro size80 18 width 393
        .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear() {
            if demo {
                demoImages.append(contentsOf: DEMOfoodCarouselImageMain)
                demoImages.append(contentsOf: DEMOfoodCarouselImages)
            } else {
                allImages.append(mainImage)
                allImages.append(contentsOf: slideImages)
            }
        }
    }
}

#Preview {
    ProfileViewImages(demo: true, mainImage: Data(), slideImages: [Data]())
        .padding()
}
