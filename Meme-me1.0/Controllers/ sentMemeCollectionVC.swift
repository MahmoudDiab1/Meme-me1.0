//
//  sentCollectionViewController.swift
//  Meme-me1.0
//
//  Created by mahmoud diab on 6/11/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import UIKit

class  sentMemeCollectionVC: UICollectionViewController {
    //    MARK:- outlets
    @IBOutlet var collectionViewOutlet: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //    MARK:- variables
    var memes:[Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    let kCollectionViewCellID = "sentCollectionViewCell"
    
    //    MARK:- lifeCycle
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        collectionViewOutlet.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: height)
        
    }
    
    @IBAction func addMemePressed(_ sender: Any) {
        let editMemeVC = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        editMemeVC.modalPresentationStyle = .fullScreen
        
        present(editMemeVC, animated: true , completion: nil)
    }
    
    
    
    // MARK:- UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  kCollectionViewCellID  , for: indexPath) as! memeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.configureCell(with: meme)
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[indexPath.item]
        let detailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewControllerID") as! MemeDetailViewController
        
        detailController.meme = meme 
        if let navigationController = navigationController {
            navigationController.pushViewController(detailController, animated: true)
        }
    }
    
}
