# Sublime Text 3 配置文档 #

### 下载 [Windows 64 bit Portable Version](https://download.sublimetext.com/Sublime%20Text%20Build%203103%20x64.zip) ###

import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read())

常用扩展

1. [JsFormat](https://packagecontrol.io/packages/JsFormat)
1. [PHPDocument](https://packagecontrol.io/packages/phpDocumentor) && [DocBlockr](https://packagecontrol.io/packages/DocBlockr)
1. [Trimmer](https://packagecontrol.io/packages/Trimmer) && [Trailing Spaces](https://packagecontrol.io/packages/TrailingSpaces)
1. [Alignment](https://packagecontrol.io/packages/Alignment)
1. [Git]
1. [ColorPicker]
1. [Soda Theme](https://packagecontrol.io/packages/Theme%20-%20Soda) Download [colour-schemes.zip](http://buymeasoda.github.com/soda-theme/extras/colour-schemes.zip)
1. [Material Theme](https://packagecontrol.io/packages/Material%20Theme)
1. [FileDiffs](https://packagecontrol.io/packages/FileDiffs)
1. [phpfmt](https://packagecontrol.io/packages/phpfmt)
1. [tag](https://packagecontrol.io/packages/Tag) 【Ctrl+Alt+F】
1. [Markdown Preview](https://packagecontrol.io/packages/Markdown%20Preview) 【Ctrl+b】
1. [Emmet](https://packagecontrol.io/packages/Emmet)
1. [html-css-js prettify](https://packagecontrol.io/packages/HTML-CSS-JS%20Prettify)【需要node.js】
1. [Http Requester](https://packagecontrol.io/packages/Http%20Requester)
1. [Golang](https://packagecontrol.io/packages/GoSublime)
1. [PHP Getters and Setters](https://packagecontrol.io/packages/PHP%20Getters%20and%20Setters)
1. [PHP Companion](https://packagecontrol.io/packages/PHP%20Companion)
1. [OmniMarkupPreviewer](https://packagecontrol.io/packages/OmniMarkupPreviewer)

Sublime Text 3 Settings - User

```bash
{
	"always_show_minimap_viewport": true,
	"bold_folder_labels": true,
	"color_scheme": "Packages/Material Theme/schemes/Material-Theme.tmTheme",
	"default_line_ending": "unix",
	"file_exclude_patterns":
	[
	],
	"font_size": 9,
	"ignored_packages":
	[
		"Vintage"
	],
	"indent_guide_options":
	[
		"draw_normal",
		"draw_active"
	],
	"line_padding_bottom": 1,
	"line_padding_top": 1,
	"material_theme_contrast_mode": true,
	"overlay_scroll_bars": "enabled",
	"php_bin": "E:\\software\\php-5.6.19-Win32-VC11-x64\\php.exe",
	"rulers":
	[
		100
	],
	"soda_classic_tabs": true,
	"soda_folder_icons": true,
	"theme": "Material-Theme.sublime-theme",
	"translate_tabs_to_spaces": true,
	"trim_trailing_white_space_on_save": true,
	"word_wrap": true,
	"wrap_width": 100
}

```

Sublime Text 3 Key Bindings - User

```bash
[
    { "keys": ["f6"], "command": "find_use" },
    { "keys": ["f7"], "command": "expand_fqcn" }
]
```

phpfmt Settings - User

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

Golang Settings - User

```bash
{
    "env": {
        "GOPATH": "F:/git/golang",
        "GOROOT": "C:/Go"
    }
}
```

OmniMarkupPreviewer

```bash
{
    "renderer_options-MarkdownRenderer": {
        "extensions": ["tables", "fenced_code", "codehilite"]
    }
}
```

# Sublime Text 2 配置文档 #

import urllib2,os; pf='Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler( ))); open( os.path.join( ipp, pf), 'wb' ).write( urllib2.urlopen( 'http://sublime.wbond.net/' +pf.replace( ' ','%20' )).read()); print( 'Please restart Sublime Text to finish installation')