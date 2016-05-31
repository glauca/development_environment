## [2.1.1 Which MySQL Version and Distribution to Install](http://dev.mysql.com/doc/refman/5.7/en/which-version.html)

GA (General Availability) releases, also called production or stable releases, are meant for production use. We recommend using the most recent GA release.

 The naming scheme in MySQL 5.7 uses release names that consist of three numbers and an optional suffix; for example, mysql-5.7.1-m1. The numbers within the release name are interpreted as follows:

+ The first number (5) is the major version number.
+ The second number (7) is the minor version number. Taken together, the major and minor numbers constitute the release series number. The series number describes the stable feature set.
+ The third number (1) is the version number within the release series. This is incremented for each new bugfix release. In most cases, the most recent version within a series is the best choice.

Release names can also include a suffix to indicate the stability level of the release. Releases within a series progress through a set of suffixes to indicate how the stability level improves. The possible suffixes are:

+ mN (for example, m1, m2, m3, ...) indicates a milestone number.
+ rc indicates a Release Candidate (RC).
+ Absence of a suffix indicates a General Availability (GA) or Production release.

Development within a series begins with milestone releases, followed by RC releases, and finally reaches GA status releases.