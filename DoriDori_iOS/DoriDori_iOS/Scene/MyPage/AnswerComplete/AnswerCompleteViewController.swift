//
//  AnswerCompleteViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/10.
//

import UIKit

final class AnswerCompleteViewController: UIViewController {
    
    // MARK: UIComponent
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    let datas: [HomeOtherSpeechBubbleCellItem] = [
        HomeOtherSpeechBubbleCellItem(level: 2, location: "강남구", updatedTime: 1, profileImageURL: "", content: "저랑 같이 강남역 CGV에서 #도리 를 찾아서 보러가실 분!!긴글긴글긴글긴글긴글긴글", userNmae: "방위대", likeCount: 2220, commentCount: 0, tags: []),
        HomeOtherSpeechBubbleCellItem(level: 3, location: "강남구", updatedTime: 1, profileImageURL: "", content: "저랑 같이 강남역 CGV에서 #도🤔!", userNmae: "서영테스트입니당", likeCount: 0, commentCount: 0, tags: ["연애", "독서"]),
        HomeOtherSpeechBubbleCellItem(level: 10, location: "강남구", updatedTime: 1, profileImageURL: "", content: "#도리 를 찾아서가 뭐에요?", userNmae: "매쉬업 방위대", likeCount: 0, commentCount: 10, tags: ["연애", "독서", "맛집탐방"]),
        HomeOtherSpeechBubbleCellItem(level: 2, location: "강남구", updatedTime: 1, profileImageURL: "", content: "저랑 같이 강남역 CGV에서 #도리 를 찾아서 보러가실 분!!", userNmae: "방위대", likeCount: 2220, commentCount: 0, tags: ["연애"]),
        HomeOtherSpeechBubbleCellItem(level: 2, location: "강남구", updatedTime: 1, profileImageURL: "", content: "저랑 같이 강남역 CGV에서 #도리 를 찾아서 보러가실 분!!", userNmae: "방위대", likeCount: 2220, commentCount: 0, tags: []),
        HomeOtherSpeechBubbleCellItem(level: 3, location: "강남구", updatedTime: 1, profileImageURL: "", content: "저랑 같이 강남역 CGV에서 #도🤔!", userNmae: "서영테스트입니당", likeCount: 0, commentCount: 0, tags: ["연애", "독서"]),
        HomeOtherSpeechBubbleCellItem(level: 10, location: "강남구", updatedTime: 1, profileImageURL: "", content: "#도리 를 찾아서가 뭐에요?", userNmae: "매쉬업 방위대", likeCount: 0, commentCount: 10, tags: ["연애", "독서", "맛집탐방"]),
        HomeOtherSpeechBubbleCellItem(level: 2, location: "강남구", updatedTime: 1, profileImageURL: "", content: "저랑 같이 강남역 CGV에서 #도리 를 찾아서 보러가실 분!!", userNmae: "방위대", likeCount: 2220, commentCount: 0, tags: ["연애"]),
    ]
    
    // MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.configure(self.collectionView)
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        self.collectionView.reloadData()
        self.collectionView.backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    private func configure(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        self.register(collectionView)
    }
    
    private func register(_ collectionView: UICollectionView) {
        collectionView.register(AnonymousSpeechBubbleCell.self)
        collectionView.register(HomeOtherSpeechBubbleCell.self)
    }
}

// MARK: - UICollectionViewDataSource

extension AnswerCompleteViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return datas.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: HomeOtherSpeechBubbleCell.self, for: indexPath)
        cell.configure(self.datas[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AnswerCompleteViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let item = self.datas[indexPath.item]
        print(HomeOtherSpeechBubbleCell.fittingSize(width: collectionView.bounds.width, item: item))
        return HomeOtherSpeechBubbleCell.fittingSize(width: collectionView.bounds.width, item: item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AnswerCompleteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        12
    }
}
