//
//  EffectView.swift
//  EffectView
//
//  Created by 山田紘暉 on 2023/05/20.
//

import SwiftUI

struct EffectView: View {
    @Binding var isShowSheet: Bool
    
    let captureImage: UIImage
    
    @State var showImage: UIImage?
    
    var body: some View {
        VStack {
            Spacer()
            
            if let showImage {
                Image(uiImage: showImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Spacer()
            
            Button {
                // エフェクトボタンをタップした時のアクション
                let filterName = "CIPhotoEffectMono"
                let rotate = captureImage.imageOrientation
                let inputImage = CIImage(image: captureImage)
                
                // 引数で指定された種類を指定してCIFilterのインスタンス取得
                guard let effectFilter = CIFilter(name: filterName) else {
                    return
                }
                
                // フィルタ加工パラメータを初期化
                effectFilter.setDefaults()
                // インスタンスにフィルタ加工する元の画像を設定
                effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
                // フィルタ加工を行う情報を生成
                guard let outputImage = effectFilter.outputImage else {
                    return
                }
                
                // CIContextのインスタンスを取得
                let ciContext = CIContext(options: nil)
                // フィルタ加工後の画像をCIContext上に描画し、
                // 結果をcgimageとしてCGImage形式の画像を取得
                guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                    return
                }
                // UIImage形式の画像に変更、その際に回転角度を指定する
                showImage = UIImage(
                    cgImage: cgImage,
                    scale: 1.0,
                    orientation: rotate
                )
                
            } label: {
                Text("エフェクト")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }.padding()
            
            if let showImage, let shareImage = Image(uiImage: showImage) {
                ShareLink(item: shareImage, subject: nil,
                          message: nil, preview: SharePreview("Photo", image: shareImage)) {
                    Text("シェア")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                }.padding()
            }
            
            Button {
                isShowSheet.toggle()
            } label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }.padding()
        }
        
        .onAppear {
            // 撮影した写真を表示する写真に設定
            showImage = captureImage
        }
    }
}

struct EffectView_Preview: PreviewProvider {
    static var previews: some View {
        EffectView(
            isShowSheet: .constant(true),
            captureImage: UIImage(named: "preview_use")!
        )
    }
}
