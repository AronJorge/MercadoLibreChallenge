//
//  FiltersHeaderswift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//

import UIKit

class TotalResultHeaderView: UIView {
    private lazy var resultsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkText
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBorder(side: .bottom, thickness: 1, color: .lightGray)
    }
    
    private func layout() {
        addSubview(resultsLabel)
        resultsLabel.translatesAutoresizingMaskIntoConstraints = false

        if let superview = resultsLabel.superview {
            NSLayoutConstraint.activate([
                resultsLabel.topAnchor.constraint(equalTo: superview.topAnchor),
                resultsLabel.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                resultsLabel.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 26),
                resultsLabel.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
            ])
        }
    }
    
    func setResults(numberOfItems: Int) {
        resultsLabel.text =  String(format: "results_format".localized, numberOfItems)
    }
}
