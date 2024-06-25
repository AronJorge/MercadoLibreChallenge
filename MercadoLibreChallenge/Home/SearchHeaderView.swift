//
//  SearchHeaderView.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//

import UIKit

protocol SearchHeaderViewDelegate {
    func searchHeaderViewDidEndSearch(withText text: String)
}

class SearchHeaderView: UIView {
    var onUbication: (() -> Void)?
    var delegate: SearchHeaderViewDelegate?
    var searchText: String {
        get {
            return searchBarView.text ?? ""
        }
    }
    
    private lazy var searchBarView: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "search_marketplace".localized
        searchBar.backgroundColor = UIColor(named: Constants.colors.primary)
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .default
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.searchTextField.backgroundColor = .white
        return searchBar
    }()
    
    private lazy var markUbicationIcon: UIImageView = {
        let iconView = createIconImageView(stringIcon: Constants.icons.mappin, size: CGSize(width: 18, height: 20))
        return iconView
    }()

    private lazy var ubicationLabel: UILabel = {
        let label = UILabel()
        label.text = "location".localized
        label.textColor = .blue
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private func createIconImageView(stringIcon: String, size: CGSize) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: stringIcon)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               imageView.widthAnchor.constraint(equalToConstant: size.width),
               imageView.heightAnchor.constraint(equalToConstant: size.height)
           ])
        return imageView
    }

    private lazy var ubicationButtonView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [markUbicationIcon, ubicationLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ubicationButtonTapped))
        stackView.addGestureRecognizer(tapGestureRecognizer)
        return stackView
    }()

    @objc private func ubicationButtonTapped() {
        onUbication!()
    }

    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchBarView, ubicationButtonView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: Constants.colors.primary)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        if let superview = mainStackView.superview {
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: superview.topAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
            ])
        }
    }
}

extension SearchHeaderView: UISearchBarDelegate, UITextFieldDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
        
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        
        if let text = searchBar.text {
            delegate?.searchHeaderViewDidEndSearch(withText: text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = false
    }
}
