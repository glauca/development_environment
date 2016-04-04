### Git ����

#### ѡ���޶��汾

```bash
$ git log --abbrev-commit --pretty=oneline
$ git log [version]

��֧����
$ git log [branch]

Git ̽�⹤��
$ git show [branch]

������־ [ֻ�����ڱ��زֿ�]
$ git reflog
$ git show HEAD@{5}
$ git show master@{yesterday}

��������
$ git show HEAD^
$ git show [version]^
$ git show [version]^^
$ git show [version]~3
$ git show HEAD~3^2

�ύ����
$ git log [log not in branch]..[log in branch]
$ git log origin/master..HEAD
==
$ git log origin/master..

$ git log refA..refB
$ git log ^refA refB
$ git log refB --not refA

$ git log refA refB ^refC
$ git log refA refB --not refC

�����������е�һ���������ֲ�������ͬʱ�������ύ
$ git log master...[branch]
$ git log --left-right master...[branch]
```

> ���� SHA-1 �ļ��˵��

> ����˾������ǵĲֿ����п��ܳ������� SHA-1 ֵ��ͬ�Ķ��� Ȼ���أ�

> ����������ֿ����ύ��һ����֮ǰ��ĳ�����������ͬ SHA-1 ֵ�Ķ���Git ���ֲֿ����Ѿ�������ӵ����ͬ HASH ֵ�Ķ��󣬾ͻ���Ϊ����µ��ύ���Ѿ���д��ֿ�ġ� ���֮���������Ǹ�����ʱ���㽫�õ���ǰ�Ǹ���������ݡ�

> ����������������ĸ���ʮ����С�� SHA-1 ժҪ������ 20 �ֽڣ�Ҳ���� 160 λ�� 280 �������ϣ������� 50% �ĸ��ʳ���һ�γ�ͻ �������ͻ���ʵĹ�ʽ�� p = (n(n-1)/2) * (1/2^160)) ����280 �� 1.2 x 10^24 Ҳ����һ�����ڡ� ���ǵ�����ɳ�������� 1200 ����

> ����˵һ���������ܲ���һ�� SHA-1 ��ͻ�� ��������� 65 �ڸ����඼�ڱ�̣�ÿ��ÿ�붼�ڲ����ȼ������� Linux �ں���ʷ��360 ��� Git ���󣩵Ĵ��룬����֮�ύ��һ���޴�� Git �ֿ����棬�������������ʱ��Ż�����㹻�Ķ���ʹ��ӵ�� 50% �ĸ��ʲ���һ�� SHA-1 �����ͻ�� ��Ҫ�������Ŷӵĳ�Աͬһ�������ڻ�����ɵ������б���Ϯ����ɱ���Ļ��ʻ�ҪС��

#### ����ʽ�ݴ�

```bash
$ git add -i
```

#### ����������

```bash
$ git stash
$ git stash --all
$ git stash list
$ git stash apply
$ git stash apply stash@{2}
$ git stash apply --index

$ git stash drop stash@{0}

$ git stash pop

��Ҫ�����κ�ͨ�� git add �������ݴ�Ķ���
$ git stash --keep-index

����δ�����ļ�
$ git stash --include-untracked
$ git stash -u

�Ӵ��ش���һ����֧
$ git stash branch [branch name]

������Ŀ¼
$ git clean -f -d �Ƴ�����Ŀ¼������δ׷�ٵ��ļ��Լ��յ���Ŀ¼
$ git clean -d -n ��һ����ϰ ��Ҫ �Ƴ�ʲô
$ git clean -n -d -x
$ git clean -x -i
```
#### ǩ����
(ǩ����)[https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work]

#### ����

```bash
$ git grep -n [keyword]
$ git grep --count [keyword]
$ git grep -p [keyword] *.c
$ git grep -n  --heading --break [keyword]

��־����
$ git log -S ZLIB_BUF_MAX --oneline
$ git log -G [Regexp]

����־����
$ git log -L :git_deflate_bound:zlib.c
$ git log -L '/unsigned long git_deflate_bound/',/^}/:zlib.c
```

#### ��д��ʷ

```bash
$ git commit --amend

$ git rebase -i HEAD~3
```

��������ѡ�filter-branch

```bash
��ÿһ���ύ�Ƴ�һ���ļ�
$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD

ʹһ����Ŀ¼��Ϊ�µĸ�Ŀ¼
$ git filter-branch --subdirectory-filter trunk HEAD
```

#### ���ý���

```bash
�ƶ� HEAD ����ı������͹���Ŀ¼
$ git reset --soft

�������� �ع��������� git add �� git commit ������ִ��֮ǰ [Ĭ����Ϊ]
$ git reset --mixed

���¹���Ŀ¼ ���������ύ git add �� git commit �����Լ�����Ŀ¼�е����й���
$ git reset --hard

$ git reset [version] [filename]

$ git reset --soft HEAD~2
$ git commit
```

#### �߼��ϲ�

```bash
$ git merge --abort

���Կհ�
$ git merge -X ignore-all-space [branch]
$ git merge -X ignore-space-change [branch]

�ֶ��ļ��ٺϲ�
> Git �������д洢��������Щ�汾���� ��stages�� ��ÿһ������һ�����������ǹ����� Stage 1 �����ǹ�ͬ�����Ȱ汾��stage 2 ����İ汾��stage 3 ������ MERGE_HEAD�����㽫Ҫ�ϲ���İ汾����theirs������
$ git show :1:hello.rb > hello.common.rb
$ git show :2:hello.rb > hello.ours.rb
$ git show :3:hello.rb > hello.theirs.rb

$ git merge-file -p hello.ours.rb hello.common.rb hello.theirs.rb > hello.rb

$ git diff --ours
$ git diff --theirs -b
$ git diff --base -b
$ git clean -f

�������͵ĺϲ�
$ git merge -X ours [branch]
$ git merge -s ours [branch]
```

