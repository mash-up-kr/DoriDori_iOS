//
//  HomeCollectionViewImplement.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/17.
//
import UIKit

final class HomeCollectionViewImplement: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    enum HomeCellType {
        case my
        case other
    }
    
    private var viewModel: HomeViewModel?
    private var numberOfItems: Int { viewModel?.homeListNumberOfModel ?? 0 }
    
    private var homeCellType: HomeCellType?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // TODO: - 회원가입 후 저장된 내 userid와 비교
        if viewModel?.currentState.homeSpeechModel?.homeSpeech[safe: indexPath.row]?.user.id == "" {
            homeCellType = .my
        } else {
            homeCellType = .other
        }
        
        guard let item = viewModel?.currentState.homeSpeechModel?.homeSpeech[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        switch homeCellType {
        case .my:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMySpeechBubbleViewCell.identifier, for: indexPath) as? HomeMySpeechBubbleViewCell else { return UICollectionViewCell() }
            cell.speechBubble.delegate = self
            cell.configure(item: item)
            return cell
        case .other:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeOtherSpeechBubbleCell.identifier, for: indexPath) as? HomeOtherSpeechBubbleCell else { return UICollectionViewCell() }
            cell.speechBubble.delegate = self
            cell.configure(item)
            return cell
        case .none:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = HomeMySpeechBubbleViewCell.fittingSize(width: collectionView.frame.width, item: (viewModel?.currentState.homeSpeechModel?.homeSpeech[safe: indexPath.row])!)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = viewModel?.currentState.homeSpeechModel?.homeSpeech[safe: indexPath.row] else {
            return
        }
    }
}

extension HomeCollectionViewImplement: HomeSpeechBubleViewDelegate {
    func likeButtonDidTap(id: String) {
        viewModel?.action.onNext(.dislike(id: id))
    }
    
    func commentButtonDidTap() {
        print("댓글 버튼 눌림")
    }
    
    func shareButtonDidTap() {
        print("공유 버튼 눌림")
    }
}
