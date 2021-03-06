import UIKit

class PostTableViewCell: UITableViewCell {

    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .customDarkBlue
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 15)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    func config(with title: String) {
        titleLabel.text = title
    }
}

private extension PostTableViewCell {
    func setupUI() {
        selectionStyle = .none
        layoutUI()
    }
    
    func layoutUI() {
        contentView.addSubviewWithAutolayout(titleLabel)
        titleLabel.fillSuperview(withEdges: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
}
