//
//  GrepApp.swift
//  Grep
//
//  Created by Глеб Михновец on 23.02.2023.
//

import SwiftUI

@main
struct GrepApp: App {
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
    var body: some Scene {
        WindowGroup {
			ContentView()
		}.windowStyle(.hiddenTitleBar).windowResizability(.contentSize)
	}
}

class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		true
	}
}
