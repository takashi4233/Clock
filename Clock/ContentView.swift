//
//  ContentView.swift
//  Clock
//
//  Created by TAKASHI YOSHIMURA on 2023/01/05.
//

import SwiftUI

struct ContentView: View {
    @State var nowDate = Date()
    @State var dateText = ""
    @State var dateText2 = ""
    @State var ss = ""
    @State var curHour = ""
    @State var nextHour = ""
    @State var progressValue = -1.0
    
    @State var isCountDown = false
    @State var countDownTime = 0
    @State var countDown = 0
    @State var count = 0
    @State var countDonwTimeProgress = 0.0
    @State var timeLeft = 0
    @State var bgColor = Color(.black)
    @State var bgColorFlg = true

    // ミュート設定されているか
    @State var isMute = false
    
    private let dateFormatter1 = DateFormatter()
    private let dateFormatter2 = DateFormatter()
    private let dateFormatter4 = DateFormatter()
    private let dateFormatter5 = DateFormatter()
    private let dateFormatter6 = DateFormatter()
    
    
    //音楽ファイル再生
    let musicplayer = SoundPlayer()

    // 時報がなる時間になった際に、背景色を変える
    func changeBgColor(b:Bool) {
        if b {
            bgColor = Color(.black)
        } else {
            bgColor = Color(.systemTeal)
        }
    }
    
