# 第一阶段：构建阶段
FROM python:3.11-slim AS builder

# 设置工作目录
WORKDIR /app

# 安装构建依赖
RUN apt-get update && apt-get install -y libmagic1 && \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 复制并安装 Python 依赖
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# 第二阶段：运行阶段
FROM python:3.11-slim

# 创建一个非root用户
RUN useradd -m appuser

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 安装运行时依赖（如果有）
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 复制已安装的 Python 包
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# 复制应用程序代码
COPY . .

# 更改文件所有权并切换到非root用户
RUN chown -R appuser:appuser /app
USER appuser

# 暴露端口
EXPOSE 5000

# 使用 Gunicorn 作为 WSGI 服务器运行 Flask 应用
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app", "--workers", "4"]
