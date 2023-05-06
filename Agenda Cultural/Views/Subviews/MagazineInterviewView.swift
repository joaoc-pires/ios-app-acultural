//
//  MagazineInterviewView.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 09/12/2021.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct MagazineInterviewView: View {
    @ObservedObject var viewModel: ACLImageViewModel
    @State var article: ACLArticle
    
    init(article: ACLArticle) {
        self.viewModel = ACLImageViewModel(article: article)
        self.article = article
    }
    
    var body: some View {
        ZStack {
            if viewModel.image != nil {
                Image(uiImage: viewModel.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Entevista:")
                            .bold()
                            .font(.title)
                            .background(Rectangle().foregroundColor(.yellow))
                        Text("\(article.title?.rendered ?? String())")
                            .bold()
                            .font(.title)
                            .background(Rectangle().foregroundColor(.yellow))
                    }
                    Spacer()
                }
                Spacer(minLength: 0)
                HStack {
                    Spacer()
                    Text(article.subtitle ?? String())
                        .font(.subheadline)
                        .foregroundColor(Color(uiColor: .white))
                        .background(Rectangle().foregroundColor(.black))
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .onAppear(perform: viewModel.load)
    }
    
}

struct MagazineSugestionView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineInterviewView(article: ACLArticle.testArticle())
    }
}

class ACLImageViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var image: UIImage?
    
    var imageManager: ImageManager
    var article: ACLArticle
    
    init(article: ACLArticle) {
        self.article = article
        self.imageManager = ImageManager(url: URL(string: article.imageURL))
        self.imageManager.setOnSuccess(perform: didLoad)
    }
    
    func load() {
        isLoading = true
        imageManager.load()
    }

    func didLoad(newImage: PlatformImage, data: Data?, cache: SDImageCacheType) {
        newImage.cgImage?.faceCrop(completion: { result in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch result {
            case .success(let cgImage):
                print("Success")
                DispatchQueue.main.async {
                    self.image = UIImage(cgImage: cgImage)
                }
            case .failure(let error):
                print(error.localizedDescription)
            case .notFound: print("not found")
            }

        })
    }
}

struct ACLWebImageView: UIViewRepresentable {
    var url: String
    var imageView = UIImageView()
    
    func makeUIView(context: Context) -> UIImageView {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        imageView.sd_setImage(with: URL(string: url)) { image, error, cache, url in
            image?.cgImage?.faceCrop(completion: { result in
                switch result {
                case .success(let cgImage):
                    print("Success")
                    DispatchQueue.main.async {
                        self.updateUIView(UIImageView(image: UIImage(cgImage: cgImage)), context: context)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                case .notFound: print("not found")
                }

            })
        }
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        imageView.image = uiView.image
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
