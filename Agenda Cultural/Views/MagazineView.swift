//
//  MagazineView.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 09/12/2021.
//

import SwiftUI
import Introspect

class ScrollViewDelegate: NSObject, UIScrollViewDelegate {
    var scrollView: UIScrollView?
    
    func scrollToTheTop(animated: Bool = false) {

        scrollView?.setContentOffset(.zero, animated: animated)
    }
}

struct MagazineView: View {
    @ObservedObject var viewModel = MagazineViewModel()
    
    var scrollDelegate = ScrollViewDelegate()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.issues, id:\.self) { issueId in
                                Text(issueId.fromDate)
                                    .font(.headline)
                                    .foregroundColor(issueId == viewModel.selectedIssue ? Color(uiColor: .label) : Color(uiColor: .secondaryLabel))
                                    .underline(issueId == viewModel.selectedIssue, color: Color(uiColor: .label))
                                    .clipShape(Rectangle())
                                    .onTapGesture { didTapIssue(issueId) }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                    Divider()
                        .padding(.horizontal)
                }
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.articles[viewModel.selectedIssue] ?? [], id: \.self) { article in
                            if article.isInterview {
                                NavigationLink(destination: ArticleView(articleId: article.id!)) {
                                    MagazineInterviewView(article: article)
                                        .padding(.horizontal)
                                }
                                .buttonStyle(.plain)
                            }
                            else {
                                NavigationLink(destination: ArticleView(articleId: article.id!)) {
                                    MagazineGeneralView(article: article)
                                        .padding(.horizontal)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .introspectScrollView { scrollView in
                    
                    scrollView.delegate = scrollDelegate
                    scrollDelegate.scrollView = scrollView
                }
            }
            .navigationTitle("Magazine")
        }
        .onAppear { viewModel.loadArticle() }
    }
    
    func didTapIssue(_ issue: String) {
        
        scrollDelegate.scrollToTheTop(animated: issue == viewModel.selectedIssue)
        viewModel.selectedIssue = issue
    }
}

struct MagazineView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineView()
    }
}

class MagazineViewModel: ObservableObject {
    @Published var articles = [String: [ACLArticle]]()
    @Published var issues = [String]()
    @Published var selectedIssue = String()
    
    // MARK: - Exposed Methods
    func loadArticle() {
        Task {
            do {
                
                let articles = try await MagazineService.getAllArticles()
                updateArticles(with: articles)
            }
            catch let error as NSError {
                // FIXME: - Log and handle error
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Private Methods
    private func updateArticles(with newArticles: [ACLArticle]) {
        
        var magazineIssues = [String: [ACLArticle]]()
        var issues = Set<String>()
        
        // Sorts articles by Year/Month
        for var article in newArticles {
            
            if (article.month ?? String()).count == 1 {
                
                article.month = "0\(article.month ?? String())"
            }
            let issueId = "\(article.year ?? String())\(article.month ?? String())"
            issues.insert(issueId)
            if var issue = magazineIssues[issueId] {
                
                issue.append(article)
                issue.sort(by: { $0.month ?? String() > $1.month ?? String() })
                magazineIssues[issueId] = issue
            }
            else {
                
                magazineIssues[issueId] = [article]
            }
        }
        
        // Creates the Recent Articles (current and previous month)
        var listOfIssues = issues.sorted(by: { $0 > $1 })
        var listOfRecentArticles = [ACLArticle]()
        
        let currentIssue = listOfIssues.removeFirst()
        listOfRecentArticles.append(contentsOf: magazineIssues[currentIssue] ?? [])
        magazineIssues.removeValue(forKey: currentIssue)
        
        let previousIssue = listOfIssues.removeFirst()
        listOfRecentArticles.append(contentsOf: magazineIssues[previousIssue] ?? [])
        magazineIssues.removeValue(forKey: previousIssue)
        
        listOfIssues.insert("Recentes", at: 0)
        listOfRecentArticles.sort(by: { $0.month ?? String() > $1.month ?? String() })
        magazineIssues["Recentes"] = listOfRecentArticles

        // Publishes to the UI
        DispatchQueue.main.async {
            
            self.issues = listOfIssues
            self.articles = magazineIssues
            self.selectedIssue = self.issues.first ?? String()
        }
    }
}
