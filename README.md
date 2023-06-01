# ROS2
## C++でのpublisher, subscriberの実装
1. パッケージの作成
```sh
ros2 pkg create --build-type ament_cmake パッケージ名
```
2. srcの中にC++コードを記述
・公式ではpackage.xmlのdescription・maintainer・license タグを必ず入力してくださいとあるがおそらくデフォルトで大丈夫・・・？

### package.xml
<buildtool_depend>ament_cmake</buildtool_depend>の下に新しい行を追加して以下の依存関係を追加
```xml
<depend>rclcpp</depend>
<depend>std_msgs</depend>
```
これは、パッケージのコードがビルドされ実行されるときに、パッケージがrclcppとstd_msgsを必要とすることを宣言しています。

### CMakeLists.txt
find_package(ament_cmake REQUIRED)の下に
```
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)
```
必要なものを記述

その下にros2 runを使って実行できるようにtalkerという名前を付ける
```
add_executable(talker src/publisher_member_function.cpp)
ament_target_dependencies(talker rclcpp std_msgs)
```
最後に実行ファイルを見つけられるように、install(TARGETS...)セクションを追加
```
install(TARGETS
  talker
  DESTINATION lib/${PROJECT_NAME})
```

listener側も同様に・・・
```
add_executable(listener src/subscriber_member_function.cpp)
ament_target_dependencies(listener rclcpp std_msgs)

install(TARGETS
  talker
  listener
  DESTINATION lib/${PROJECT_NAME})
```

3. build & 実行
```sh
cd /home/ros2/ros2_ws
colcon build --packages-select cpp_pubsub
. install/setup.bash
```

talkerを実行
```sh
ros2 run cpp_pubsub talker
```
listenerを実行
```sh
ros2 run cpp_pubsub listener
```