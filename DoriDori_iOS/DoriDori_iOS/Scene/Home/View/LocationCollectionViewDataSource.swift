//
//  LocationCollectionViewDataSource.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/15.
//

import UIKit

final class LocationCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var labelList: [String] = ["구로구", "영등포구", "안녕하세요", "만나서반가워", "헬로", "바이", "만나서반가워", "헬로", "바이", "만나서반가워", "헬로", "바이"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        labelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeued = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath)
        
        guard let cell = dequeued as? LocationCollectionViewCell else {
            return dequeued
        }
        
        cell.locationLabel.text = labelList[indexPath.row]
        
        return cell
    }
}
