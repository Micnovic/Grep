//
//  ContentView.swift
//  Grep
//
//  Created by Глеб Михновец on 23.02.2023.
//

import SwiftUI

struct ContentView: View {
	@State var search: String = ""
	@State var fileFormat: String = ""
	@State var currentPath: String = ""
	@State var pathPresent: Bool = false
	@State var caseInsensitivity: Bool = true
	@State var lineNumber: Bool = true
	@State var recursive: Bool = false
	@State var combinedArray: [ResultRow] = []
	@State var isLoading: Bool = false
	@State var textSize: Double = 14
	
    var body: some View {
        VStack {
			
			VStack {
				TextField("Search input", text: $search).textFieldStyle(.roundedBorder).onSubmit {
					performGrep()
				}
				.padding(.top)
				
				TextField("File format (leave empty for any)", text: $fileFormat)
					.textFieldStyle(.roundedBorder)
					.onSubmit {
						performGrep()
					}
				
				TextField("Current path", text: $currentPath)
					.onSubmit {
						performGrep()
					}
					.textFieldStyle(.roundedBorder)
					.padding(.bottom)
				
				HStack {
					Toggle("Case insensitivity", isOn: $caseInsensitivity)
						.toggleStyle(.switch)
						.labelsHidden()
						.onChange(of: caseInsensitivity) { _ in
							performGrep()
						}
					Text("Case insensitivity")
						.font(.headline)
					Spacer()
				}
				
				HStack {
					Toggle("Search in subfolders", isOn: $recursive)
						.toggleStyle(.switch)
						.labelsHidden()
						.onChange(of: recursive) { _ in
							performGrep()
						}
					Text("Search in subfolders").font(.headline)
					Spacer()
				}.padding(.bottom, 25)
				
				if (!pathPresent) {
					Image(systemName: "square.dashed")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.padding(.bottom, 25)
						.foregroundColor(.gray)
						.frame(maxWidth: 200, maxHeight: 200)
				}
				
				if (!pathPresent){
					Text("Drag and drop folder to execute grep command")
						.multilineTextAlignment(.center)
						.frame(minWidth: 100, idealWidth: 200)
						.padding(.bottom)
				}
			}.padding(.bottom, 0).padding(.horizontal, 30).padding(.top, 20)
			
			if (pathPresent){
				ResultsTable(combinedArray: combinedArray, currentPath: currentPath, isLoading: $isLoading, textSize: textSize).padding(.all, 0).ignoresSafeArea()
			}
			
		}.ignoresSafeArea(.all)
		.padding(.all, 0)
		.frame(minWidth: 400, maxWidth: 800)
		.onDrop(of: [.url], isTargeted: nil, perform: loadOnDrop)
		.toolbar {
			Spacer()
			HStack{
				Image(systemName: "character").resizable().scaledToFit().frame(width:7).foregroundColor(.secondary)
				Slider(value: $textSize, in: 11...24)
					.frame(width: 80)
				Image(systemName: "character").resizable().scaledToFit().frame(width:10).foregroundColor(.secondary)
			}
			.padding(.horizontal, 30)
		}
	}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
