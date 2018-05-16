/*
 * Rainbow SDK sample
 *
 * Copyright (c) 2018, ALE International
 * All rights reserved.
 *
 * ALE International Proprietary Information
 *
 * Contains proprietary/trade secret information which is the property of
 * ALE International and must not be made available to, or copied or used by
 * anyone outside ALE International without its written authorization
 *
 * Not to be disclosed or used except in accordance with applicable agreements.
 */

import UIKit
import Rainbow

class ConversationsTableViewController: UITableViewController {
    let serviceManager : ServicesManager
    let conversationsManager : ConversationsManagerService
    var selectedIndex : IndexPath? = nil

    
    required init?(coder aDecoder: NSCoder) {
        serviceManager = ServicesManager.sharedInstance()
         conversationsManager = serviceManager.conversationsManagerService
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = conversationsManager.conversations.count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationsTableViewCell", for: indexPath)
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let conversationsCell = cell as? ConversationsTableViewCell {
            if let lastMessage = conversationsManager.conversations[indexPath.row].lastMessage {
                conversationsCell.lastMessage.text = lastMessage.body
            } else {
                conversationsCell.lastMessage.text = ""
            }
            if let photoData = (conversationsManager.conversations[indexPath.row].peer as? Contact)?.photoData {
                conversationsCell.avatar.image = UIImage(data: photoData)
            } else {
                conversationsCell.avatar.image = UIImage(named: "Default_Avatar")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ChatWithSegue", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatWithSegue" {
            if let selectedIndex = selectedIndex {
                if let vc = segue.destination as? ChatViewController {
                    if let contact = conversationsManager.conversations[selectedIndex.row].peer as? Contact {
                        vc.contact = contact
                    }
                    //vc.contactImage = ((ContactTableViewCell *)[self.tableView cellForRowAtIndexPath:self.selectedIndex]).avatar.image
                    //vc.contactImageTint = ((ContactTableViewCell *)[self.tableView cellForRowAtIndexPath:self.selectedIndex]).avatar.tintColor
                }
            }
        }
    }
    
    
    
}
