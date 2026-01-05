# 手动解决 Git LFS 推送问题

## 问题分析
从错误信息来看，有两个主要问题：
1. Remote "origin" does not support the Git LFS locking API
2. 连接超时：无法访问 LFS 验证端点

## 手动执行步骤

### 1. 禁用 LFS 锁定验证
首先，按照错误提示禁用 LFS 锁定验证：
```bash
git config lfs.https://github.com/Yinlou888/computer-network-course.git/info/lfs.locksverify false
```

### 2. 配置 Git LFS 超时设置
增加 LFS 超时时间，避免连接超时问题：
```bash
git config --global lfs.dialtimeout 300
git config --global lfs.fetchrecentrefsdays 7
git config --global lfs.fetchrecentcommitsdays 7
git config --global http.postBuffer 524288000
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999
```

### 3. 清理 Git 和 LFS 缓存
```bash
git gc --prune=now
git lfs prune
git remote prune origin
```

### 4. 尝试不使用 LFS 推送（如果 LFS 配置有问题）
如果 LFS 仍然有问题，可以尝试不使用 LFS 推送，只推送代码修改：
```bash
git push origin main --no-verify --no-ff
```

### 5. 分阶段推送（如果有大量大文件）
如果 assets 文件夹中有大量大文件，可以尝试分阶段推送：
```bash
# 先推送代码修改
git push origin main --no-verify --lfs-standalone-file

# 然后单独推送 LFS 对象
git lfs push origin main
```

### 6. 检查 LFS 跟踪配置
确保 LFS 正确跟踪了需要的文件：
```bash
git lfs track
```

### 7. 验证 LFS 对象
```bash
git lfs ls-files
git lfs status
```

## 可能的替代方案

### 方案 A：临时禁用 LFS
如果 LFS 持续有问题，可以临时禁用 LFS 推送：
```bash
git config --global lfs.enabled false
git push origin main
```

### 方案 B：只推送修改的 HTML 文件
如果主要问题是 LFS 文件太大，可以先只推送修改的 HTML 文件：
```bash
git push origin main --no-verify --follow-tags
```

### 方案 C：使用 Git 浅克隆重新初始化
如果仓库历史太大，可以尝试重新初始化仓库，只保留最近的提交：
```bash
# 在新目录中执行
git clone --depth 1 https://github.com/Yinlou888/computer-network-course.git
cd computer-network-course
# 复制修改后的 index.html 文件到新目录
# 然后提交并推送
git add index.html
git commit -m "Fix media file paths to use relative paths"
git push origin main
```

## 成功标志
当你看到类似以下输出时，表示推送成功：
```
Enumerating objects: XX, done.
Counting objects: 100% (XX/XX), done.
Delta compression using up to X threads.
Compressing objects: 100% (XX/XX), done.
Writing objects: 100% (XX/XX), XX bytes | XX.00 KiB/s, done.
Total XX (delta XX), reused XX (delta XX), pack-reused 0
To https://github.com/Yinlou888/computer-network-course.git
   XXXXXXX..XXXXXXX  main -> main
```

## 后续建议
1. 推送成功后，检查 GitHub Pages 网站是否能正常访问媒体文件
2. 如果仍然有问题，检查 GitHub Pages 的构建日志
3. 对于非常大的媒体文件，考虑使用专门的视频托管服务（如 YouTube、Bilibili），然后在 HTML 中嵌入链接

## 验证修改效果
推送成功后，可以通过以下方式验证：
1. 访问 GitHub 仓库，确认 `index.html` 已更新
2. 访问 GitHub Pages 网站，测试视频、PDF 是否能正常加载
3. 检查浏览器开发者工具的网络面板，确认资源加载状态为 200 OK