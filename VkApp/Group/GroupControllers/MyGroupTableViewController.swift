//
//  MyGroupTableViewController.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import UIKit
import RealmSwift

class MyGroupTableViewController: UITableViewController {
   
    //MARK: - Outlets
    @IBOutlet weak var myGroupSearchBar: UISearchBar!
    
    //MARK: - Init
    //var groupData: [GroupData] = []
    let groupsService = GroupService()
    private let realmService = RealmCacheService()
    private var groupResponse: Results<GroupData>? {
        realmService.read(GroupData.self)
    }
    private var token: NotificationToken?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createNotificationToken()
        groupsService.loadGroups()
    }
    
    //MARK: - Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupResponse?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupList", for: indexPath) as? MyGroupTableViewCell
        else {
            return UITableViewCell()
        }
        if let groups = groupResponse {
            cell.configureCellForGroup(groups[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

private extension MyGroupTableViewController {
    func createNotificationToken() {
        token = groupResponse?.observe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .initial(let groupsData):
                print("DBG token", groupsData.count)
            case .update(_,
                         deletions: let deletions,
                         insertions: let insertions,
                         modifications: let modifications):
                let deletionsIndexPath = deletions.map { IndexPath(row: $0, section: 0) }
                let insertionsIndexPath = insertions.map { IndexPath(row: $0, section: 0) }
                let modificationsIndexPath = modifications.map { IndexPath(row: $0, section: 0) }
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: deletionsIndexPath, with: .automatic)
                    self.tableView.insertRows(at: insertionsIndexPath, with: .automatic)
                    self.tableView.reloadRows(at: modificationsIndexPath, with: .automatic)
                    self.tableView.endUpdates()
                }
            case .error(let error):
                print("DBG token Error", error)
            }
        }
    }
}
