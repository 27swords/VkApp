//
//  FriendsTableViewController.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import UIKit
import RealmSwift

//MARK: - Struct
struct SectionFriend {
    let character: Character
    var friend: [FriendsData]
}

class FriendsTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    
    private var friendService = FriendService()
    private var friendsData: [FriendsData] = [FriendsData]()
    private let realmService = RealmCacheService()
    private var friendResponse: Results<FriendsData>? {
        realmService.read(FriendsData.self)
    }
    private var token: NotificationToken?
    
    var sectionFriend: [SectionFriend] {
        var result = [SectionFriend]()

        for friend in friendsData {
            guard let character = friend.firstName.first else { continue }

            if let index = result.firstIndex(where: { $0.character == character } ) {
                result[index].friend.append(friend)

            } else {

                let sortedFriend = SectionFriend(character: character, friend: [friend])
                result.append(sortedFriend)
            }
        }
        return result
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createNotificationToken()
        friendService.loadFriends()
    }
    
    //MARK: - Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendResponse?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendResponse?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as? FriendsTableViewCell
        else {
            return UITableViewCell()
        }
        if let friends = friendResponse {
            cell.configureCellForFreind(friends[indexPath.row])
        }
        return cell
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            let photosVC = segue.destination as? FriendsCollectionViewController else { return }

        let friend = sectionFriend[indexPath.section]
        let friendSection = friend.friend[indexPath.row]

        photosVC.frinedsIndex = friendsData.firstIndex(where: { $0.firstName == friendSection.firstName }) ?? 0
        photosVC.photoOwnerID = friendSection.id
        photosVC.title = friendSection.firstName
    }
}

private extension FriendsTableViewController {
    func createNotificationToken() {
        token = friendResponse?.observe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .initial(let friendsData):
                print("DBG token", friendsData.count)
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


