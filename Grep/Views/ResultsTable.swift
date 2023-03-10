//
//  ResultsTable.swift
//  Grep
//
//  Created by Глеб Михновец on 26.02.2023.
//

import Foundation
import SwiftUI

struct ResultsTable: View {
	let combinedArray: [ResultRow]
	let currentPath: String
	@Binding var isLoading: Bool
	let textSize: Double
	@State var isAnimating: Bool = false
	@State var loadingIconScale: Double = 0.001
	@Environment(\.colorScheme) private var colorScheme
	var body: some View {
		VStack {
			ZStack{
				Table(combinedArray) {
					TableColumn("Path") { row in
						Button(action: { openFileByPath(row, currentPath: currentPath)}){
							Text(row.pathWithLineNumber)
								.padding(.vertical, 5)
								.foregroundColor(.secondary)
								.lineLimit(1)
						}
						.font(.system(size: textSize))
					}
					.width(min:60, ideal: 100)
					TableColumn("Text") { row in
						Text(row.text)
							.padding(.vertical, 5)
							.lineLimit(10)
							.font(.system(size: textSize))
					}
					.width(min:60, ideal: 500)
				}
				.tableStyle(.inset(alternatesRowBackgrounds: true))
				.cornerRadius(25)
				.frame(minHeight: 200)
				.textSelection(.enabled)
				if (isLoading) {
					Image(systemName: "rays")
						.resizable().frame(width: 50, height: 50)
						.foregroundColor(.gray).blendMode(colorScheme == .dark ? .lighten : .multiply)
						.rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
						.animation(Animation
							.easeInOut(duration: 1)
							.repeatForever(autoreverses: true), value: isAnimating)
						.scaleEffect(loadingIconScale)
						.animation(Animation.easeIn(duration: 0.2), value: loadingIconScale)
						.onAppear{
							isAnimating = true
							loadingIconScale = 1
						}
						.padding(.top, 20)
						.onDisappear(){
							isAnimating = false
							loadingIconScale = 0.001
						}
				}
			}
		}
	}
}
