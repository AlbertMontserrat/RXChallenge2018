import GenericCellControllers
import RxChallengeUtils

struct PostCellDescriptor {
    let title: String
}

final class PostCellController: GenericCellController<PostTableViewCell> {
    
    let descriptor: PostCellDescriptor
    let didSelectCellClosure: VoidClosure
    
    init(descriptor: PostCellDescriptor, didSelectCell: @escaping VoidClosure) {
        self.descriptor = descriptor
        self.didSelectCellClosure = didSelectCell
    }
    
    override func configureCell(_ cell: PostTableViewCell) {
        cell.config(with: descriptor.title)
    }
    
    override func didSelectCell() {
        didSelectCellClosure()
    }
}
