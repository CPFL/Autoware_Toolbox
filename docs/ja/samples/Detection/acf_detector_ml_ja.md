# AcfDetector.m の利用例

## 1. Autoware の起動
Autoware を実行して ROS マスターを起動します。  
![](images/run_autoware.png)  

Runtime Manager が立ち上がります。  
![](images/runtime_manager.png)

## 2. rviz の起動
Runtime Manager の RViz ボタンをクリックして rviz を起動します。  
![](images/AcfDetector/click_rviz.png)

## 3. imageViewerPlugin の表示
rviz が起動したら、メニューの［Panels］-［Add New Panel］を選択します。  
![](images/AcfDetector/add_new_pannel.png)

起動した画面で「imageViewerPlugin」を選択します。  
![](images/AcfDetector/select_image_viewer_plugin.png)  

imageViewerPlugin 画面のサイズを調整します。
例えば、下図のように imageViewerPlugin 画面をフローティング状態にします。  
![](images/AcfDetector/move_image_viewer.png)

その後、画面サイズを調整します。  
![](images/AcfDetector/resize_image_viewer.png)

## 4. 動画再生する rosbag ファイルの設定
Runtime Manager の Simulation タブを開きます。
「Ref」ボタンをクリックして、再生する rosbag ファイルを設定します。  
![](images/set_rosbag.png)

## 5. MATLAB から Autoware（ROS マスター）への接続
MATLAB で rosinit コマンドを使用して ROS マスターに接続します。
rosinit の引数はご自身の環境に合わせて設定してください。  
```MATLAB
rosinit();
```  

## 6. AcfDetector.m の起動
AcfDetector.m クラスファイルがあるフォルダを MATLAB 検索パスに登録後、
AcfDetector のインスタンスを生成し、人物検出処理を実行します。  
```MATLAB
acf_detector_folder = fullfile(autoware.getRootDirectory(), ...
                        'benchmark', 'computing', 'perception', 'detection', ...
                        'vision_detector', 'acf_detector');
addpath(acf_detector_folder);
acf_detector_obj = AcfDetector();
``` 

## 7. rosbag の再生（Runtime Manager の Simulation タブ）
「Play」ボタンをクリックしてrosbag を再生します。  
![](images/AcfDetector/play_simulation.png)

## 8. imageViewerPlugin の Topic 設定
1. imageViewerPlugin の Image Topic を「/image_raw」に設定します。
1. imageViewerPlugin の Object Rect Topic を「/detection/vision_objects」に設定します。
1. 人物を検出すると Boundary Box が表示されます。  

![](images/AcfDetector/detect_people.png)  
上図は、書籍「[Autoware 自動運転ソフトウェア入門](http://www.ric.co.jp/book/contents/book_1187.html) 」で提供されるサンプルデータを利用しています。  
本サンプル実行時のノードグラフを表示するには、[ここ](images/AcfDetector/rosgraph_acf_detector.png) をクリックしてください。  
AcfDetector.m で生成されたノードは **/acf_detector_ml** です。

## 9. 終了処理
下記のコマンドを実行して終了します。  
```MATLAB
acf_detector_obj.delete();
rosshutdown();
rmpath(acf_detector_folder);
clear acf_detector_obj acf_detector_folder;
```