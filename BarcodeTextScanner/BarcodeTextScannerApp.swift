//
//  BarcodeTextScannerApp.swift
//  BarcodeTextScanner
//
//  Created by Bilal Dallali on 21/11/2022.
//

import SwiftUI

@main
struct BarcodeTextScannerApp: App {
    
    @StateObject private var vm = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .task {
                    await vm.requestDataScannerAccessStatus()
                }
        }
    }
}
