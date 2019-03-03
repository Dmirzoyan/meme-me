//
//  SharedImagesGridDataSource.swift
//  MemeMe
//
//  Created by Davit Mirzoyan on 3/3/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

protocol SharedImagesGridDataProviding {
    func set(_ images: [Meme])
    func image(for indexPath: IndexPath) -> Meme?
}

final class SharedImagesGridDataSource: NSObject, UICollectionViewDataSource {
    
    private var sharedImages: [Meme]?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sharedImages?.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SharedImagesGridCell", for: indexPath
        ) as! SharedImagesGridCell
        
        cell.sharedImageView.image = sharedImages?[indexPath.row].originalImage
        
        return cell
    }
}

extension SharedImagesGridDataSource: SharedImagesGridDataProviding {
 
    func set(_ images: [Meme]) {
        sharedImages = images
    }
    
    func image(for indexPath: IndexPath) -> Meme? {
        return sharedImages?[indexPath.row]
    }
}
