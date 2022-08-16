//
//  AnswerCompleteViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/10.
//

import UIKit

final class AnswerCompleteViewController: UIViewController {
    
    // MARK: - UI Component
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    let datas: [IdentifiedHomeSpeechBubbleCellItemType] = [
        IdentifiedHomeSpeechBubbleCellItem(level: 2, location: "강남구", updatedTime: 12, profileImageURL: nil, content: "홈질문입니다.홈질문", userName: "쿠쿠루삥뽕", likeCount:312, commentCount: 12, tags: ["메롱", "ㅋㅋ", "담엔술먹자"]),
        IdentifiedHomeSpeechBubbleCellItem(level: 2, location: "강남구", updatedTime: 12, profileImageURL: nil, content: "홈질문입니다.홈질문", userName: "쿠쿠루삥뽕", likeCount: 12312, commentCount: 12, tags: ["메롱", "ㅋㅋ", "담엔술먹자"]),
        IdentifiedHomeSpeechBubbleCellItem(level: 2, location: "강남구", updatedTime: 12, profileImageURL: nil, content: "홈질문입니다.홈질문", userName: "쿠쿠루삥뽕", likeCount: 12312, commentCount: 12, tags: ["메롱", "ㅋㅋ", "담엔술먹자"]),
        IdentifiedHomeSpeechBubbleCellItem(level: 2, location: "강남구", updatedTime: 12, profileImageURL: nil, content: "홈질문입니다.홈질문", userName: "쿠쿠루삥뽕", likeCount: 12312, commentCount: 12, tags: ["메롱", "ㅋㅋ", "담엔술먹자"])
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
        collectionView.register(MyPageOtherSpeechBubbleCell.self)
        collectionView.register(HomeOtherSpeechBubbleCell.self)
        collectionView.register(MyPageMySpeechBubbleCell.self)
        collectionView.register(HomeMySpeechBubbleViewCell.self)
    }
}

// MARK: - UICollectionViewDataSource

extension AnswerCompleteViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: MyPageMySpeechBubbleCell.self, for: indexPath)
//        cell.configure(self.myItem)
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
//        let item = self.datas[indexPath.item]
//        return HomeOtherSpeechBubbleCell.fittingSize(width: collectionView.bounds.width, item: item)
//        let size = MyPageMySpeechBubbleCell.fittingSize(width: collectionView.bounds.width, item: self.myItem)
//        print(size)
//        return size
        return .zero
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
