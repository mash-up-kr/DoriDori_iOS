//
//  LocationCollectionViewDataSource.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/15.
//

import UIKit

final class LocationCollectionViewDataSource: NSObject, UICollectionViewDataSource {

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
}
