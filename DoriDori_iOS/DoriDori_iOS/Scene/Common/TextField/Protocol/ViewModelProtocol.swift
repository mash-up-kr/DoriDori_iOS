//
//  ViewModelProtocol.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/30.
//

import Foundation


protocol ViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
