# pure_pursuit_sl.slx の利用例
## 1. Autoware の起動
Autoware を実行して ROS マスターを起動します。    
![autoware](../images/run_autoware.png)  

Runtime Manager が立ち上がります。  
![runtime_manager](../images/runtime_manager.png)  

## 2. Runtime Manager の Setup タブ内の設定
車両モデルをロードします。  
![setup_tab_load_vehicle_model](../images/setup_tab_load_vehicle_model.png)  

## 3. Runtime Manager の Map タブ内の設定
Vector Map と TF を読み込みます。  
![map_tab_load_vectormap_tf](../images/map_tab_load_vectormap_tf.png)  

## 4. rviz の起動
Runtime Manager の RViz ボタンをクリックして rviz を起動します。  
![click_rviz](../images/click_rviz.png)  

rviz が起動したら、メニューから［File］-［Open Config］を選択します。  
![rviz_file_open_config](../images/rviz_file_open_config.png)

ファイル選択画面で「~/Autoware/ros/src/.config/rviz/default.rviz」を選択します。  
![choose_file_to_open](../images/choose_file_to_open.png)

Config 設定後、rviz 画面には Vector Map が表示されます。  
![show_vectormap](../images/show_vectormap.png)

## 5. Runtime Manager の Computing タブ内の設定
(1) waypoint_loader の app をクリックして、経路が保存されている csv ファイルを指定します。  
![waypoint_loader](../images/waypoint_loader.png)  
ファイルを指定したら、Computing タブ内の waypoint_loader のチェックボックスにチェックを入れます。  

(2) vel_pose_connect の app をクリックして、「Simulation Mode」にチェックを入れます。  
![vel_pose_connect](images/vel_pose_connect.png)  
Simulation Mode 設定後、Computing タブ内の vel_pose_connect のチェックボックスにチェックを入れます。    

(3) wf_simulator の app をクリックして、「Initialize Source」を「Rviz」に設定します。  
![wf_simulator_app](images/pure_pursuit/wf_simulator_app.png)  
「Initialize Source」を「Rviz」に設定後、Computing タブ内の wf_simulator のチェックボックスにチェックを入れます。

(4) lane_rule、lane_stop、lane_select、obstacle_avoid、velocity_set、twist_filter、wf_simulator のチェックボックスにチェックを入れて、これらのノードを起動します。
設定後の Computing タブは下図のようになります。  
![computing_tab](images/pure_pursuit/computing_tab.png)

## 6. MATLAB から Autoware（ROS マスター）への接続
MATLAB で rosinit コマンドを使用して ROS マスターに接続します。
rosinit の引数はご自身の環境に合わせて設定してください。
```MATLAB
rosinit();
```  
![rosinit](../images/rosinit.png)

## 7. Simulink で作成した pure_pursuit を起動
pure_pursuit の Simulink モデルがあるフォルダをMATLAB検索パスに登録後、pure_pursuit の Simulink モデルを開きます。
```MATLAB
pure_pursuit_folder = fullfile(autoware.getRootDirectory(), ...
                        'benchmark', 'computing', 'planning', 'motion', 'waypoint_follower', 'pure_pursuit');
addpath(pure_pursuit_folder);
model = 'pure_pursuit_sl';
open_system(model);
```  
![pure_pursuit_sl_top](images/pure_pursuit/pure_pursuit_sl_top.png)
 
## 8. Simulink で作成した pure_pursuit を実行
pure_pursuit の Simulink モデルを実行します。  
```MATLAB
set_param(model, 'SimulationCommand', 'Start');
```

## 8. rviz で車両の初期位置を設定
 (1) rviz の「2D Pose Estimate」をクリックします。
 (2) その後、車両の初期位置から移動方向にマウスドラッグして矢印を設定します。

![](images/2D_Pose_Estimate.png)

<html><br></html>

## 9. 経路追従の開始
rviz で初期位置を設定後しばらくすると、経路追従が始まります。  
![result_waypoint_follower](images/result_waypoint_follower.png)

本例実行時のノードグラフを確認するには 
[ここ](./images/pure_pursuit/rosgraph_pure_pursuit.png) をクリックしてください。
pure_pursuit_sl で生成されたノードは /pure_pursuit_sl_81473 です。

## 10. 終了処理
下記のコマンドを実行して終了します。  
```MATLAB
set_param(model, 'SimulationCommand', 'Stop');
close_system(model);
rosshutdown();
rmpath(pure_pursuit_folder);
clear('model', 'pure_pursuit_folder');
```
---
## Demo Video
[![How to use pure_pursuit_sl.slx](https://i.ytimg.com/vi/C1ay6RXpXGo/hqdefault.jpg)](https://youtu.be/C1ay6RXpXGo)