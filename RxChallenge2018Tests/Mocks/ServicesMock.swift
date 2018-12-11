@testable import RxChallenge2018
import RxChallengeDomain
import RxSwift

let testGeoPoint = GeoPoint(lat: "1", lng: "0")
let testAddress = Address(street: "Street1", suite: "Suite2", city: "City3", zipcode: "08080", geoPoint: testGeoPoint)
let testUser = User(id: 1, name: "Bob", username: "Bob23", email: "bob@email.com", address: testAddress)
let testUserNil = User(id: nil, name: nil, username: nil, email: nil, address: nil)

let validPosts = [testPost1, testPost2]
let nilPosts = [testPostNil1, testPostNil2]

let testPost1 = Post(id: 1, userId: 11, title: "post1", body: "body1")
let testPost2 = Post(id: 2, userId: 12, title: "post2", body: "body2")
let testPostNil1 = Post(id: nil, userId: nil, title: nil, body: nil)
let testPostNil2 = Post(id: nil, userId: nil, title: nil, body: nil)

let testComment1 = Comment(id: 1, postId: 11, name: "comment1", email: "emailcomment1@comment.com", body: "my comment 1")
let testComment2 = Comment(id: 2, postId: 12, name: "comment2", email: "emailcomment2@comment.com", body: "my comment 2")
let testComment3 = Comment(id: 3, postId: 13, name: "comment3", email: "emailcomment3@comment.com", body: "my comment 3")
let testComment4 = Comment(id: 4, postId: 14, name: "comment4", email: "emailcomment4@comment.com", body: "my comment 4")
let testCommentNil = Comment(id: nil, postId: nil, name: nil, email: nil, body: nil)

let validComments = [testComment1, testComment2, testComment3, testComment4]
let nilComments = [testCommentNil]

class TypicodeServiceMock: TypicodeService {
    
    var returnNils = false
    
    func getPosts() -> Single<[Post]> {
        return Single.just(returnNils ? nilPosts : validPosts)
    }
    
    func getUser(with id: Int) -> Single<User> {
        return Single.just(returnNils ? testUserNil : testUser)
    }
    
    func getComments(for postId: Int) -> Single<[Comment]> {
        return Single.just(returnNils ? nilComments : validComments)
    }
}
