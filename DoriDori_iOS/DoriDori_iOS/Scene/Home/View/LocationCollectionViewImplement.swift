//
//  LocationCollectionViewImplement.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/15.
//

import UIKit

final class LocationCollectionViewImplement: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    private var viewModel: HomeViewModel?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    private var numberOfItems: Int { viewModel?.locationListNumberOfModel ?? 0 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeued = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath)
        
        guard let cell = dequeued as? LocationCollectionViewCell else {
            return dequeued
        }
        
        cell.locationLabel.text = viewModel?.currentState.lactaionListModel[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath) as? LocationCollectionViewCell else {
            return .zero
        }

        cell.locationLabel.sizeToFit()
        let cellWidth = cell.locationLabel.frame.width + 20
        
        // TODO: - Size 수정 예정
        return CGSize(width: cellWidth, height: 34)
    }
}
