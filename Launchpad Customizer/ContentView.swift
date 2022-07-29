//
//  ContentView.swift
//  Launchpad Customizer
//
//  Created by Jade Westover on 7/27/22.
//

import SwiftUI

struct ContentView: View {
    @State var rows = 2.0
    @State var columns = 2.0
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    @State var alertButtonTitle = ""
    @State var alertAction = {}
    @State var alertShowCancel = true
    
    var body: some View {
        VStack {
            HStack {
                Menu("Recommended Presets") {
                    Button("Default") {
                        rows = 5.0
                        columns = 7.0
                    }
                    
                    Button("15/16\" Macbook") {
                        rows = 7.0
                        columns = 10.0
                    }
                    
                    Button("13/14\" Macbook") {
                        rows = 6.0
                        columns = 8.0
                    }
                    
                    Button("27\" iMac") {
                        rows = 10.0
                        columns = 14.0
                    }
                    
                    Button("24\" iMac") {
                        rows = 9.0
                        columns = 12
                    }
                    
                    Button("21\" iMac") {
                        rows = 8.0
                        columns = 11.0
                    }
                }
            }
            .padding([.top, .leading, .trailing])
            Text("Rows")
                .padding(.top)
            HStack {
                Slider(value: $rows, in: 2...18, step: 1.0, onEditingChanged: {_ in })
                TextField("", value: $rows, format: .number)
                    .frame(width: 40)
                    .onSubmit {
                        rows.round(.down)
                        rows = abs(rows)
                    }
            }
            .padding(.horizontal)
            Text("Columns")
            HStack {
                Slider(value: $columns, in: 2...18, step: 1.0, onEditingChanged: {_ in })
                TextField("", value: $columns, format: .number)
                    .frame(width: 40)
                    .onSubmit {
                        rows.round(.down)
                    }
            }
            .padding(.horizontal)
            Spacer()
            HStack {
                Button("Reset Launchpad") {
                    showAlert(title: "Information", message: "This will condense your launchpad icons and set it to the system default amount of pages. This WILL remove any groups you have made in your launchpad as well as reorder icons, so only do this if you want a completely fresh start.", buttonTitle: "Reset Launchpad") {
                        do {
                            guard let dock = UserDefaults(suiteName: "com.apple.dock") else { return }
                            dock.set(true, forKey: "ResetLaunchPad")
                            try shell("killall Dock")
                        } catch {
                            showAlert(title: "Error", message: "There was an issue restarting your launchpad. Please run \"killall Dock\" in a terminal window to see your changes.", buttonTitle: "OK", showCancelButton: false)
                        }
                    }
                }
                .padding([.leading, .bottom])
                Spacer()
                Button("Finish") {
                    if rows < 5 || columns < 7 {
                        showAlert(title: "Information", message: "Setting your rows or columns lower than the default (7x5) will create more launchpad pages, and setting it really low like 2x2 or 3x3 will create a lot of extra pages. Going back to a higher number of rows and columns won't condense pages (icons will still be spread out across pages) unless you reset your launchpad completely (which will remove groups and reorder icons). Do you still wish to set it lower?", buttonTitle: "Continue") {
                            finishButton()
                        }
                    } else {
                        finishButton()
                    }
                }
                .padding([.bottom, .trailing])
                .buttonStyle(.borderedProminent)
            }
        }
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button(alertButtonTitle, action: alertAction)
            if alertShowCancel {
                Button("Cancel") {}
            }
        }, message: {Text(alertMessage)})
        .onAppear {
            guard let dock = UserDefaults(suiteName: "com.apple.dock") else { return }
            rows = Double(dock.integer(forKey: "springboard-rows"))
            columns = Double(dock.integer(forKey: "springboard-columns"))
        }
    }
    
    func finishButton() {
        do {
            guard let dock = UserDefaults(suiteName: "com.apple.dock") else { return }
            dock.set(Int(rows), forKey: "springboard-rows")
            dock.set(Int(columns), forKey: "springboard-columns")
            try shell("killall Dock")
        } catch {
            showAlert(title: "Error", message: "There was an issue restarting your launchpad. Please run \"killall Dock\" in a terminal window to see your changes.", buttonTitle: "OK", showCancelButton: false)
        }
    }
    
    func showAlert(title: String, message: String, buttonTitle: String, showCancelButton: Bool = true, action: @escaping () -> () = {}) {
        alertTitle = title
        alertMessage = message
        alertButtonTitle = buttonTitle
        alertShowCancel = showCancelButton
        alertAction = action
        showAlert = true
    }
    
    func shell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil
        
        try task.run()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
