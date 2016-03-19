# Sublime Text 3 配置文档 #

### [Windows 64 bit Portable Version]("https://download.sublimetext.com/Sublime%20Text%20Build%203103%20x64.zip") ###

import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read())

常用扩展

1. [JsFormat](JsFormat "https://packagecontrol.io/packages/JsFormat")