### Git 基础

#### 获取 Git 仓库

使用现有项目或目录导入到Git

```bash
$ git init
$ git add *
$ git commit -m 'initial'
```
从服务器克隆Git仓库

```bash
$ git clone [url] [dirname]
```

#### git status

```bash
$ git status
$ git add [filename]
$ git add [dirname]

暂存区状态概览
$ git status -s
$ git status --short
```

#### git diff

````bash
查看修改之后**还没有暂存**起来的变化
$ git diff [filename]

查看已暂存的将要添加到下次提交里的内容
$ git diff --cached [filename]
$ git diff --staged [filename]
````

#### git difftool [vimdiff]
#### git difftool --tool -help

#### git commit
#### git commit -m 'commit description'
#### git commit -a -m 'commit description'

#### git rm

```bash
$ git rm [filename]

如果删除之前修改过并且**已经放到暂存区域**的话
$ git rm -f [filename]

让文件保留在磁盘，但是并不想让 Git 继续跟踪
$ git rm --cached [filename]
```

#### git mv [filename] [new filename]

.gitignore 文件 [@See Github](https://github.com/github/gitignore)

1. 所有空行或者以 ＃ 开头的行都会被 Git 忽略。
2. 可以使用标准的 glob 模式匹配。
3. 匹配模式可以以（/）开头防止递归。
4. 匹配模式可以以（/）结尾指定目录。
5. 要忽略指定模式以外的文件或目录，可以在模式前加上惊叹号（!）取反。

```bash
# no .a files
*.a

# but do track lib.a, even though you're ignoring .a files above
!lib.a

# only ignore the TODO file in the current directory, not subdir/TODO
/TODO

# ignore all files in the build/ directory
build/

# ignore doc/notes.txt, but not doc/server/arch.txt
doc/*.txt

# ignore all .pdf files in the doc/ directory
doc/**/*.pdf
```

#### git log

```bash
$ git log

每次提交的内容差异
$ git log -p -1

每次提交的简略的统计信息
$ git log --stat - 1

格式化显示日志
$ git log -1 --pretty=oneline
$ git log -1 --pretty=short
$ git log -1 --pretty=full
$ git log -1 --pretty=fuller
$ git log -1 --pretty=format:"%h - %an, %ar : %s"
$ git log -10 --date=format:%c --pretty=format:"%h - %an, %ar %cd %s"
$ git log -10 --date=format:%c --pretty=format:"%h - %an, %ar %cd %s" --graph

查询条件限制
$ git log --since=2.weeks
$ git log --after=2.weeks
$ git log --before=2.weeks
$ git log --until=2.weeks
$ git log --author=[user]
$ git log --grep=[commit keyword]
$ git log --all-match=[user || commit keyword]
```