//
//  ContentView.swift
//  MyCamera
//
//  Created by 山田紘暉 on 2023/05/20.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State var captureImage: UIImage? = nil
    @State var isShowSheet = false
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            Spacer()
            if let captureImage {
                Image(uiImage: captureImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Spacer()
            
            Button {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラは利用できます")
                    isShowSheet.toggle()
                } else {
                    print("カメラは利用できません")
                }
            } label: {
                Text("カメラを起動する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
            .sheet(isPresented: $isShowSheet) {
                ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
            }
            
            // フォトライブラリーから選択する
            PhotosPicker(selection: $photoPickerSelectedImage, matching: .images,
                         preferredItemEncoding: .automatic, photoLibrary: .shared()) {
                Text("フォトライブラリーから選択する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .padding()
            }
            // 選択した写真情報をもとに写真を取り出す
             .onChange(of: photoPickerSelectedImage) { photosPickerItem in
                 if let photosPickerItem {
                     photosPickerItem.loadTransferable(type: Data.self) { result in
                         switch result {
                         case .success(let data):
                             if let data {
                                 captureImage = UIImage(data: data)
                             }
                         case .failure:
                             return
                         }
                     }
                 }
             }
            
            if let captureImage,
               let shareImage = Image(uiImage: captureImage) {
                ShareLink(item: shareImage, preview: SharePreview("Photo", image: shareImage)) {
                    Text("SNSに投稿する")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .padding()
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
