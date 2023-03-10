//
//  Grep.swift
//  Grep
//
//  Created by Глеб Михновец on 23.02.2023.
//

import Foundation

func shell(args: String...) -> String? {
	let task = Process()
	let pipe = Pipe()
	
	task.standardOutput = pipe
	task.executableURL = URL(fileURLWithPath: "/bin/bash")
	//task.launchPath = "/bin/bash"
	task.arguments = ["-c"]
	print(args)
	task.arguments = task.arguments! + args
	try? task.run()
	if let data = try? pipe.fileHandleForReading.readToEnd() {
		let output = String(data: data, encoding: .utf8)!
		return output
	} else {
		return nil
	}
}
