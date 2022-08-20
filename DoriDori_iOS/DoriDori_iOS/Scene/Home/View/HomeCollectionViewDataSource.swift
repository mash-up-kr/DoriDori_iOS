//
//  HomeCollectionViewDataSource.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/17.
//
import UIKit

final class HomeCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private var viewModel: HomeViewModel?
    private var numberOfItems: Int { viewModel?.locationListNumberOfModel ?? 0 }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeued = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMySpeechBubbleViewCell.identifier, for: indexPath)
        
        guard let cell = dequeued as? HomeMySpeechBubbleViewCell else {
            return dequeued
        }
        
        guard let item = viewModel?.currentState.homeSpeechModel?.homeSpeech[indexPath.row] else {
            return UICollectionViewCell()
        }

        cell.configure(item: item)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 270, height: 188)
    }
}
