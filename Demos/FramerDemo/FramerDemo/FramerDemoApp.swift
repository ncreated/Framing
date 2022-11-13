//
//  FramerDemoApp.swift
//  FramerDemo
//
//  Created by Maciek Grzybowski on 31/07/2022.
//

import SwiftUI
import Framer
import Framing

@main
struct FramerDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    FramerWindow.install()

                    FramerWindow.current.addButton(title: "Foo") {
                        print("Foo")
                    }
                    FramerWindow.current.addButton(title: "Bar") {
                        print("Bar")
                    }
                    FramerWindow.current.addButton(title: "Bizz") {
                        print("Bizz")
                    }
                }
        }
    }
}
