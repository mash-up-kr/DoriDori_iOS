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
    private let navigationController: UINavigationController
    
    init(viewModel: HomeViewModel, naviagationController: UINavigationController) {
        self.viewModel = viewModel
        self.navigationController = naviagationController
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel?.currentState.homeSpeechModel?.homeSpeech[safe: indexPath.row]?.user.id == UserDefaults.userID {
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
    func likeButtonDidTap(id: String, userLiked: Bool) {
        if userLiked {
            viewModel?.action.onNext(.dislike(id: id))
        } else {
            viewModel?.action.onNext(.like(id: id))
        }
    }
    
    func commentButtonDidTap(postId: String, isMyPost: Bool) {
        WebViewCoordinator(navigationController: navigationController, type: .postDetail(id: postId, isMyPost: isMyPost), navigateStyle: .push)
            .start()
    }
    
    func shareButtonDidTap() {
        print("공유 버튼 눌림")
    }
}
