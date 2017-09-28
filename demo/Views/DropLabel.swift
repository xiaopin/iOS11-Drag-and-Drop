//
//  DropLabel.swift
//  demo
//
//  Created by nhope on 2017/9/28.
//  Copyright © 2017年 nhope. All rights reserved.
//

import UIKit

class DropLabel: UILabel {

    override func canPaste(_ itemProviders: [NSItemProvider]) -> Bool {
        for item in itemProviders {
            if item.canLoadObject(ofClass: NSString.self) {
                return true
            }
        }
        return false
    }
    
    
    override func paste(itemProviders: [NSItemProvider]) {
        for item in itemProviders {
            if !item.canLoadObject(ofClass: NSString.self) {
                continue
            }
            item.loadObject(ofClass: NSString.self, completionHandler: { (itemProviderReading, error) in
                guard let text = itemProviderReading as? NSString else { return }
                DispatchQueue.main.sync {
                    self.text = "\(self.text ?? "") \(text)"
                }
            })
        }
    }

}
