//
//  ProfileViewHeaderImage.swift
//  Locket
//
//  Created by Justin Damhaut on 9/6/24.
//

import SwiftUI

let screenWidth: Int = Int(UIScreen.main.bounds.width)

let foodCarouselImages = [
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
    "demofood12"
]

let foodCarouselImagesMain = [
    "demofood12",
    "demofood1",
    "demofood9"
]

let randomSelectedCarousellImagesMain: String = foodCarouselImagesMain.shuffled().prefix(1).joined()

func generateImages(mainImage: String) -> [String] {
    var carouselImagesShuffled = [String]()
    carouselImagesShuffled.append(randomSelectedCarousellImagesMain)
    carouselImagesShuffled.append(contentsOf: foodCarouselImages.filter{$0 != randomSelectedCarousellImagesMain}.shuffled())
    return carouselImagesShuffled
}


struct ProfileViewHeaderImage: View {
    
    let demo: Bool
    let mainImage: Data
    let slideImages: [Data]
    
    private func dataGenerateImages(mainImage: Data, slideImages: [Data]) -> [Data]{
        var allImages: [Data] = []
        allImages.append(mainImage)
        allImages.append(contentsOf: slideImages.shuffled())
        return allImages
    }
    private func dataToUiImage(data: Data) -> UIImage {
        return UIImage(data: data) ?? UIImage()
    }
    
    @GestureState private var zoom = 1.0
 
    var body: some View {
        TabView() {
            if demo {
                ForEach(generateImages(mainImage: randomSelectedCarousellImagesMain).prefix(20) , id: \.self) {image in
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: CGFloat(screenWidth))
                        .clipped()
                        .scaleEffect(zoom)
                        .gesture(
                            MagnifyGesture()
                            .updating($zoom) { value, gestureState, transaction in
                            gestureState = value.magnification
                            }
                        )
                }
            } else {
                ForEach(dataGenerateImages(mainImage: mainImage, slideImages: slideImages).prefix(10), id: \.self) { dataImage in
                    Image(uiImage: dataToUiImage(data: dataImage))
                        .resizable()
                        .scaledToFill()
                        .frame(width: CGFloat(screenWidth))
                        .clipped()
                        .scaleEffect(zoom)
                        .gesture(
                            MagnifyGesture()
                            .updating($zoom) { value, gestureState, transaction in
                            gestureState = value.magnification
                            }
                        )
                }
            }
        }
        .scrollClipDisabled()
        #if os(iOS)
        .tabViewStyle(.page(indexDisplayMode: .never))
        #endif
    }
}

#Preview {
    ProfileViewHeaderImage(demo: true, mainImage: Data(), slideImages: [Data]())
}

