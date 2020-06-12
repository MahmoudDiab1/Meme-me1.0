//
//  sentMemeTableView.swift
//  Meme-me1.0
//
//  Created by mahmoud diab on 6/11/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

class sentMemeTableVC:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    outlet
    
    @IBOutlet weak var sentMemesTableView: UITableView!
    
//    variables
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
//    lifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sentMemesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentMemesTableView.dataSource = self
        sentMemesTableView.delegate = self
        sentMemesTableView.allowsSelection = true
    }
    
    @IBAction func addMemePressed(_ sender: Any) {
        let editMemeVC = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        editMemeVC.modalPresentationStyle = .fullScreen
        present(editMemeVC, animated: true , completion: nil)
    }
    
    
    //    tableView datasource and delegate functions.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableViewCell", for: indexPath) as! memeTableViewCell
        let meme = memes[indexPath.row]
        cell.configureCell(with: meme )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let memeSent = memes[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewControllerID") as! MemeDetailViewController
        detailVC.meme = memeSent
        if (navigationController != nil) {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/4
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
         let style = UITableViewCell.EditingStyle.none
               return style
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "DELETE") { (action, view, handler) in
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
           
            tableView.deleteRows(at:[indexPath], with: .automatic)
            
        }
         tableView.reloadData()
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
}
