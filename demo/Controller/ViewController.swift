//
//  ViewController.swift
//  demo
//
//  Created by nhope on 2017/9/28.
//  Copyright © 2017年 nhope. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dragLabel: UILabel!
    @IBOutlet weak var dropLabel: DropLabel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure drag and drop
        let dragInteraction = UIDragInteraction(delegate: self)
        dragInteraction.isEnabled = true // for iPhone, iPad default `true`
        dragLabel.isUserInteractionEnabled = true
        dragLabel.addInteraction(dragInteraction)
        dropLabel.pasteConfiguration = UIPasteConfiguration(forAccepting: NSString.self)
        dropLabel.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    
    @IBAction func createRandomTextButtonAction(_ sender: UIButton) {
        let wordArray = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.".split(separator: " ")
        var text = ""
        for _ in 0..<arc4random_uniform(50) {
            let randomIndex = Int(arc4random() + 1) % wordArray.count
            text += (wordArray[randomIndex] + " ")
        }
        dragLabel.text = text
    }

}


extension ViewController: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let text = dragLabel.text as NSString? else { return [] }
        let itemProvider = NSItemProvider(object: text)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
    
    /// Returns a custom drag preview view
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        guard let text = dragLabel.text as NSString? else { return nil }
        let rect = text.boundingRect(with: CGSize(width: dragLabel.frame.width, height: dragLabel.frame.height),
                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                     attributes: [NSAttributedStringKey.font: dragLabel.font],
                                     context: nil)
        
//        UIGraphicsBeginImageContext(rect.size)
//        defer { UIGraphicsEndImageContext() }
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        context.setFillColor(UIColor.random.cgColor)
//        context.fill(rect)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineBreakMode = NSLineBreakMode.byCharWrapping
//        paragraphStyle.alignment = dragLabel.textAlignment
//        text.draw(in: rect, withAttributes: [.font: dragLabel.font, .paragraphStyle: paragraphStyle])
//        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
//
//        let imageView = UIImageView(image: image)
//        let dragView = interaction.view!
//        let dragPoint = session.location(in: dragView)
//        let target = UIDragPreviewTarget(container: dragView, center: dragPoint)
//        return UITargetedDragPreview(view: imageView, parameters: UIDragPreviewParameters(), target: target)
        
        let previewLabel = UILabel(frame: rect)
        previewLabel.text = text as String
        previewLabel.textAlignment = dragLabel.textAlignment
        previewLabel.numberOfLines = 0
        previewLabel.backgroundColor = .random
        let dragView = interaction.view!
        let dragPoint = session.location(in: dragView)
        let target = UIDragPreviewTarget(container: dragView, center: dragPoint)
        return UITargetedDragPreview(view: previewLabel, parameters: UIDragPreviewParameters(), target: target)
    }
    
}
