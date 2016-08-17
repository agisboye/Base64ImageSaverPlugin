//
//  Base64ImageSaver.swift
//  Lectio+
//
//  Created by August Heegaard on 16/11/15.
//  Copyright © 2015 Totus Labs. All rights reserved.
//

import Foundation
import Photos

@objc(Base64ImageSaverPlugin)
public class Base64ImageSaverPlugin: CDVPlugin {
    
    public func saveImageDataToLibrary(_ command: CDVInvokedUrlCommand) -> Void {
        
        if let base64String = command.argument(at: 0) as? String, let imageData = Data(base64Encoded: base64String, options: []), let image = UIImage(data: imageData) {
            
            PHPhotoLibrary.shared().performChanges({
                
                // Attempt to save photo
                PHAssetChangeRequest.creationRequestForAsset(from: image)
                
                }, completionHandler: { (success, error) in
                    
                    if let error = error {
                        let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription)
                        self.commandDelegate?.send(result, callbackId: command.callbackId)
                        return
                    } else if !success {
                        let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "An error occurred")
                        self.commandDelegate?.send(result, callbackId: command.callbackId)
                        return
                    }
                    
                    let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Image saved to photo library")
                    self.commandDelegate?.send(result, callbackId: command.callbackId)
                    
                    
            })
            
        }
        
    }
    
}
