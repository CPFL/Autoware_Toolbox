# vel_pose_connect_sl.slx の利用例

## 1. Autoware の起動
Autoware を実行して ROS マスターを起動します。  
![run_autoware](../images/run_autoware.png)  

Runtime Manager が立ち上がります。  
![runtime_manager](../images/runtime_manager.png)  
<html><br></html>

## 2. Runtime Manager の Setup タブ内の設定
車両モデルをロードします。  
![setup_tab_load_vehicle_model](../images/setup_tab_load_vehicle_model.png)  
<html><br></html>

## 3. Runtime Manager の Map タブ内の設定
Vector Map と TF を読み込みます。  
![map_tab_load_vectormap_tf](../images/map_tab_load_vectormap_tf.png)  
<html><br></html>

## 4. rviz の起動
Runtime Manager の RViz ボタンをクリックして rviz を起動します。  
![click_rviz](../images/click_rviz.png)  

rviz が起動したら、メニューから［File］-［Open Config］を選択します。  
![rviz_file_open_config](../images/rviz_file_open_config.png)  

ファイル選択画面で「~/Autoware/ros/src/.config/rviz/default.rviz」を選択します。  
![choose_file_to_open](../images/choose_file_to_open.png)  

Config 設定後、rviz 画面には Vector Map が表示されます。  
![show_vectormap](../images/show_vectormap.png)  
<html><br></html>

## 5. Runtime Manager の Computing タブ内の設定
(1) waypoint_loader の app をクリックして、経路が保存されている csv ファイルを指定します。  
![waypoint_loader](../images/waypoint_loader.png)  
ファイルを指定したら、Computing タブ内の waypoint_loader のチェックボックスにチェックを入れます。

(2) wf_simulator の app をクリックして、「Initialize Source」を「Rviz」に設定します。  
![wf_simulator_app](../images/wf_simulator_app.png)  
「Initialize Source」を「Rviz」に設定後、Computing タブ内の wf_simulator のチェックボックスにチェックを入れます。  

(3) lane_rule、lane_stop、lane_select、obstacle_avoid、velocity_set、pure_pursuit、twist_filter チェックボックスにチェックを入れて、これらのノードを起動します。設定後の Computing タブは下図のようになります。  
![computing_tab](images/vel_pose_connect/computing_tab.png)  
<html><br></html>

## 6. MATLAB から Autoware（ROS マスター）への接続
MATLAB で rosinit コマンドを使用して ROS マスターに接続します。rosinit の引数はご自身の環境に合わせて設定してください。  
```MATLAB  
rosinit('http://169.254.66.185:11311');
```

## 7. Simulink で作成した vel_pose_connect を起動
vel_pose_connect の Simulink モデルがあるフォルダをMATLAB検索パスに登録後、vel_pose_connect の Simulink モデルを開きます。    
```MATLAB  
vel_pose_connect_folder = fullfile(autoware.getRootDirectory(), ...
                        'benchmark', 'computing', 'perception', 'localization', 'autoware_connector', 'vel_pose_connect');
addpath(vel_pose_connect_folder);
model = 'vel_pose_connect_sl';
open_system(model);
```

![](images/vel_pose_connect/vel_pose_connect_sl_top.png)  

## 8. Simulink で作成した vel_pose_connect を実行
vel_pose_connect の Simulink モデルを実行します。  
```MATLAB  
set_param(model, 'SimulationCommand', 'Start');
```

## 9. rviz で車両の初期位置を設定
 (1) rviz の「2D Pose Estimate」をクリックします。  
 (2) その後、車両の初期位置から移動方向にマウスドラッグして矢印を設定します。  
![2D_Pose_Estimate](images/2D_Pose_Estimate.png)  
<html><br></html>

## 10. 経路追従の開始
rviz で初期位置を設定後しばらくすると、経路追従が始まります。  
![result_waypoint_follower](images/result_waypoint_follower.png)  
本例実行時のノードグラフのイメージファイルを確認するには
[ここ](images/vel_pose_connect/sl_rosgraph.png)をクリックしてください。
SVGファイルを確認するには
[ここ](images/vel_pose_connect/sl_rosgraph.svg)をクリックしてください。

## 11. 終了処理
下記のコマンドを実行して終了します。  
```MATLAB    
set_param(model, 'SimulationCommand', 'Stop');
close_system(model);
rosshutdown();
rmpath(vel_pose_connect_folder);
clear('model', 'vel_pose_connect_folder');
```