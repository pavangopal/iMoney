//
//  SearchCell.swift
//  iMoney
//
//  Created by Pavan Gopal on 6/27/18.
//  Copyright © 1018 Pavan Gopal. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchCell: UITableViewCell {

    var thumnailImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var titleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private var disposeBag: DisposeBag? = DisposeBag()
    
    var viewModel: SearchCellModeling? {
        didSet{
            
            let disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else { return }
            
            viewModel.image
                .bind(to: thumnailImage.rx.image)
                .disposed(by: disposeBag)
            
            titleLabel.text = viewModel.title
            descriptionLabel.text = viewModel.description
            
            self.disposeBag = disposeBag
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        contentView.addSubview(thumnailImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate(
            [
             thumnailImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
             thumnailImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
             thumnailImage.widthAnchor.constraint(equalToConstant: 40),
             thumnailImage.heightAnchor.constraint(equalToConstant: 40),
        
             titleLabel.leftAnchor.constraint(equalTo: thumnailImage.rightAnchor, constant: 10),
             titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
             titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
             
             descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
             descriptionLabel.leftAnchor.constraint(equalTo: thumnailImage.rightAnchor, constant: 10),
             descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
             descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
             descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
        viewModel = nil
        disposeBag = nil
    }

}
