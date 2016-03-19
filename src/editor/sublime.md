# Sublime Text 3 配置文档 #

### 下载 [Windows 64 bit Portable Version](https://download.sublimetext.com/Sublime%20Text%20Build%203103%20x64.zip) ###

import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read())

常用扩展

1. [JsFormat](https://packagecontrol.io/packages/JsFormat)
2. [PHPDocument](https://packagecontrol.io/packages/phpDocumentor) && [DocBlockr](https://packagecontrol.io/packages/DocBlockr)
3. [Trimmer] && [Trailing Spaces]
4. [Alignment]
5. [Git]
6. [ColorPicker]
7. [Soda Theme]
8. [FileDiffs]
9. [phpfmt](https://packagecontrol.io/packages/phpfmt)
10. [tag]【Ctrl+Alt+F】
11. [Markdown Preview]【Ctrl+b】
12. [Emmet]
13. [html-css-js prettify]【需要node.js】
14. [Http Requester]
15. [Golang]
16. [PHP Getters and Setters]
17. [PHP Companion]

Sublime Text 3 配置

```bash
{
	"color_scheme": "Cache/Theme - Soda/Monokai Soda.tmTheme",
	"default_line_ending": "unix",
	"file_exclude_patterns":
	[
		"*.gitignore",
		"*.gitattributes",
		"*.gitkeep"
	],
	"font_size": 9,
	"ignored_packages":
	[
		"Vintage"
	],
	"rulers":
	[
		100
	],
	"soda_classic_tabs": true,
	"soda_folder_icons": true,
	"theme": "Soda Dark 3.sublime-theme",
	"translate_tabs_to_spaces": true,
	"trim_trailing_white_space_on_save": true,
	"word_wrap": true,
	"wrap_width": 100
}
```

phpfmt 配置项

```bash
{
	"debug": true,
	"enable_auto_align": true,
	"format_on_save": true,
	"generate_phpdoc": true,
	"indent_with_space": true,
	"passes":
	[
		"AlignPHPCode",
		"ReindentSwitchBlocks"
	],
	"php_bin": "E:\\software\\php-5.6.19-Win32-VC11-x64\\php.exe",
	"psr1": true,
	"psr2": true,
	"version": 4
}

```
