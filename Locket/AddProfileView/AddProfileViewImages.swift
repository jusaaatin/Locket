//
//  AddProfileViewThumbnail.swift
//  Locket
//
//  Created by Justin Damhaut on 21/6/24.
//

import SwiftUI
import PhotosUI

struct AddProfileViewImages: View {
    
    private func loadImages(from items: [PhotosPickerItem]) async {
        imageLoadingDone = false
        defer { imageLoadingDone = true }

        var loadedImages: [Data] = []
        loadedImages.reserveCapacity(min(items.count, 15))

        for item in items.prefix(15) {
            guard !Task.isCancelled else { return }
            do {
                guard let imageData = try await item.loadTransferable(type: Data.self) else { continue }
                let encodedImage = await Task.detached(priority: .userInitiated) {
                    StoredImageEncoder.encode(imageData, maxPixelSize: 2_048)
                }.value
                if encodedImage != shownThumbnail {
                    loadedImages.append(encodedImage)
                }
            } catch {
                print("Failed to load image: \(error.localizedDescription)")
            }
        }

        guard !Task.isCancelled else { return }
        slideImages = loadedImages
    }
    
    @Binding var imageLoadingDone: Bool
    @State var selectedThumbnail: PhotosPickerItem?
    @Binding var shownThumbnail: Data
    @State var selectedSlideImages: [PhotosPickerItem] = []
    @Binding var slideImages: [Data]
    @State private var showSlidePhotosPicker: Bool = false
    @State var debug: Bool
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle().frame(width: 102, height: 75).zIndex(2).foregroundStyle(Color.gray.mix(with:Color("Background-match"), by: 0.7))
                PhotosPicker(selection: $selectedThumbnail, matching: .any(of: [.images, .not(.livePhotos)])) {
                    if shownThumbnail.isEmpty {
                        ZStack {
                            MeshGradient(
                                width: 3,
                                height: 3,
                                points: [
                                    [0.0, 0.0], [0.5, 0], [1.0, 0.0],
                                    [0.0, 0.5], [0.7, 0.5], [1.0, 0.5],
                                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                                ], colors: [
                                    .red, .red.mix(with: .purple, by: 0.5), .red.mix(with: .purple, by: 0.8),
                                    .red.mix(with: .purple, by: 0.8), .purple.mix(with: .blue, by: 0.4), .indigo,
                                    .indigo.mix(with: .red, by: 0.5), .blue.mix(with: .purple, by: 0.6), .indigo.mix(with: .blue, by: 0.8)
                                ],
                                
                                smoothsColors: true,
                                colorSpace: .perceptual
                            ).opacity(0.8)
                                .frame(width:68, height:68)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .blur(radius: 4)
                            Image(systemName: "photo")
                                .foregroundStyle(.white).opacity(0.6)
                                .font(.system(size: 24))
                        }
                        .frame(width:70, height:70)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .clipped()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.thickMaterial.opacity(0.8), lineWidth: 3)
                        )
                    } else {
                        if let uithumb = StoredImageCache.image(from: shownThumbnail) {
                            Image(uiImage: uithumb)
                                .resizable()
                                .scaledToFill()
                                .frame(width:70, height:70)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .clipped()
                        }
                    }
                }.zIndex(3)
                    .onChange(of: selectedThumbnail) { oldThumbnail, newThumbnail in
                        if oldThumbnail != newThumbnail {
                            Task {
                                imageLoadingDone = false
                                defer { imageLoadingDone = true }
                                if let thumbnailData = try? await newThumbnail?.loadTransferable(type: Data.self) {
                                    shownThumbnail = await Task.detached(priority: .userInitiated) {
                                        StoredImageEncoder.encode(thumbnailData, maxPixelSize: 1_024)
                                    }.value
                                }
                            }
                        }
                    }
            }.padding(.trailing, -12).padding(.leading, -10)
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            showSlidePhotosPicker = true
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
                                    .indigo, .green.mix(with: .purple, by: 0.2), .green.mix(with: .mint, by: 0.8),
                                    .green.mix(with: .mint, by: 0.8), .teal.mix(with: .green, by: 0.4), .indigo,
                                    .mint.mix(with: .purple, by: 0.5), .mint.mix(with: .green, by: 0.6), .indigo.mix(with: .mint, by: 0.6)
                                ],
                                             
                                    smoothsColors: true,
                                    colorSpace: .perceptual
                                ).opacity(0.8)
                                    .frame(width:68, height:68)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .blur(radius: 4)
                                Image(systemName: "photo.stack")
                                    .foregroundStyle(.white).opacity(0.6)
                                    .font(.system(size: 24))
                            }
                            .frame(width:70, height:70)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .clipped()
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.thickMaterial.opacity(0.8), lineWidth: 3)
                            )
                        })
                        .photosPicker(isPresented: $showSlidePhotosPicker, selection: $selectedSlideImages, maxSelectionCount: 15, selectionBehavior: .ordered, matching: .images)
                        .task(id: selectedSlideImages) {
                            await loadImages(from: selectedSlideImages)
                        }
                        ZStack {
                            HStack {
                                ForEach(slideImages.indices, id: \.self) { index in
                                    Button(action: {
                                        withAnimation(.bouncy) {
                                            
                                        }
                                    }, label: { 
                                        if let uiSlideImage = StoredImageCache.image(from: slideImages[index]) {
                                            Image(uiImage: uiSlideImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width:70, height:70)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                                .clipped()
                                        }
                                    })
                                }
                            }
                        }
                        if slideImages.count > 0 {
                            Button(action: {
                                slideImages.removeAll()
                                selectedSlideImages = []
                                imageLoadingDone = true
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
                                        .frame(width:68, height:68)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .blur(radius: 4)
                                    Image(systemName: "trash.fill")
                                        .foregroundStyle(.white).opacity(0.6)
                                        .font(.system(size: 28))
                                }
                                .frame(width:70, height:70)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .clipped()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.thickMaterial.opacity(0.8), lineWidth: 3)
                                )
                            })
                        }
                    }
                    .padding([.leading, .trailing])
                }.scrollClipDisabled()
                HStack {
                    Rectangle()
                        .frame(width: 20, height: 75)
                        .foregroundStyle(
                            LinearGradient(gradient: Gradient(colors: [Color.gray.mix(with:Color("Background-match"), by: 0.7).opacity(100), Color.gray.mix(with:Color("Background-match"), by: 0.7).opacity(0)]), startPoint: .leading, endPoint: .trailing))
                    Spacer()
                    Rectangle()
                        .frame(width: 20, height: 75)
                        .foregroundStyle(
                            LinearGradient(gradient: Gradient(colors: [Color.gray.mix(with:Color("Background-match"), by: 0.7).opacity(0), Color.gray.mix(with:Color("Background-match"), by: 0.7).opacity(100)]), startPoint: .leading, endPoint: .trailing))
                }
            }.padding(.leading, -10).zIndex(-2).padding(.trailing, -20)
            if debug {
                VStack(alignment: .trailing) {
                    Text("selected: \(selectedSlideImages.count)")
                    Text("slide: \(slideImages.count)")
                    Text(imageLoadingDone ? "true" : "false")
                }
            }
        }
        .padding(6)
        .padding(.trailing, 6)
        .background(Color.gray.mix(with:Color("Background-match"), by: 0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
}

#Preview {
    @Previewable @State var shownThumbnail: Data = Data()
    @Previewable @State var slideImages: [Data] = []
    @Previewable @State var imageLoadingDone = true
    AddProfileViewImages(imageLoadingDone: $imageLoadingDone, shownThumbnail: $shownThumbnail, slideImages: $slideImages, debug: true)
        .padding()
}
