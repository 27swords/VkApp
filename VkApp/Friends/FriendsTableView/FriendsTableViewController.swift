//
//  FriendsTableViewController.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation

import UIKit

//MARK: - Struct
struct SectionFriend {
    let character: Character
    var friend: [FriendsData]
}

class FriendsTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    
    private var friendsCount: ResponseFriends?
    
    let friendService = FriendService()
    var friendsData = [FriendsData]()
    
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
        
        friendService.loadFriends { result in
            switch result {
            case .success(let friend):
                DispatchQueue.main.async {
                    self.friendsData = friend
                    self.tableView.reloadData()
                }
                
            case .failure(_):
                return
            }
        }
    }
    
    //MARK: - Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionFriend.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friends = sectionFriend[section]
        return friends.friend.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as? FriendsTableViewCell
        let sectionFriend = sectionFriend[indexPath.section]
        let friend = sectionFriend.friend[indexPath.row]
        
        cell?.nameFriendsLabel.text = friend.firstName + " " + friend.lastName
        cell?.friendsImage.loadImage(with: friend.photo100)
        
        return cell ?? UITableViewCell()
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
