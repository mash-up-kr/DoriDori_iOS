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
    
    private let coordinator: SettingCoordinatable
    private let settingItems: BehaviorRelay<[SettingSectionModel]>
    private let viewDidLoadStream: PublishRelay<Void>
    var reactor: SettingReactor
    var disposeBag: DisposeBag
    init(
        settingReactor: SettingReactor,
        coordinator: SettingCoordinatable
    ) {
        self.viewDidLoadStream = .init()
        self.coordinator = coordinator
        self.reactor = settingReactor
        self.disposeBag = .init()
        self.settingItems = .init(value: [])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit { debugPrint("\(self) deinit") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        self.setupLayouts()
        self.configure(self.collectionView)
        
        self.bind()
        self.bind(reactor: self.reactor)
        
        self.viewDidLoadStream.accept(())
    }
    
    func bind(reactor: SettingReactor) {
        self.viewDidLoadStream
            .map { SettingReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map(\.$settingSections)
            .map { $0.value }
            .bind(to: self.settingItems)
            .disposed(by: self.disposeBag)
    }
    
    private func configure(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .darkGray
        collectionView.register(SettingCollectionViewCell.self)
        collectionView.register(SettingCollectionViewHeaderView.self,
                                supplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    }
    
    private func setupLayouts() {
        self.view.addSubViews(self.closeButton, self.navigationTitleLabel, self.collectionView)
        self.closeButton.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(14)
            $0.size.equalTo(24)
            $0.leading.equalToSuperview().offset(28)
        }
        self.navigationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.closeButton.snp.top)
            $0.centerX.equalToSuperview()
        }
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(self.navigationTitleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        self.closeButton.rx.throttleTap
            .bind(with: self) { owner, _ in
                owner.coordinator.dismiss(nil)
            }
            .disposed(by: self.disposeBag)
        
        self.settingItems
            .bind(with: self) { owner, sections in
                owner.collectionView.reloadData()
            }
            .disposed(by: self.disposeBag)
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
            cell.configure(title: item.title, subTitle: item.subtitle)
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
        CGSize(width: collectionView.bounds.width, height: 52)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 64)
    }
}

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    
}
