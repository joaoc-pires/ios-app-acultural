//
//  ArticleView.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 09/12/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArticleView: View {
    @ObservedObject var viewModel = ArticleViewModel()
    
    var articleId: Int
    
    var body: some View {
        ScrollView {
            VStack {
                WebImage(url: URL(string: viewModel.article?.imageURL ?? String()))
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 5, x: 0, y: 0)
                HStack {
                    VStack (alignment: .leading) {
                        Text(viewModel.article?.title?.rendered ?? String())
                            .font(.title)
                            .bold()
                        Text(viewModel.article?.subtitle ?? String())
                            .font(.subheadline)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                        if viewModel.author?.name != nil {
                            Text("por \(viewModel.author!.name!)")
                                .font(.caption)
                                .fontWeight(.light)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }
                    }
                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .onAppear { viewModel.loadArticle(with: articleId) }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(articleId: 1)
    }
}

class ArticleViewModel: ObservableObject {
    @Published var article: ACLArticleDetail?
    @Published var author: ACLAuthor?
    
    func loadArticle(with id: Int) {
        Task {
            do {
                
                let article = try await MagazineService.getArticle(byId: id)
                update(article: article)
                loadAuthor(withId: article.author)
            }
            catch let error as NSError {
                // FIXME: - Log and handle error
                print(error.localizedDescription)
            }
        }
    }
    
    func loadAuthor(withId authorId: Int?) {
        
        guard let authorId = authorId else { return }
        Task {
            do {
                
                let author = try await MagazineService.getAuthor(byId: authorId)
                update(author)
            }
            catch let error as NSError {
                // FIXME: - Log and handle error
                print(error.localizedDescription)
            }
        }

    }

    func update(article: ACLArticleDetail) {
        
        DispatchQueue.main.async {
            
            self.article = article
        }
    }
    
    func update(_ author: ACLAuthor) {

        DispatchQueue.main.async {
            
            self.author = author
        }
    }
}
