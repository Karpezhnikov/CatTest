//
//  ViewController.swift
//  CatTest
//
//  Created by kam_team on 14.05.2020.
//  Copyright © 2020 kam_team. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    
    let catService = CatService()
    var arrayCatURLs = Array<String>()
    var arrayImage = Array<UIImage>(){
        didSet{
            self.collectionViewCats.reloadData()
        }
    }
    
    @IBOutlet weak var collectionViewCats: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.getCats()
        self.indicatorStatus(true)
    }
    
    func indicatorStatus(_ isActive: Bool){
        if isActive{
            self.indicator.startAnimating()
            self.indicator.isHidden = !isActive
        }else{
            self.indicator.stopAnimating()
            self.indicator.isHidden = !isActive
        }
        
    }
    
}

//MARK: Network
private extension ViewController{
    func getCats(){
        DispatchQueue.global(qos: .userInteractive).async {[weak self] in
            CatService.getRandomURLImages(limitImages: 15){ [weak self](success, arrayURLCat) in
                switch success{
                case true:
                    self!.arrayCatURLs += arrayURLCat!
                    self!.getImageCat()
                case false:
                    print("Error")
                }
            }
        }
    }
    
    func getImageCat(){
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let startIndex = (self!.arrayImage.count-1 < 0) ? 0:self!.arrayImage.count-1
            let stopIndex = self!.arrayCatURLs.count-1
            for urlCount in startIndex...stopIndex{
                CatService.getUIImageCat(self!.arrayCatURLs[urlCount]) { [weak self](success, imageCat) in
                    if success{
                        self!.arrayImage.append(imageCat!)
                    }
                }
            }
            DispatchQueue.main.async {
                self!.indicatorStatus(false)
            }
        }
    }
}

//MARK: Collection View
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func setupCollectionView(){
        let layoutCVC = ZoomAndSnapFlowLayout()
        let minimumLineSpacing = collectionViewCats.frame.width * 0.07
        let sizeItem = CGSize(width: collectionViewCats.frame.width * 0.6, height: collectionViewCats.frame.height * 0.5)
        let activeDistance = collectionViewCats.frame.width * 0.4
        layoutCVC.setupFlowLayout(minimumLineSpacing: minimumLineSpacing, sizeItem: sizeItem, scrollDirection: .horizontal, activeDistance: activeDistance, zoomFactor: nil)
        self.collectionViewCats.collectionViewLayout = layoutCVC
        self.collectionViewCats.showsVerticalScrollIndicator = false
        self.collectionViewCats.showsHorizontalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == arrayCatURLs.count-1{
            getCats()
        }
        if let cell = collectionViewCats.dequeueReusableCell(withReuseIdentifier: "CatCell", for: indexPath) as? CatCVC{
            cell.imageCat.image = arrayImage[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
}