    //ミュートしている場合に、背景色を変える
    func changeBgColorMute(b:Bool){
        if b {
            bgColor = Color(.systemMint)
        } else {
            bgColor = Color(.black)
        }
    }
        
    
    init() {
        //dateFormatter.dateFormat = "YYYY/MM/dd(E) \nHH:mm:ss"
        dateFormatter1.dateFormat = "HH:mm"
        dateFormatter1.locale = Locale(identifier: "ja_jp")
        
        dateFormatter2.dateFormat = "YYYY-MM-dd(E)"
        dateFormatter2.locale = Locale(identifier: "ja_jp")
        
        dateFormatter4.dateFormat = "HH"
        dateFormatter4.locale = Locale(identifier: "ja_JP")
        
        dateFormatter5.dateFormat = "mm"
        dateFormatter5.locale = Locale(identifier: "ja_JP")
        
        dateFormatter6.dateFormat = "ss"
        dateFormatter6.locale = Locale(identifier: "ja_JP")
        
        let mm = Double(dateFormatter5.string(from: nowDate))
        progressValue = Double(mm! / 60.0)
    }
    var body: some View {
        let bouns = UIScreen.main.bounds
        
        ZStack(){
            bgColor
                .edgesIgnoringSafeArea(.all)
            if progressValue != -1 {
                VStack {
                    HStack{
                        Spacer()
                        Text(dateText2.isEmpty ? "\(dateFormatter2.string(from: nowDate))" : dateText2)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .padding(.top, 30.0)
                            .foregroundColor(.white)
                            .background(.clear)
                        Spacer()
                        /** ミュートボタン **/
                        Button(action: {
                            isMute.toggle()
                            musicplayer.stopAllMusic()
                            changeBgColorMute(b: isMute)
                        }){
                            if isMute {
                                Image("mute")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:20,height:20)
                                    .padding()
                            } else {
                               Image("bell")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:20,height:20)
                                    .padding()
                            }
                        }
                    }
                    Spacer()
                        .frame(height: bouns.height * 0.1)
                    HStack(alignment: .bottom) {
                        
                        Text(dateText.isEmpty ? "\(dateFormatter1.string(from: nowDate))" : dateText)
                            .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 120, weight: .bold)))
                            .foregroundColor(.white)
                            .padding(10.0)
                            .frame(height: 4.0)
                        Text(ss)
                            .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 40, weight: .bold)))
                            .foregroundColor(.white)
                            .padding(-3.0)
                    }
                    Spacer()
                        .frame(height: bouns.height * 0.2)
                    ZStack(){
                        HStack {
                            Text(curHour)
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .padding(.leading, -60.0)
                                .foregroundColor(.white)
                                .background(.clear)
                            
                            Rectangle()
                                .fill(.orange)
                                .frame(width: (bouns.width-300.0) * progressValue,height: 30)
                            
                            Rectangle()
                                .frame(width: (bouns.width-300.0) * (1 - progressValue),height: 30)
                                .foregroundColor(.white)
                            
                            Text(nextHour)
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .padding(.trailing, -60.0)
                                .foregroundColor(.white)
                                .background(.clear)
                        }
                        
                        // 星の位置
                        HStack(){
                            Rectangle()
                                .fill(.clear)
                                .frame(width: (bouns.width-300.0) * progressValue,height: 30)
                            
                            Image("pointer")
                                .resizable()
                                .scaledToFill()
                                .frame(width:50,height:30)
                            Rectangle()
                                .frame(width: (bouns.width-300.0) * (1 - progressValue),height: 30)
                                .foregroundColor(.clear)
                        }
                        
                    }
                    
                    HStack() {
                        if isCountDown {
                            VStack(){
                                ZStack(){
                                    HStack(){
                                        Text("0")
                                            .font(.system(size: 30, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                        
                                        Rectangle()
                                            .fill(.yellow)
                                            .frame(width: (bouns.width-300.0) * countDonwTimeProgress,height: 30)
                                        
                                        
                                        Rectangle()
                                            .frame(width: (bouns.width-300.0) * (1 - countDonwTimeProgress),height: 30)
                                            .foregroundColor(.white)
                                        
                                        
                                        Text(String(countDownTime))
                                            .font(.system(size: 30, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                    HStack(){
                                        Rectangle()
                                            .fill(.clear)
                                            .frame(width: (bouns.width-340.0) * countDonwTimeProgress,height: 30)
                                        //星をタップしたらタイマーを止める
                                        Button(action:{
                                            isCountDown.toggle()
                                            count = 0
                                        }){
                                            //ここに画像データを配置する予定
                                            Image("pointer")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width:40,height:40)
                                        }
                                        Rectangle()
                                            .frame(width: (bouns.width-300.0) * (1 - countDonwTimeProgress),height: 30)
                                            .foregroundColor(.clear)
                                    }
                                }
                                //残り時間
                                Text( String(format: "%02d", Int(timeLeft / 60)) + ":" +  String(format: "%02d", timeLeft % 60))
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        } else {
                            Button(action:{
                                isCountDown.toggle()
                                countDownTime  = 60
                                countDown = countDownTime * 60
                            } ){
                                ZStack(){
                                    Rectangle()
                                        .frame(width:bouns.width / 6,height: 60)
                                        .foregroundColor(.gray)
                                        .cornerRadius(30.0)
                                    Text ("60")
                                        .font(.system(size: 40, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                            }
                            Button(action:{
                                isCountDown.toggle()
                                countDownTime = 30
                                countDown = countDownTime * 60
                            } ){
                                ZStack(){
                                    Rectangle()
                                        .frame(width:bouns.width / 6,height: 60)
                                        .foregroundColor(.gray)
                                        .cornerRadius(30.0)
                                    Text ("30")
                                        .font(.system(size: 40, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                            }
                            Button(action:{
                                isCountDown.toggle()
                                countDownTime = 15
                                countDown = countDownTime * 60
                            } ){
                                ZStack(){
                                    Rectangle()
                                        .frame(width:bouns.width / 6,height: 60)
                                        .foregroundColor(.gray)
                                        .cornerRadius(30.0)
                                    Text ("15")
                                        .font(.system(size: 40, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                            }
                            Button(action:{
                                isCountDown.toggle()
                                countDownTime = 5
                                countDown = countDownTime * 60
                            } ){
                                ZStack(){
                                    Rectangle()
                                        .frame(width:bouns.width / 6,height: 60)
                                        .foregroundColor(.gray)
                                        .cornerRadius(30.0)
                                    Text ("5")
                                        .font(.system(size: 40, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                    }.frame(width:bouns.width,height: 60)
                }
                .padding()
            }
        }.onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                
                self.nowDate = Date()
                dateText = "\(dateFormatter1.string(from: nowDate))"

                curHour = dateFormatter4.string(from: nowDate)
                nextHour = String(format: "%02d", (Int(curHour) ?? 0)+1)
                
                let mm = Double(dateFormatter5.string(from: nowDate))
                progressValue = Double(mm! / 60.0)
                
                ss = dateFormatter6.string(from: nowDate)
                
                /* 時報（0分0秒）処理 */
                let dss = Double(dateFormatter6.string(from: nowDate))!
                var isSignal = false
                if mm == 0.0 && dss == 0.0{
                    isSignal.toggle()
                }
                if isSignal{
                    if !isMute {
                        musicplayer.musicPlayer(musicFile: "signal")
                    }
                    isSignal.toggle()
                }
                
                /* マナーモード時の対応 */
                if mm == 0.0 && dss < 10 {
                    bgColorFlg.toggle()
                    changeBgColor(b: bgColorFlg)
                }
                
                /* タイマー機能 */
                if isCountDown {
                    count += 1
                    /* タイマー時間内なら */
                    if (count < countDown) {
                        timeLeft = countDown - count
                        countDonwTimeProgress = Double(count) / Double(countDown)
                    }
                    /* 設定時間になった際に音を鳴らす */
                    if count  == countDown {
                        if  !isMute {
                            musicplayer.musicPlayer(musicFile: "timer")
                        }
                    }
                    /* カウントダウンが終わっても10秒間画面を点滅させる */
                    if countDown <  count && count < countDown + 9 {
                        bgColorFlg.toggle()
                        changeBgColor(b: bgColorFlg)
                    }
                    /* 10秒後にはとめる */
                    if count == countDown + 10 {
                        count = 0
                        isCountDown.toggle()
                        changeBgColorMute(b: isMute)
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
