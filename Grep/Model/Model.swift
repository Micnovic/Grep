//
//  Model.swift
//  Grep
//
//  Created by Глеб Михновец on 25.02.2023.
//

import Foundation

struct ResultRow: Identifiable {
	let path: String
	let pathWithLineNumber: String
	let text: String
	let id: UUID
}

func openFileByPath(_ row: ResultRow, currentPath: String) {
	let pathOnly = row.path.prefix(row.path.count - 1)
	let pathOnlySuffix = pathOnly.suffix(pathOnly.count - 1)
	let fullPath = currentPath + pathOnlySuffix
	let fullPathNoEscapingChars = fullPath.replacingOccurrences(of: "\\", with: "")
	print(fullPathNoEscapingChars)
	showInFinder(url: URL(fileURLWithPath: fullPathNoEscapingChars))
}

extension ContentView {
	func performGrep() {
		isLoading = true
		DispatchQueue.global(qos: .background).async {
			let caseInsensitivityFlag = caseInsensitivity ? "-i " : ""
			let lineNumberFlag = lineNumber ? "-n " : ""
			let recursiveFlag = recursive ? "-r " : ""
			let noHeadersFlag = "-h "
			let fileName = " ./*"
			
			let textOnly = shell(args: "cd " + currentPath + " && grep " + noHeadersFlag + caseInsensitivityFlag + recursiveFlag + search + fileName + fileFormat)
			let textOnlyArray = textOnly?.components(separatedBy: "\n") ?? []
			let textWithPathsNoNumbers = shell(args: "cd " + currentPath + " && grep " + caseInsensitivityFlag + recursiveFlag + search + fileName + fileFormat)
			let textWithPathsNoNumbersArray = textWithPathsNoNumbers?.components(separatedBy: "\n") ?? []
			let textWithPathsWithNumbers = shell(args: "cd " + currentPath + " && grep " + caseInsensitivityFlag + recursiveFlag + lineNumberFlag + search + fileName + fileFormat)
			let textWithPathsWithNumbersArray = textWithPathsWithNumbers?.components(separatedBy: "\n") ?? []
			
			combinedArray = []
			for i in 0..<textOnlyArray.count {
				let path = textWithPathsNoNumbersArray[i].prefix(textWithPathsNoNumbersArray[i].count - textOnlyArray[i].count)
				let text = textOnlyArray[i]
				let pathWithLineNumber = textWithPathsWithNumbersArray[i].prefix(textWithPathsWithNumbersArray[i].count - textOnlyArray[i].count)
				combinedArray.append(ResultRow(path: String(path), pathWithLineNumber: String(pathWithLineNumber), text: text, id: UUID()))
			}
			isLoading = false
		}
	}
	
	func loadOnDrop(itemProviders: [NSItemProvider], mouseLocation: CGPoint) -> Bool {
		   _ = itemProviders.first!.loadObject(ofClass: URL.self) { object, error in
				   if let path = object?.relativePath.replacingOccurrences(of: " ", with: #"\ "#){
					   currentPath = path
					   pathPresent = true
					   performGrep()
				   }
		   }
		   return true
	}
	
}
