//
//  ViewController.swift
//  CollectionViewLoadMoreA1
//
//  Created by admin on 4/18/2559 BE.
//  Copyright © 2559 All2Sale. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    private var numberOfItemPerSection = 16
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataJSON = NSArray()
    
    func loadJSON() {
        Alamofire.request(.POST,"https://www.all2sale.com/sendmail/testfunction/json/apitest.php",parameters: ["api":"productall","productall":numberOfItemPerSection]).responseJSON { response in
            //print(response.result)
            self.dataJSON = response.result.value as! NSArray
            print(self.dataJSON.description)
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return numberOfItemPerSection
        return self.dataJSON.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let col0 = collectionView.dequeueReusableCellWithReuseIdentifier("collectCell0", forIndexPath: indexPath) as? Col0CollectionViewCell
        let item = self.dataJSON[indexPath.row] as! NSDictionary
        col0?.lblName.text = item.objectForKey("Id") as? String
        return col0!
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            numberOfItemPerSection += 6
            self.collectionView.reloadData()
            print(numberOfItemPerSection)
            loadJSON()
            print()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

