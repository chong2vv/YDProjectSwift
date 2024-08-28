//
//  OtherViewController.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/8.
//

import Foundation

class OtherViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .white
        let subView = UIView()
        view.addSubview(subView)
        subView.backgroundColor = .red
        subView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
    }
}
