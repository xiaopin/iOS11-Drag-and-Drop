//
//  MultipleCollectionViewController.swift
//  demo
//
//  Created by nhope on 2017/9/27.
//  Copyright © 2017年 nhope. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


class MultipleCollectionViewController: UIViewController {
    
    @IBOutlet weak var dragCollectionView: UICollectionView!
    @IBOutlet weak var dropCollectionView: UICollectionView!
    private var dragColors: [UIColor] = Array(repeating: 0, count: 30).map { _ in UIColor.random}
    private var dropColors: [UIColor] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Multi-Touch"
        dragCollectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        dropCollectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Configure drag and drop
        dragCollectionView!.dragInteractionEnabled = true
        dragCollectionView!.dragDelegate = self
        dropCollectionView!.dropDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MultipleCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dragCollectionView {
            return dragColors.count
        }
        if collectionView == dropCollectionView {
            return dropColors.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if collectionView == dragCollectionView {
            cell.backgroundColor = dragColors[indexPath.item]
        } else if collectionView == dropCollectionView {
            cell.backgroundColor = dropColors[indexPath.item]
        }
        return cell
    }
    
}


extension MultipleCollectionViewController: UICollectionViewDelegate {
    
}


extension MultipleCollectionViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let color = dragColors[indexPath.item]
        let itemProvider = NSItemProvider(object: color)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let color = dragColors[indexPath.item]
        let itemProvider = NSItemProvider(object: color)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
}


extension MultipleCollectionViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        coordinator.session.loadObjects(ofClass: UIColor.self) { (colors) in
            guard let colorsArray = colors as? [UIColor] else { return }
            collectionView.performBatchUpdates({
                self.dropColors.insert(contentsOf: colorsArray, at: destinationIndexPath.item)
                collectionView.reloadSections(IndexSet(integer: 0))
            }, completion: nil)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        // Only receive color data
        return session.canLoadObjects(ofClass: UIColor.self)
    }
    
}

 
