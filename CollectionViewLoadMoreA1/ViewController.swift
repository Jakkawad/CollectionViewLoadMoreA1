//
//  ViewController.swift
//  CollectionViewLoadMoreA1
//
//  Created by admin on 4/18/2559 BE.
//  Copyright © 2559 All2Sale. All rights reserved.
//

import UIKit
import Alamofire
import MapleBacon

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    private var numberOfItemPerSection = 16
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataJSON = NSArray()
    
    func loadJSON() {
        Alamofire.request(.POST,"https://www.all2sale.com/sendmail/testfunction/json/apitest.php",parameters: ["api":"productall","productall":numberOfItemPerSection]).responseJSON { response in
            //print(response.result)
            self.dataJSON = response.result.value as! NSArray
            //print(self.dataJSON.description)
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
        let imageUrl = item.objectForKey("ProductShowImage") as? String
        var wwwUrl = "https://www.all2sale.com/store/"
        wwwUrl += imageUrl!
        let imageUrl2 = NSURL(string: wwwUrl)!
        col0?.imageViewProduct.setImageWithURL(imageUrl2)
        return col0!
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        //print("offsetY\(offsetY)")
        let contentHeight = scrollView.contentSize.height
        //print("contentHeight\(contentHeight)")
        //if offsetY > contentHeight - scrollView.frame.size.height {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            numberOfItemPerSection += 9
            self.collectionView.reloadData()
            print("numberOfItemPerSection\(numberOfItemPerSection)")
            loadJSON()
            if numberOfItemPerSection > 35 {
                print("5555")
                activityIndicator.startAnimating()
                let delay = 1 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                }
            } else {
                print("DDD")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        loadJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

