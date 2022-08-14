//
//  DoriDoriSettingItem.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/12.
//

import Foundation

struct SettingSectionModel: Equatable {
    let title: String
    let settingItems: [SettingItem]
}

enum SettingItem: CaseIterable {
    case myLevel
    case modifyProfile
    case alarmLocationSetting
    case `notice`
    case questionToAdmin
    case termsOfService
    case openSource
    case versionInfo
    case logout
    case withdraw
    
    var title: String {
        switch self {
        case .myLevel: return "마이 레벨"
        case .modifyProfile: return "내 프로필 수정"
        case .alarmLocationSetting: return "알림 및 위치정보 설정"
        case .notice: return "공지사항"
        case .questionToAdmin: return "관리자에게 질문하기"
        case .termsOfService: return "약관"
        case .openSource: return "오픈소스"
        case .versionInfo: return "버전정보"
        case .logout: return "로그아웃"
        case .withdraw: return "탈퇴하기"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .versionInfo:
            guard let dictionary = Bundle.main.infoDictionary,
                  let version = dictionary["CFBundleShortVersionString"] as? String else { return nil }
            return "V\(version)"
        default: return nil
        }
    }
}
