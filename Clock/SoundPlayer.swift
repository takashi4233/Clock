//
//  SoundPlayer.swift
//  CalcCard
//
//  Created by TAKASHI YOSHIMURA on 2022/09/09.
//

import UIKit
import AVFoundation

class SoundPlayer: NSObject {

    var music_player:AVAudioPlayer!

    // 音楽を再生
    func musicPlayer(musicFile:String){
        do{
            let music_data=NSDataAsset(name: musicFile)!.data   // 音源の指定
            music_player=try AVAudioPlayer(data:music_data)   // 音楽を指定
            music_player.play()   // 音楽再生
        }catch{
            print("エラー発生.音を流せません")
        }
    }

    // 音楽を停止
    func stopAllMusic (){
        music_player?.stop()
    }
}
