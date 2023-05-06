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
                ScrollView {
                    VStack {
//                        ForEach(viewModel.interviews, id: \.self) { interview in
//                            NavigationLink(destination: ArticleView(articleId: interview.id!)) {
//                                MagazineInterviewView(article: interview)
//                                    .padding(.horizontal)
//                            }
//                            .buttonStyle(.plain)
//                        }
                        ForEach(viewModel.articles, id: \.self) { article in
                            NavigationLink(destination: ArticleView(articleId: article.id!)) {
                                MagazineGeneralView(article: article)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.plain)

                        }
                    }
                }
            }
            .navigationTitle("Magazine")
        }
        .onAppear(perform: viewModel.loadArticle)
    }
}

struct MagazineView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineView()
    }
}

class MagazineViewModel: ObservableObject {
    @Published var interviews = [ACLArticle]()
    @Published var articles = [ACLArticle]()
    
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
        var sortedAllArticles = newArticles.sorted(by: {$0.articleSortId > $1.articleSortId})
        var sortedArticles = sortedAllArticles.filter({ !$0.isInterview })
        var sortedInterviews = sortedAllArticles.filter({ $0.isInterview })
        DispatchQueue.main.async {
            self.interviews = sortedInterviews
            self.articles = sortedArticles
        }
    }
}
