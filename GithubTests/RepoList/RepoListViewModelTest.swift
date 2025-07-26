import XCTest
import RxSwift
import RxCocoa
import RxRelay
@testable import Github

class RepoListViewModelTests: XCTestCase {

    var sut: RepoListViewModel!
    var mockAPIService: MockGitHubAPIService!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockAPIService = MockGitHubAPIService()
        sut = RepoListViewModel(apiService: mockAPIService)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        mockAPIService = nil
        disposeBag = nil
        super.tearDown()
    }

    func testInitialLoad_ResetsItemsAndLoadsFirstPage() {
        let expectedInitialRepos: [Repository] = [
            Repository(id: 1,
                       name: "repo da bia",
                       fullName: "biaogioni/repo da bia",
                       owner: User(login: "biaogioni", id: 13, avatarURL: nil),
                       description: nil,
                       stars: 10,
                       forksCount: 10203)
        ]
        
        mockAPIService.searchSwiftReposResult = { page, completion in
            XCTAssertEqual(page, 1)
            completion(.success(SearchReposResponse(totalCount: 1,
                                                    incompleteResults: false,
                                                    items: expectedInitialRepos)))
        }

        let expectation = XCTestExpectation(description: "Initial load completes and updates items")
        
        sut.items
            .skip(1)
            .subscribe(onNext: { repos in
                XCTAssertEqual(repos, expectedInitialRepos)
                XCTAssertEqual(self.value(forKey: "currentPage", on: self.sut) as? Int, 2)
                XCTAssertFalse(self.value(forKey: "isLoading", on: self.sut) as! Bool)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.initialLoad()

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testInitialLoad_HandlesAPIError() {
        let expectedError = MockError.customError("Network failed")
        
        mockAPIService.searchSwiftReposResult = { page, completion in
            XCTAssertEqual(page, 1)
            completion(.failure(expectedError))
        }
        
        let expectation = XCTestExpectation(description: "Initial load handles error")
        
        sut.items
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.value(forKey: "isLoading", on: self.sut) as! Bool)
            expectation.fulfill()
        }

        sut.initialLoad()

        wait(for: [expectation], timeout: 1.0)
    }

//    func testLoadNextPage_LoadsMoreDataAndIncrementsPage() {
//        let initialRepos: [Repository] = [
//            Repository(id: 1,
//                       name: "repo da bia",
//                       fullName: "biaogioni/repo da bia",
//                       owner: User(login: "biaogioni", id: 13, avatarURL: nil),
//                       description: nil,
//                       stars: 10,
//                       forksCount: 10203)
//        ]
//        let newRepos: [Repository] = [
//            Repository(id: 1,
//                       name: "repo da bia",
//                       fullName: "biaogioni/repo da bia",
//                       owner: User(login: "biaogioni", id: 13, avatarURL: nil),
//                       description: nil,
//                       stars: 10,
//                       forksCount: 10203)
//        ]
//
//        sut.items.accept(initialRepos)
//        self.setValue(1, forKey: "currentPage", on: sut)
//        self.setValue(false, forKey: "isLoading", on: sut)
        
//        mockAPIService.searchSwiftReposResult = { page, completion in
//            XCTAssertEqual(page, 1)
//            completion(.success(SearchReposResponse(total_count: initialRepos.count + newRepos.count, items: newRepos)))
//        }

//        let expectation = XCTestExpectation(description: "Next page loads and appends data")
//        
//        var updateCount = 0
//        sut.items
//            .skip(1)
//            .subscribe(onNext: { repos in
//                updateCount += 1
//                if updateCount == 1 {
//                    XCTAssertEqual(repos.count, initialRepos.count + newRepos.count)
//                    XCTAssertEqual(repos, initialRepos + newRepos)
//                    XCTAssertEqual(self.value(forKey: "currentPage", on: self.sut) as? Int, 2)
//                    XCTAssertFalse(self.value(forKey: "isLoading", on: self.sut) as! Bool)
//                    expectation.fulfill()
//                }
//            })
//            .disposed(by: disposeBag)
//
//        sut.loadNextPage()
//
//        wait(for: [expectation], timeout: 1.0)
//    }
    
    func testLoadNextPage_DoesNothingWhenAlreadyLoading() {
        self.setValue(true, forKey: "isLoading", on: sut)
        
        mockAPIService.searchSwiftReposResult = { _, _ in
            XCTFail("API service should not be called when isLoading is true")
        }
        
        let expectation = XCTestExpectation(description: "No API call made")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.2)
    }

    func testLoadNextPage_HandlesAPIErrorAndResetsLoadingState() {
        let expectedError = MockError.customError("API fetch failed")
        
        mockAPIService.searchSwiftReposResult = { page, completion in
            completion(.failure(expectedError))
        }

        let expectation = XCTestExpectation(description: "Error handled and loading state reset")
        
        sut.loadNextPage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.value(forKey: "isLoading", on: self.sut) as! Bool)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadNextPage_HandlesEmptyResponse() {
        let initialRepos: [Repository] = [
            Repository(id: 1,
                       name: "repo da bia",
                       fullName: "biaogioni/repo da bia",
                       owner: User(login: "biaogioni", id: 13, avatarURL: nil),
                       description: nil,
                       stars: 10,
                       forksCount: 10203)
        ]
        sut.items.accept(initialRepos)
        self.setValue(1, forKey: "currentPage", on: sut)
        self.setValue(false, forKey: "isLoading", on: sut)
        
        mockAPIService.searchSwiftReposResult = { page, completion in
            XCTAssertEqual(page, 1)
            completion(.success(SearchReposResponse(totalCount: initialRepos.count, incompleteResults: false, items: [])))
        }

        let expectation = XCTestExpectation(description: "Empty response handled, isLoading reset")
        
        sut.items
            .skip(1)
            .subscribe(onNext: { repos in
                XCTAssertEqual(repos, initialRepos)
                XCTAssertEqual(self.value(forKey: "currentPage", on: self.sut) as? Int, 1)
                XCTAssertFalse(self.value(forKey: "isLoading", on: self.sut) as! Bool)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        sut.loadNextPage()

        wait(for: [expectation], timeout: 1.0)
    }
}

extension XCTestCase {
    func value(forKey key: String, on object: Any) -> Any? {
        return (object as AnyObject).value(forKey: key)
    }
    
    func setValue(_ value: Any?, forKey key: String, on object: Any) {
        (object as AnyObject).setValue(value, forKey: key)
    }
}
