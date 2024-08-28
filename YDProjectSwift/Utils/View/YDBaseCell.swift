//
//  YDBaseCell.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/10.
//

import Foundation

//let gCellShadowColor = UIColor(hex:"#F3F3F3").cgColor

class YDBaseCell: UITableViewCell {

    weak var cellTableView: UITableView?
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setUpCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell(){
        
    }
    
    func fillCellData<T>(data: T) {
        
    }
    
    func fillCellData<T>(data: T, tableView: UITableView? = nil, indexPath: IndexPath? = nil) {
        self.cellTableView = tableView
        self.indexPath = indexPath
    }
    
    class func AICellHeight() -> CGFloat {
        return 44.0
    }
}
