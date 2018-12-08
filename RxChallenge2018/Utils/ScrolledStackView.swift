import UIKit
import RxSwift
import RxCocoa

class ScrolledStackView: UIScrollView {
    
    var direction: NSLayoutConstraint.Axis
    let insets: UIEdgeInsets
    private lazy var disposeBag = DisposeBag()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = direction
        return stackView
    }()
    
    required init(frame: CGRect = .zero, direction: NSLayoutConstraint.Axis, insets: UIEdgeInsets) {
        self.direction = direction
        self.insets = insets
        super.init(frame: frame)
        stackView.rx.observe(NSLayoutConstraint.Axis.self, "axis").subscribe(onNext: { axis in
            if axis != direction {
                fatalError("Don't change axis in the stack view. Axis should be set with the direction param in init method.")
            }
        }).disposed(by: disposeBag)
        setupUI()
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ScrolledStackView {
    func setupUI() {
        addSubviewWithAutolayout(stackView)
    }
    
    func layoutUI() {
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: insets.top, leftConstant: insets.left, bottomConstant: insets.bottom, rightConstant: insets.right)
        if direction == .vertical {
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0, constant: (insets.left + insets.right) * -1).isActive = true
        } else {
            stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0, constant: (insets.top + insets.bottom) * -1).isActive = true
        }
    }
}
