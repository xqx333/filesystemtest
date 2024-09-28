## 功能

- **文件上传**：用户可以通过 web 界面上传文件。
- **动态限速**：根据用户配额（`quota` 和 `used_quota`），动态计算上传频率限制。
- **缓存优化**：使用缓存机制减少对认证服务器的请求次数。
- **自动清理**：每天定时清理仓库中过期或冗余文件。
- **手动清理**：支持通过 web 界面对仓库进行手动清理。
- **鉴权选择**：支持用户通过accesstoken和token请求模型两种方式进行鉴权。
- **适配接口**：适配了一个openai格式请求接口，返回上传成功可以和token请求模型的方式配合使用。

## 环境要求

- Python 版本：>= 3.6
- Flask
- Flask-Limiter
- Flask-Caching

## 安装
1. 设置环境变量：

   ```
   GITHUB_USERNAME=your_username 填写github用户名
   GITHUB_REPO=your_repo 填写私人仓库名
   GITHUB_BRANCH=main 填写想使用的分支,默认main
   GITHUB_TOKEN=your_github_token 填写账号的Personal access tokens (classic)
   RELAY_URL=your_relay_url  填写域名
   SECRET_TOKEN=your_secret_token  通过/{SECRET_TOKEN}/test_cleanup访问手动清理页面
   FILE_RETENTION_DAYS=1  自动清理的时间间隔，默认一天
   RELAY_MODEL=fileupload  自定义鉴权模型，默认fileupload
   ```

## 使用方法

1. 启动应用：

2. 访问 web 界面：

   打开浏览器，访问 `http://localhost:5000` 即可进入上传页面。

3. 文件上传：

   - 输入用户 Token。
   - 选择文件，点击上传。

4. 手动清理：

   - 访问 `http://localhost:5000/{SECRET_TOKEN}/test_cleanup`。
   - 选择清理方式（按天数或数量），并执行清理。

## 配置说明

- **限速策略**：每个用户的限速由其 `quota` 和 `used_quota` 动态计算，配置在 `rate_limit` 函数中，请求模型方式不限速，可自行设置模型价格来限制用户。
- **缓存策略**：accesstoken方式默认缓存用户信息 5 分钟，以减少对认证服务器的请求。

## 定时任务

- 定时任务每天凌晨2点执行一次仓库清理，删除超过设定保留天数的文件。可以根据需要调整 `FILE_RETENTION_DAYS` 的参数，改变清理时间和频率。

## 常见问题

### 文件上传失败

确保上传的文件不超过 5MB，并仔细检查输入的 Token 是否有效。

### 手动清理无法访问

确保在 URL 中提供了正确的 `SECRET_TOKEN` 值，以防止未经授权的访问。

## 贡献

欢迎提交问题和请求新的功能，也可以通过提交 PR 贡献代码。

## 许可证

此项目使用 [MIT 许可证](LICENSE) 进行许可。

---

希望这个 README 能帮助您顺利搭建和使用此系统！如果有任何疑问，请随时联系我。
