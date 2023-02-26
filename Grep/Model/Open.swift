//
//  Open.swift
//  Grep
//
//  Created by Глеб Михновец on 25.02.2023.
//

import Foundation
import AppKit

func showInFinder(url: URL?) {
	guard let url = url else {
		print("could not read url")
		return
	}
	
	if url.isDirectory {
		NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path)
	} else {
		let openConfiguration = NSWorkspace.OpenConfiguration()
		openConfiguration.activates = true
		NSWorkspace.shared.open(url, configuration: openConfiguration)
	}
}

extension URL {
	var isDirectory: Bool {
		return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
	}
}

