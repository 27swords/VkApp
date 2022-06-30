//
//  MyGroupTableViewController.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import UIKit

class MyGroupTableViewController: UITableViewController {
   
    //MARK: - Outlets
    @IBOutlet weak var myGroupSearchBar: UISearchBar!
    
    //MARK: - Init
    var SubscribedGroups = [GroupData]()
    let groupsService = GroupService()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        groupsService.loadGroups { [weak self] groups in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.SubscribedGroups = groups
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SubscribedGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupList", for: indexPath) as? MyGroupTableViewCell
        let group = SubscribedGroups[indexPath.row]
        
        cell?.myGroupLabel.text = group.name
        cell?.photosMyGroupImage.loadImage(with: group.photo100)
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        SubscribedGroups.swapAt(sourceIndexPath.item, destinationIndexPath.item)
    }
}
