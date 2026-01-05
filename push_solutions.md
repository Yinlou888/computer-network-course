# 解决 Git Push 失败问题

## 问题描述
在执行 `git push origin main` 时遇到错误：
```
fatal: unable to access 'https://github.com/Yinlou888/computer-network-course.git/': Recv failure: Connection was reset
```

## 可能的解决方案

### 1. 检查网络连接
- 确认你的网络连接正常
- 尝试访问 [GitHub.com](https://github.com) 确认网站可访问
- 如果你在使用代理，请确保代理配置正确

### 2. 检查远程仓库URL
```bash
git remote -v
```
确认输出中的URL格式正确，没有多余的空格或字符

### 3. 重新设置远程仓库URL
如果远程URL有问题，可以重新设置：
```bash
git remote set-url origin https://github.com/Yinlou888/computer-network-course.git
```

### 4. 尝试使用SSH协议
如果HTTPS连接不稳定，可以考虑使用SSH协议：
```bash
git remote set-url origin git@github.com:Yinlou888/computer-network-course.git
```
> 注意：需要先在GitHub上配置SSH密钥

### 5. 清理Git缓存
```bash
git gc --prune=now
git remote prune origin
```

### 6. 增加超时时间
```bash
git config --global http.postBuffer 524288000
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999
```

### 7. 尝试使用Git LFS（如果有大文件）
如果你的assets文件夹中有大文件，建议使用Git LFS：
```bash
git lfs install
git lfs track "assets/**/*"
git add .gitattributes
git commit -m "Add Git LFS tracking"
git push origin main
```

### 8. 等待一段时间后重试
有时候GitHub服务器可能暂时不稳定，等待几分钟后重试

## 操作步骤建议
1. 首先检查网络连接
2. 确认远程仓库URL正确
3. 尝试增加超时时间
4. 如果有大文件，配置Git LFS
5. 最后重试推送命令

## 验证修改是否成功
```bash
git status
git log -1
```
确认你的修改已经成功提交，然后再次尝试推送