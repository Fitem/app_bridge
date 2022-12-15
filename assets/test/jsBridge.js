class JSBridge {
    // H5桥方法文档
    // 说明：桥方法参数、返回值采用纯String来传递，全局桥变量appJsBridge调用桥方法, 初始化加载时候会往localStorage中注入isApp变量返回“true”
    // h5提供全局的isHome()方法用于判定是否是在首页
    // 存在桥，appJsBridge存在则代表原生，nativeBridge存在则代表Flutter
    hasJsBridge() {
        return (window.appJsBridge !== undefined && window.appJsBridge != null) || (window.nativeBridge !== undefined && window.nativeBridge != null)
    }

    // 是否是新的JS桥，有postMessage方法
    isNewJSBridge() {
        return window.nativeBridge != null && window.nativeBridge.postMessage != null
    }

    // 存在桥
    async isApp() {
        // 是否是新的JSBridge
        if (this.isNewJSBridge()) {
            return await window.jsBridgeHelper.sendMessage('isApp', null) === 'true'
        } else {
            return window.appJsBridge && window.appJsBridge.isApp() === 'true'
        }
    }

    // 获取app版本号 返回String
    async getVersionCode() {
        // 是否是新的JSBridge
        if (this.isNewJSBridge()) {
            return await window.jsBridgeHelper.sendMessage('getVersionCode', null)
        } else {
            return window.appJsBridge.getVersionCode()
        }
    }

    // 获取app版本名 返回String
    async getVersionName() {
        // 是否是新的JSBridge
        if (this.isNewJSBridge()) {
            return await window.jsBridgeHelper.sendMessage('getVersionName', null)
        } else {
            return window.appJsBridge.getVersionName()
        }
    }

    // 获取系统版本 返回String
    async getSystemVersion() {
        // 是否是新的JSBridge
        if (this.isNewJSBridge()) {
            return await window.jsBridgeHelper.sendMessage('getSystemVersion', null)
        } else {
            return window.appJsBridge.getSystemVersion()
        }
    }

    getWebValue() {
        // 是否是新的JSBridge
        if (this.isNewJSBridge()) {
          return window.jsBridgeHelper.sendMessage("getWebValue", null);
        } else {
            return window.appJsBridge.getWebValue();
        }
    }
}

const jsBridge = new JSBridge()
window.jsBridge = jsBridge
