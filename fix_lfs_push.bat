@echo off
echo Fixing Git LFS push issues...
echo.

rem 1. 禁用LFS锁定验证
echo 1. Disabling LFS locking verification...
git config lfs.https://github.com/Yinlou888/computer-network-course.git/info/lfs.locksverify false
echo.

rem 2. 配置LFS超时时间
echo 2. Configuring LFS timeout settings...
git config --global lfs.dialtimeout 300
git config --global lfs.fetchrecentrefsdays 7
git config --global lfs.fetchrecentcommitsdays 7
echo.

rem 3. 清理LFS缓存
echo 3. Clearing LFS cache...
git lfs prune
echo.

rem 4. 尝试推送，不使用LFS的锁定功能
echo 4. Trying to push without LFS locking...
git push origin main --no-verify
echo.

echo Done! Check the output above for results.