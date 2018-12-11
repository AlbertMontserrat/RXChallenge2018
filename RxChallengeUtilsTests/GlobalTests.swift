import XCTest
@testable import RxChallengeUtils

class GlobalTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testReplacingVariables() {
        //Having
        let raw = "$var1,$var2,$var3,$var4,$var5,$var6,$var7,$var8,$var9,$var10,$var11,$var12,$var13,$var20"
        let variables = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t"]
        let expected = "a,b,c,d,e,f,g,h,i,j,k,l,m,t"
        //When
        let translated = raw.replacingVariables(variables)
        //Then
        XCTAssertTrue(translated == expected)
    }
}
