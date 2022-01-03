//
//  MagazineInterviewView.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 09/12/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct MagazineInterviewView: View {
    var article: ACLArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(article.title?.rendered ?? String())!")
                .font(.title)
                .bold()
            WebImage(url: URL(string: article.imageURL))
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 5, x: 0, y: 0)
            Text(article.subtitle ?? String())
                .font(.subheadline)
                .foregroundColor(Color(uiColor: .secondaryLabel))

        }
    }
}

struct MagazineSugestionView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineInterviewView(article: try! ACLArticle(from: JSONDecoder() as! Decoder))
    }
}
