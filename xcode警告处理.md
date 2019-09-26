### xcode警告处理

#### 设置

build settings -> other warning flags

#### 设置值

-Wno-deprecated-declarations -Wno-unguarded-availability -Wno-implicit-retain-self -Wno-strict-prototypes -Wno-documentation -Wno-nullability-completeness -Wno-deprecated-implementations -Wno-protocol -Wno-objc-protocol-property-synthesis

#### 含义

-Wno-deprecated-declarations
方法弃用警告

-Wno-unguarded-availability 
废弃的api

-Wno-implicit-retain-self 
循环引用

-Wno-strict-prototypes 
协议

-Wno-documentation 
文档注释

-Wno-nullability-completeness
参数非空判断

-Wno-deprecated-implementations
协议未实现

-Wno-protocol

-Wno-objc-protocol-property-synthesis


