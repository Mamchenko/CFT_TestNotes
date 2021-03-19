//
//  NotesCollectionViewCell.swift
//  CFT_test_zametki
//
//  Created by Anatoliy Mamchenko on 17.03.2021.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    var imageViewer : UIImageView =  {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sizeToFit()
        return view
    }()
    
    var titleLabel: UILabel =  {
        let view: UILabel = UILabel()
        view.backgroundColor = .systemPurple
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineBreakMode = .byWordWrapping
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: view.font.pointSize, weight: .heavy)
        view.textAlignment = .center
        return view
    }()
    
    var noteLabel: UILabel =  {
        let view: UILabel = UILabel()
        view.backgroundColor = .clear
        
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.lineBreakMode = .byWordWrapping
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemPurple.cgColor
        view.textAlignment = .left
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: view.font.pointSize, weight: .semibold)

        return view
    }()
    
    
    
    func configConstraintsForNoteWithImage () {
        
        [imageViewer, titleLabel, noteLabel ].forEach {addSubview($0)}
        
        imageViewer.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(16)
            make.leading.equalTo(self.snp.leading).offset(64)
            make.trailing.equalTo(self.snp.trailing).offset(-64)
            make.height.equalTo(self).multipliedBy(0.5)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageViewer.snp.bottom).offset(8)
            make.leading.equalTo(self.snp.leading).offset(128)
            make.trailing.equalTo(self.snp.trailing).offset(-128)
            make.height.equalTo(self).multipliedBy(0.1)
        }
        
        noteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.height.equalTo(self).multipliedBy(0.3)
        }
    }
    
    func configConstraintsForNoteWithoutImage () {
        
        [titleLabel, noteLabel].forEach {addSubview($0)}
        
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(16)
            make.leading.equalTo(self.snp.leading).offset(64)
            make.trailing.equalTo(self.snp.trailing).offset(-64)
            make.height.equalTo(self).multipliedBy(0.3)
        }
        
        noteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.height.equalTo(self).multipliedBy(0.5)
        }
    }
}






