# flutter_ho

A new Flutter application.
一个flutter项目,包括  
权限申请  
升级弹框  
视频播放  
视频列表  
Stream使用,多订阅流的使用  
闪屏页  
引导页  
自己封装路由  
日志Util  
对话框  
数据持久化保存
倒计时  
视频设置滑块  
视频快进
网络请求的封装


# Align
- Align 组件可以调整子组件的位置，并且可以根据子组件的宽高来确定自身的的宽高
- alignment : 需要一个AlignmentGeometry类型的值，表示子组件在父组件中的起始位置。AlignmentGeometry 是一个抽象类，它有两个常用的子类：Alignment和 FractionalOffset
- widthFactor和heightFactor是用于确定Align 组件本身宽高的属性；它们是两个缩放因子，会分别乘以子元素的宽、高，最终的结果就是Align 组件的宽高。如果值为null，则组件的宽高将会占用尽可能多的空间。
#### Alignment
Widget会以矩形的中心点作为坐标原点  
Alignment可以通过其坐标转换公式将其坐标转为子元素的具体偏移坐标：  
(Alignment.x*childWidth/2+childWidth/2, Alignment.y*childHeight/2+childHeight/2)
#### FractionalOffset
FractionalOffset 继承自 Alignment，它和 Alignment唯一的区别就是坐标原点不同！FractionalOffset 的坐标原点为矩形的左侧顶点  
坐标转换公式为：  
实际偏移 = (FractionalOffse.x * childWidth, FractionalOffse.y * childHeight)



# Flutter组件精讲
Skia 是个2D向量图形处理函数库,包含字符,坐标转换,以及点阵图都有高效能且简洁的表现.不仅用于Google Chrome浏览器,Android开放手机平台也是采用skia作为绘图处理,搭配OpenGL/ES与特定的硬件特征,强化显示的效果.  
Skia Graphics Library（SGL）是一个由C++编写的开放源代码图形库，最初由Skia公司开发，被Google收购后以New BSD License许可下开源。    

## android 沉淀 - 渲染原理
- WindowManagerService - 单独的系统进程，专门管理所有 UI window 的排版，位置，显示问题，像输入法弹出来就是  WindowManagerService 控制的
- ActivityManagerService - 单独的系统进程，专门负责 android 4大组件的创建和运行，像 Activity，service 生命周期的调度都是由 ActivityManagerService 管理的
- ServiceManage - 单独的系统进程，虽然名字最后没有Service，但这也是个系统进程，是 android 系统第一个启动的系统进程，负责 IPC 跨进程通信，保存有所有进程的 binder 通信地址，ServiceManage 进程的 binder 通信地址是固定的，是为了能与所有的进程通信，binder 通信地址统一都是 0
- Surface Flinger - 单独的系统进程，负责 2D 渲染，生成最终的帧，直接操作硬件驱动在屏幕上显示
- Surface - 可以看成一块显存，任由 canvas 在上面作画
- WindowManager - app 进程内是唯一的，用来和 WindowManagerService 通信，记录管理 app 内所有的 Window
- Window - 系统层面抽象的界面单元，每一个 Activiyt 对应一个 Window


## MaterialApp主题  
1.设置App-ThemeData的样式  
![Material ThemeData的设置](assets\widget\material.png)

2.设置AppBarTheme的样式  
![ThemeData AppBarTheme的设置](assets\widget\appbar_theme.png)

3.设置IconThemeData的样式  
![ThemeData IconThemeData的设置](assets\widget\icontheme.png)

4.设置ButtonThemeData的样式  
![ThemeData ButtonThemeData的设置](assets\widget\buttontheme.png)

5.设置Scaffold 悬浮按钮FloatinActionButton的样式  
![Scaffold FloatinActionButton的设置](assets\widget\floating_action_button.png)

6.设置Scaffold 悬浮按钮位置FloatinActionButtonLocation属性  
![Scaffold FloatinActionButtonLocation的设置](assets\widget\floating_action.png)

Container 有子Widget时,没有设置高度时会包裹子Widget的高度

7.设置Scaffold 悬浮按钮位置TabBar属性  
![Scaffold TabBar的设置](assets\widget\tabbar1.png)  
![Scaffold TabBar的设置](assets\widget\tabbar2.png)


8.设置Text 属性  
![Text的设置](assets\widget\text1.png)  
![Text的设置](assets\widget\text2.png)

9.设置Text TextStyle属性  
![Text  TextStyle的设置](assets\widget\textstyle1.png)  
![Text  TextStyle的设置](assets\widget\textstyle2.png)

