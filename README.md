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


