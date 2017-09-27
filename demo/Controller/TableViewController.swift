//
//  TableViewController.swift
//  demo
//
//  Created by nhope on 2017/9/26.
//  Copyright © 2017年 nhope. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var datas: [(String, UIImage)] = {
        var datas = [(String, UIImage)]()
        let size = CGSize(width: 30.0, height: 30.0)
        for i in 0..<30 {
            guard let image = UIImage.fromColor(.random, imageSize: size) else { continue }
            let tupe = (String(i), image)
            datas.append(tupe)
        }
        return datas
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sorting by drag and drop"
        // Configure drag and drop
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let tuple = datas[indexPath.row]
        cell.userInteractionEnabledWhileDragging = true
        cell.textLabel?.text = tuple.0
        cell.imageView?.image = tuple.1
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("didSelectRowAt: \(indexPath)")
    }

}


extension TableViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let image = datas[indexPath.row].1
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
    
}


extension TableViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath,
            let dropItem = coordinator.items.first,
            let sourceIndexPath = dropItem.sourceIndexPath else { return }

        coordinator.session.loadObjects(ofClass: UIImage.self) { (images) in
            guard let image = images.first as? UIImage else { return }
            tableView.performBatchUpdates({
                let tuple = (self.datas[sourceIndexPath.row].0, image)
                self.datas.remove(at: sourceIndexPath.row)
                self.datas.insert(tuple, at: destinationIndexPath.row)
                tableView.reloadData()
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
}
