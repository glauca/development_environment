### Git 工具

#### 选择修订版本

```bash
$ git log --abbrev-commit --pretty=oneline
$ git log [version]

分支引用
$ git log [branch]

Git 探测工具
$ git show [branch]

引用日志 [只存在于本地仓库]
$ git reflog
$ git show HEAD@{5}
$ git show master@{yesterday}

祖先引用
$ git show HEAD^
$ git show [version]^
$ git show [version]^^
$ git show [version]~3
$ git show HEAD~3^2

提交区间
$ git log [log not in branch]..[log in branch]
$ git log origin/master..HEAD
==
$ git log origin/master..

$ git log refA..refB
$ git log ^refA refB
$ git log refB --not refA

$ git log refA refB ^refC
$ git log refA refB --not refC

被两个引用中的一个包含但又不被两者同时包含的提交
$ git log master...[branch]
$ git log --left-right master...[branch]
```

> 关于 SHA-1 的简短说明

> 许多人觉得他们的仓库里有可能出现两个 SHA-1 值相同的对象。 然后呢？

> 如果你真的向仓库里提交了一个跟之前的某个对象具有相同 SHA-1 值的对象，Git 发现仓库里已经存在了拥有相同 HASH 值的对象，就会认为这个新的提交是已经被写入仓库的。 如果之后你想检出那个对象时，你将得到先前那个对象的数据。

> 但是这种情况发生的概率十分渺小。 SHA-1 摘要长度是 20 字节，也就是 160 位。 280 个随机哈希对象才有 50% 的概率出现一次冲突 （计算冲突机率的公式是 p = (n(n-1)/2) * (1/2^160)) ）。280 是 1.2 x 10^24 也就是一亿亿亿。 那是地球上沙粒总数的 1200 倍。

> 举例说一下怎样才能产生一次 SHA-1 冲突。 如果地球上 65 亿个人类都在编程，每人每秒都在产生等价于整个 Linux 内核历史（360 万个 Git 对象）的代码，并将之提交到一个巨大的 Git 仓库里面，这样持续两年的时间才会产生足够的对象，使其拥有 50% 的概率产生一次 SHA-1 对象冲突。 这要比你编程团队的成员同一个晚上在互不相干的意外中被狼袭击并杀死的机率还要小。

#### 交互式暂存

```bash
$ git add -i
```

#### 储藏与清理

```bash
$ git stash
$ git stash --all
$ git stash list
$ git stash apply
$ git stash apply stash@{2}
$ git stash apply --index

$ git stash drop stash@{0}

$ git stash pop

不要储藏任何通过 git add 命令已暂存的东西
$ git stash --keep-index

储藏未跟踪文件
$ git stash --include-untracked
$ git stash -u

从储藏创建一个分支
$ git stash branch [branch name]

清理工作目录
$ git clean -f -d 移除工作目录中所有未追踪的文件以及空的子目录
$ git clean -d -n 做一次演习 将要 移除什么
$ git clean -n -d -x
$ git clean -x -i
```
#### 签署工作
(签署工作)[https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work]

#### 搜索

```bash
$ git grep -n [keyword]
$ git grep --count [keyword]
$ git grep -p [keyword] *.c
$ git grep -n  --heading --break [keyword]

日志搜索
$ git log -S ZLIB_BUF_MAX --oneline
$ git log -G [Regexp]

行日志搜索
$ git log -L :git_deflate_bound:zlib.c
$ git log -L '/unsigned long git_deflate_bound/',/^}/:zlib.c
```

#### 重写历史

```bash
$ git commit --amend

$ git rebase -i HEAD~3
```

核武器级选项：filter-branch

```bash
从每一个提交移除一个文件
$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD

使一个子目录做为新的根目录
$ git filter-branch --subdirectory-filter trunk HEAD
```

#### 重置揭密

```bash
移动 HEAD 不会改变索引和工作目录
$ git reset --soft

更新索引 回滚到了所有 git add 和 git commit 的命令执行之前 [默认行为]
$ git reset --mixed

更新工作目录 撤销最后的提交 git add 和 git commit 命令以及工作目录中的所有工作
$ git reset --hard

$ git reset [version] [filename]

$ git reset --soft HEAD~2
$ git commit
```

#### 高级合并

```bash
$ git merge --abort

忽略空白
$ git merge -X ignore-all-space [branch]
$ git merge -X ignore-space-change [branch]

手动文件再合并
> Git 在索引中存储了所有这些版本，在 “stages” 下每一个都有一个数字与它们关联。 Stage 1 是它们共同的祖先版本，stage 2 是你的版本，stage 3 来自于 MERGE_HEAD，即你将要合并入的版本（“theirs”）。
$ git show :1:hello.rb > hello.common.rb
$ git show :2:hello.rb > hello.ours.rb
$ git show :3:hello.rb > hello.theirs.rb

$ git merge-file -p hello.ours.rb hello.common.rb hello.theirs.rb > hello.rb

$ git diff --ours
$ git diff --theirs -b
$ git diff --base -b
$ git clean -f

其他类型的合并
$ git merge -X ours [branch]
$ git merge -s ours [branch]
```

