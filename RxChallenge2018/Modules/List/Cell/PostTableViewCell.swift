import UIKit

class PostTableViewCell: UITableViewCell {

    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 16)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with title: String) {
        titleLabel.text = title
    }
}

private extension PostTableViewCell {
    func setupUI() {
        layoutUI()
    }
    
    func layoutUI() {
        contentView.addSubviewWithAutolayout(titleLabel)
        titleLabel.fillSuperview(withEdges: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
}
