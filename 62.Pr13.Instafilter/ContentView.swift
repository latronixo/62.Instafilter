//
//  ContentView.swift
//  62.Instafilter
//
//  Created by Валентин on 26.08.2025.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingFilters = false
    @State private var imageDidLoaded = false
    
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    // здесь мы создаем экземпляр класса CI, который соответствует протоколу CIImage
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus",
                                               description: Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)
                
                Spacer()
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity, applyIntensity)
                        .disabled(!imageDidLoaded)
                }
                
                HStack {
                    Text("Radius")
                    Slider(value: $filterRadius)
                        .onChange(of: filterRadius, applyRadius)
                        .disabled(!imageDidLoaded)
                }
                
                HStack {
                    Text("Scale")
                    Slider(value: $filterScale)
                        .onChange(of: filterScale, applyScale)
                        .disabled(!imageDidLoaded)
                }
                
                HStack {
                    Button("Change Filter", action: changeFilter)
                        .disabled(!imageDidLoaded)
                    
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystallize") { setFilter(CIFilter.crystallize() )}         //кристаллизация
                Button("Edges") { setFilter(CIFilter.edges() )}                     //границы
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur() )}      //размытие по Гауссу
                Button("Pixellate") { setFilter(CIFilter.pixellate() )}             //пикселлизация
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone() )}            //оттенок сепия
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask() )}        //нечеткая маска
                Button("Vignette") { setFilter(CIFilter.vignette() )}               //виньетка
                Button("BumpDistortion") { setFilter(CIFilter.bumpDistortion() )}               //виньетка
                Button("BumpDistortionLinear") { setFilter(CIFilter.bumpDistortionLinear() )}               //виньетка
                Button("circularWrap") { setFilter(CIFilter.circularWrap() )}               //виньетка
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self), let inputImage = UIImage(data: imageData) else {
                imageDidLoaded = false
                return
            }
            
            imageDidLoaded = true
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyIntensity()
        }
    }
    
    func applyIntensity () {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        
        applyfilters()
    }
    
    func applyRadius () {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey) }
        
        applyfilters()
    }
    
    func applyScale () {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        
        applyfilters()
    }
    
    private func applyfilters() {
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        
        if filterCount == 3 {
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}
