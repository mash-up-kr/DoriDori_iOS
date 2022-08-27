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
    
    let myData: [MyPageOtherSpeechBubbleItemType] = [
        IdentifiedMyPageSpeechBubbleCellItem(content: "메롱킹받지? kg", location: "서초구", updatedTime: 2, level: 2, imageURL: nil, tags: ["킹", "받", "지요?"], userName: "킹킹"),
        AnonymousMyPageSpeechBubbleCellItem(content: "익명으로 질문할게요. 개발 재밌나요?!!ㅋㅋ 더 보고싶으면 질문을 클릭해봐여~", location: "강남구", updatedTime: 1, tags: [], userName: "익명"),
        IdentifiedMyPageSpeechBubbleCellItem(content: "메롱킹받지? kg", location: "서초구", updatedTime: 2, level: 2, imageURL: nil, tags: ["킹", "받", "지요?"], userName: "킹킹"),
        AnonymousMyPageSpeechBubbleCellItem(content: "익명으로 질문할게요. 개발 재밌나요?!!ㅋㅋ 더 보고싶으면 질문을 클릭해봐여~", location: "강남구", updatedTime: 1, tags: [], userName: "익명"),
        IdentifiedMyPageSpeechBubbleCellItem(content: "메롱킹받지? kg", location: "서초구", updatedTime: 2, level: 2, imageURL: nil, tags: ["킹", "받", "지요?"], userName: "킹킹"),
        AnonymousMyPageSpeechBubbleCellItem(content: "익명으로 질문할게요. 개발 재밌나요?!!ㅋㅋ 더 보고싶으면 질문을 클릭해봐여~", location: "강남구", updatedTime: 1, tags: [], userName: "익명"),
        IdentifiedMyPageSpeechBubbleCellItem(content: "메롱킹받지? kg", location: "서초구", updatedTime: 2, level: 2, imageURL: nil, tags: ["킹", "받", "지요?"], userName: "킹킹"),
        AnonymousMyPageSpeechBubbleCellItem(content: "익명으로 질문할게요. 개발 재밌나요?!!ㅋㅋ 더 보고싶으면 질문을 클릭해봐여~", location: "강남구", updatedTime: 1, tags: [], userName: "익명")
    ]
    
//    let myItem = MyPageMySpeechBubbleCellItem(questioner: "감자도리도리", userName: "매쉬업 방위대~알까요잉메롱ㅋ", content: "ㅋㅋㅋㅋ니모를 찾아서예용,ㅋㅋㅋㅋ니모를 찾아서예용xxxxxx", location: "강남", updatedTime: 1, likeCount: 0, profileImageURL: nil, level: 5)

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
