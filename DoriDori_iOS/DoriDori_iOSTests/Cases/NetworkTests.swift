//
//  NetworkTests.swift
//  DoriDori_iOSTests
//
//  Created by JeongMinho on 2022/06/15.
//

import XCTest
@testable import DoriDori_iOS

final class NetworkTests: XCTestCase {

    private var sut: Network!
    
    override func setUp() {
        super.setUp()
        self.sut = Network(baseURL: "fake_url")
    }

    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }

    func testRxNetwork_setFailRequest_catchError() async {
        // given
        let request = FakeRequest(
            path: "/fake_api",
            parameters: ["fake": ""],
            method: .get
        )
        
        // when
        var response: FakeModel?
        var networkError: Error?
        do {
            response = try await sut.fetch(
                request: request,
                responseModel: ResponseModel<FakeModel>.self
            ).value
        } catch (let error) {
            networkError = error
        }
        
        // then
        XCTAssertNil(response)
        XCTAssertNotNil(networkError)
    }
}
