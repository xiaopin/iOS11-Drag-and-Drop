//
//  CollectionViewController.swift
//  demo
//
//  Created by nhope on 2017/9/27.
//  Copyright © 2017年 nhope. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    private var colors: [UIColor] = Array(repeating: 0, count: 30).map({_ in UIColor.random})
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sorting by drag and drop"
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Configure drag and drop
        collectionView!.dragInteractionEnabled = true
        collectionView!.dragDelegate = self
        collectionView!.dropDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }

    // MARK: - UICollectionViewDelegate

}


extension CollectionViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let color = colors[indexPath.item]
        let itemProvider = NSItemProvider(object: color)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
}


extension CollectionViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath,
            let sourceIndexPath = coordinator.items.first?.sourceIndexPath else { return }
        
        coordinator.session.loadObjects(ofClass: UIColor.self) { (colors) in
            collectionView.performBatchUpdates({
                guard let color = colors.first as? UIColor else { return }
                self.colors.remove(at: sourceIndexPath.item)
                self.colors.insert(color, at: destinationIndexPath.item)
                collectionView.reloadSections(IndexSet(integer: 0))
            })
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        // Only receive color data
        return session.canLoadObjects(ofClass: UIColor.self)
    }
    
}
