[ZH](README.md) | [EN](README_EN.md)

# oci-helper

> 一个基于 Oracle OCI SDK 🐢 开发的 web 端可视化甲骨文云助手，目前实现的功能有：批量添加多个租户配置、更改实例配置以及引导卷配置、附加ipv6、安全列表、实时流量查询（分钟级别）、根据多个 CIDR 网段更换实例公共IP、多租户同时批量抢机、Cloud Shell、断点续抢、备份恢复、日志实时查看、消息通知、MFA登录验证、更新 Cloudflare DNS 记录、TG 机器人操作等功能。

## 注意事项及免责声明

- 🔑建议使用低权限的API，参考 [@金箍棒](https://t.me/jin_gubang) 的教程：[如何生成低权限API](https://telegra.ph/oralce-api-role-05-05)
- ⚠️因开机、换IP频率过高而导致的封号本人概不负责。
- ❤️开发此项目纯属个人爱好，无后门，放心使用。
- 🔒强烈建议不要裸HTTP访问，应使用Nginx反向代理配置HTTPS访问。
- 🔐建议使用密钥登录服务器，防止服务器被SSH爆破导致API数据及密钥泄露。
- 📃记得定时清理docker日志~

## 核心功能

1. 支持同时**批量添加**多个租户配置信息，所有分页列表都支持**模糊搜索**、**状态筛选**。
2. 支持更改实例配置、引导卷配置、一键附加ipv6、一键放行所有端口、实例列表、引导卷列表、**安全列表**、**实时流量统计**（分钟级别）等功能。
3. 根据多个**CIDR网段**更换实例公共IP，遇到请求频繁等异常会直接忽略，不影响下一次执行，直至更换到指定IP段的IP。
4. 多租户**同时批量开机**，后台一直运行，直至开机成功。
5. 支持**断点续抢**，配置以及抢机任务都保存在本地数据库，服务重启会继续执行抢机任务，无需重复配置。
6. 支持多区号（配置项以region区分），例：我有一个4区号，则新增4个配置，修改region即可，其他配置项都一样。
7. 支持前端页面**实时查看后端日志**。
8. 支持**加密备份恢复**，实现无缝数据迁移，方便快捷。
9. 支持**MFA**登录验证功能（不是龟壳的，是我这个面板的登录），保证服务的安全性。
10. 支持更新 **Cloudflare** DNS 记录功能。
11. 支持 **Telegram 机器人**简单操作，服务成功部署后向机器人发送`/start`选择操作。
12. 支持类似于甲骨文云 **Cloud Shell** 控制台功能。

## 一键 docker-compose 部署或更新

- 安装完成后浏览器直接`ip:8818`即可访问（建议之后通过https访问），账号密码默认都是：`yohann`，
如需修改请更改`/app/oci-helper/application.yml`中的配置并执行`docker restart oci-helper`重启docker容器即可。
- 如需查看完整日志，执行：`docker logs oci-helper  >>  /app/oci-helper/oci-helper.log`导出日志文件自行查看。

```bash
bash <(wget -qO- https://github.com/Yohann0617/oci-helper/releases/latest/download/sh_oci-helper_install.sh)
```

此命令也可以用于更新镜像并重启容器，不会删除已有的配置。

### 📃更新日志

> 2024年11月30日——数据库新增了一张表，TG、钉钉消息通知都改成了在web页面配置，如遇到配置异常，请删除`application.yml`文件，然后重新执行一键命令，修改自定义的账号密码，`docker restart oci-helper`重启容器即可。

## 手动部署（不推荐）

<details>
    <summary> ☜ Read more 👨‍💻</summary>

### 1. 新建目录

创建密钥文件存放目录`/app/oci-helper/keys`，存放从甲骨文云控制台生成API时下载的`密钥文件.pem`，新增oci配置时只需输入`密钥文件名称.pem`即可，默认会加上这个目录全路径。

```bash
mkdir -p /app/oci-helper/keys && cd /app/oci-helper
```

### 2. 下载文件

1. 下载`Releases`中最新的`application.yml`、`oci-helper.db`这两个文件到`/app/oci-helper`目录下，并修改`application.yml`部分配置。
2. 如不使用 docker 部署则再下载一个`oci-helper-1.2.5.jar`文件到`/app/oci-helper`目录下，直接`nohup java -jar oci-helper-1.2.5.jar > /var/log/oci-helper.log &`运行即可（前提是环境上要有`jre8`或`jdk8`环境）。
3. 后续如果更新jar包或者docker镜像，需要安装sqlite并运行`sh_oci-helper_install.sh`中更新版本号的命令（自行解决）。

### 3. docker部署

需提前安装docker环境，支持arm64、amd64架构。

#### 3.1 方式一

docker直接运行：

```bash
docker run -d --name oci-helper --restart=always \
-p 8818:8818 \
-v /app/oci-helper/application.yml:/app/oci-helper/application.yml \
-v /app/oci-helper/oci-helper.db:/app/oci-helper/oci-helper.db \
-v /app/oci-helper/keys:/app/oci-helper/keys \
ghcr.io/yohann0617/oci-helper:master
```

#### 3.2 方式二

下载`Releases`中最新的`docker-compose.yml`到`/app/oci-helper`目录下，运行以下命令：

```bash
docker compose up -d
```

更新最新镜像：

```bash
docker compose pull && docker compose up -d
```

</details>

## 页面展示

<details>
    <summary> ☜ 点击查看 👨‍💻</summary>

![image.png](./img/0-login.png)
![image.png](./img/1-home.png)
![image.png](./img/1-user.png)
![image.png](./img/1-tenantInfo.png)
![image.png](./img/3-add-1.png)
![image.png](./img/3-add-2.png)
![image.png](./img/3-create.png)
![image.png](./img/3-instance-details.png)
![image.png](./img/3-instance-vnc.png)
![image.png](./img/3-instance-cfg.png)
![image.png](./img/3-security-rule.png)
![image.png](./img/3-traffic.png)
![image.png](./img/4-task.png)
![image.png](./img/5-log.png)
![image.png](./img/6-basic-cfg.png)
![image.png](./img/7-backup.png)
![image.png](./img/7-cf.png)
![image.png](./img/8-inform.png)
![image.png](./img/9-tg-bot-1.jpg)
![image.png](./img/9-tg-bot-2.jpg)

</details>

## Stargazers over time

[![Stargazers over time](https://starchart.cc/Yohann0617/oci-helper.svg)](https://starchart.cc/Yohann0617/oci-helper)
