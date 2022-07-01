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
    private var friendService = FriendService()
    private var friendsData: [FriendsData] = [FriendsData]()
    
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
        
        friendService.loadFriends { [weak self] friends in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.friendsData = friends
                self.tableView.reloadData()
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
        
        guard let path = URL(string: friend.photo100),
              let imageData = try? Data(contentsOf: path, options: .uncached),
              let userAvatar = UIImage(data: imageData)
                
        else {
            
            return UITableViewCell()
        }
        
        cell?.friendsImage.image = userAvatar
        cell?.nameFriendsLabel.text = "\(friend.firstName) \(friend.lastName)"
        
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
