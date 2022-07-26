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
    
    let myData: [MyPageSpeechBubbleItemType] = [
        IdentifiedMyPageSpeechBubbleCellItem(content: "메롱킹받지? kg", location: "서초구", updatedTime: 2, level: 2, imageURL: nil, tags: ["킹", "받", "지요?"], userName: "킹킹"),
        AnonymousMyPageSpeechBubbleCellItem(content: "익명으로 질문할게요. 개발 재밌나요?!!ㅋㅋ 더 보고싶으면 질문을 클릭해봐여~", location: "강남구", updatedTime: 1, tags: [], userName: "익명"),
        IdentifiedMyPageSpeechBubbleCellItem(content: "메롱킹받지? kg", location: "서초구", updatedTime: 2, level: 2, imageURL: nil, tags: ["킹", "받", "지요?"], userName: "킹킹"),
        AnonymousMyPageSpeechBubbleCellItem(content: "익명으로 질문할게요. 개발 재밌나요?!!ㅋㅋ 더 보고싶으면 질문을 클릭해봐여~", location: "강남구", updatedTime: 1, tags: [], userName: "익명"),
        IdentifiedMyPageSpeechBubbleCellItem(content: "메롱킹받지? kg", location: "서초구", updatedTime: 2, level: 2, imageURL: nil, tags: ["킹", "받", "지요?"], userName: "킹킹"),
        AnonymousMyPageSpeechBubbleCellItem(content: "익명으로 질문할게요. 개발 재밌나요?!!ㅋㅋ 더 보고싶으면 질문을 클릭해봐여~", location: "강남구", updatedTime: 1, tags: [], userName: "익명"),
        IdentifiedMyPageSpeechBubbleCellItem(content: "메롱킹받지? kg", location: "서초구", updatedTime: 2, level: 2, imageURL: nil, tags: ["킹", "받", "지요?"], userName: "킹킹"),
        AnonymousMyPageSpeechBubbleCellItem(content: "익명으로 질문할게요. 개발 재밌나요?!!ㅋㅋ 더 보고싶으면 질문을 클릭해봐여~", location: "강남구", updatedTime: 1, tags: [], userName: "익명")
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
        collectionView.register(MyPageSpeechBubbleCell.self)
        collectionView.register(HomeOtherSpeechBubbleCell.self)
    }
}

// MARK: - UICollectionViewDataSource

extension AnswerCompleteViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return myData.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: MyPageSpeechBubbleCell.self, for: indexPath)
        cell.configure(self.myData[indexPath.item])
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
        let item = self.myData[indexPath.item]
        return MyPageSpeechBubbleCell.fittingSize(width: collectionView.bounds.width, item: item)
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
