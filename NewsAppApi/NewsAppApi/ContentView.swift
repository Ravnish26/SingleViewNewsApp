//
//  ContentView.swift
//  NewsAppApi
//
//  Created by Ravnish Singh on 27/12/22.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit

struct ContentView: View {
   @ObservedObject var list = getData()
    var body: some View {
        
            
        NavigationView{
            
            List(list.datas){i in
                NavigationLink(destination: webView(url: i.url)
                    .navigationBarTitle("",displayMode: .inline)){
                        HStack(spacing: 15){
                            VStack(alignment: .leading, spacing: 10){
                                Text(i.title).fontWeight(.heavy)
                                Text(i.desc).lineLimit(2)
                            }
                            
                            if i.image != ""{
                                WebImage(url: URL(string: i.image), options: .highPriority, context: nil).resizable().frame(width: 110, height: 135).cornerRadius(20)
                            }
                        }.padding(.vertical,15)
                    }
                    .navigationBarTitle("NEWS FEED")
            }
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button("save"){
                        
                    }
                }
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct dataType : Identifiable {
    var id: String
    var title: String
    var desc: String
    var url: String
    var image: String
}

class getData: ObservableObject {
    @Published var datas = [dataType]()
    
    init() {
        let source="https://newsapi.org/v2/everything?apiKey=a2982a0eb8d24333b28a725c4bf8102e&q=india&page=1&pageSize=20";
        let url = URL(string: source)!
        let session = URLSession (configuration: .default)
        
        session.dataTask(with: url){(data, _, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            let json = try! JSON(data: data!)
            for i in json["articles"]{
                let title = i.1["title"].stringValue
                let description = i.1["description"].stringValue
                let url = i.1["url"].stringValue
                let image = i.1["urlToImage"].stringValue
                let id = i.1["publishedAt"].stringValue
                
                
                DispatchQueue.main.async {
                    self.datas.append(dataType(id: id, title: title, desc: description, url: url, image: image))
                }
            }
        }.resume()
    }
}

struct webView : UIViewRepresentable {
    
    var url : String
    func makeUIView(context: UIViewRepresentableContext<webView>) -> WKWebView{
        let view = WKWebView()
        view.load(URLRequest(url: URL(string: url)!))
        return view
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}


