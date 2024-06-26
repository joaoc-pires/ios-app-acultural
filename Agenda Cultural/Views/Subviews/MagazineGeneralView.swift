//
//  MagazineGeneralView.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 09/12/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct MagazineGeneralView: View {
    var article: ACLArticle
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: article.imageURL))
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Rectangle())
            VStack(alignment: .leading) {
                Text(article.title?.rendered ?? String())
                    .font(.headline)
                    .bold()
                    .background(Rectangle().foregroundColor(.yellow))
                Text(article.subtitle ?? String())
                    .font(.subheadline)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                Spacer()
            }
            Spacer()
        }
    }
}

struct MagazineGeneralView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineGeneralView(article: try! ACLArticle(from: JSONDecoder() as! Decoder))
    }
}
