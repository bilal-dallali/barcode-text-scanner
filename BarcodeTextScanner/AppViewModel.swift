//
//  AppViewModel.swift
//  BarcodeTextScanner
//
//  Created by Bilal Dallali on 21/11/2022.
//

import AVKit
import Foundation
import SwiftUI
import VisionKit

enum DataScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case scannerNotAvailable
}

@MainActor
final class AppViewModel: ObservableObject {
    
    @Published var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined
    
    private var isScannerAvailabla: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    func requestDataScannerAccessStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAccessStatus = .cameraNotAvailable
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            dataScannerAccessStatus = isScannerAvailabla ? .scannerAvailable : .scannerNotAvailable
        case .restricted, .denied:
            dataScannerAccessStatus = .cameraAccessNotGranted
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                dataScannerAccessStatus = isScannerAvailabla ? .scannerAvailable : .scannerNotAvailable
            } else {
                dataScannerAccessStatus = .cameraAccessNotGranted
            }
            
        default: break
            
        }
        
    }
    
}
