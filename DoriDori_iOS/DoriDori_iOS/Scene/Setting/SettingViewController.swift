//
//  SettingViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/12.
//

import UIKit
import ReactorKit
import RxSwift
import RxRelay
import RxCocoa

final class SettingViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "page_delete"), for: .normal)
        return button
    }()
    
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.font = UIFont.setKRFont(weight: .medium, size: 18)
        label.textColor = .white
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let settingItems: BehaviorRelay<[SettingSectionModel]>
    var reactor: SettingReactor?
    var disposeBag: DisposeBag
    init(
        settingReactor: SettingReactor
    ) {
        self.reactor = settingReactor
        self.disposeBag = .init()
        self.settingItems = .init(value: [])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayouts()
        self.configure(self.collectionView)
    }
    
    func bind(reactor: SettingReactor) {
        
    }
    
    private func configure(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCollectionViewCell.self)
        collectionView.register(SettingCollectionViewHeaderView.self,
                                supplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    }
    
    private func setupLayouts() {
        self.view.addSubViews(self.closeButton, self.navigationTitleLabel, self.collectionView)
        self.closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(58)
            $0.size.equalTo(24)
        }
        self.navigationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.closeButton.snp.top)
            $0.centerX.equalToSuperview()
        }
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(self.navigationTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}


extension SettingViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.settingItems.value.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.settingItems.value[safe: section]?.settingItems.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: SettingCollectionViewCell.self, for: indexPath)
        if let item = self.settingItems.value[safe: indexPath.section]?.settingItems[safe: indexPath.item] {
            cell.configure(title: item.title)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(kind: kind, type: SettingCollectionViewHeaderView.self, for: indexPath)
            let headerTitle = self.settingItems.value[safe: indexPath.section]?.title
            headerView.configure(title: headerTitle ?? "")
            return headerView
        } else {
            fatalError("footer view가 없습니다.")
        }
    }
}

extension SettingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 39)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 76)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
}

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    
}
