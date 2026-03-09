# VirtualBox 安装 NixOS Minimal 流程指南

以下是在 VirtualBox 中安装 NixOS Minimal 的详细步骤。本指南假设您希望使用 UEFI 引导（这也是您的 `configuration.nix` 配置所设定的）。

## 1. 准备工作

1.  **下载 ISO**：
    *   访问 [NixOS 下载页面](https://nixos.org/download.html)。
    *   下载 **Minimal ISO image** (64-bit Intel/AMD)。

## 2. VirtualBox 虚拟机配置

1.  **新建虚拟机**：
    *   **名称**：NixOS
    *   **类型**：Linux
    *   **版本**：Linux 2.6 / 3.x / 4.x (64-bit) 或 Other Linux (64-bit)
2.  **内存**：建议至少 2048 MB (2GB)。如果以后要跑桌面环境，建议 4GB+。
3.  **硬盘**：创建虚拟硬盘，建议至少 20GB。
4.  **设置调整**：
    *   **系统 -> 主板**：勾选 **启用 EFI (只针对某些操作系统)** (Enable EFI)。这一步很关键，因为您的配置是 UEFI 的。
    *   **存储**：在控制器 IDE 下，选择“没有盘片”，点击右侧光盘图标 -> 选择虚拟盘文件 -> 选择下载的 NixOS Minimal ISO。
    *   **网络**：默认“网络地址转换(NAT)”即可，确保能上网。

## 3. 启动与网络检查

1.  启动虚拟机，选择默认选项引导进入 Live 环境。
2.  登录：用户名为 `root`，无密码。
3.  检查网络（Minimal ISO 默认应该自动配置 NAT 网络）：
    ```bash
    ping -c 3 baidu.com
    ```
    如果无法连接，检查 VirtualBox 网络设置。

## 4. 磁盘分区 (UEFI 模式)

假设目标磁盘为 `/dev/sda`。我们将创建两个分区：
*   `/dev/sda1`: 引导分区 (EFI System Partition), 512MB
*   `/dev/sda2`: 根分区 (Root), 剩余空间

**操作步骤**：

1.  使用 `parted` 进行分区：
    ```bash
    parted /dev/sda -- mklabel gpt
    parted /dev/sda -- mkpart ESP fat32 1MB 512MB
    parted /dev/sda -- set 1 esp on
    parted /dev/sda -- mkpart primary 512MB 100%
    ```

2.  格式化分区：
    ```bash
    # 格式化引导分区为 FAT32
    mkfs.fat -F 32 -n boot /dev/sda1

    # 格式化根分区为 Ext4
    mkfs.ext4 -L nixos /dev/sda2
    ```

3.  挂载分区：
    ```bash
    # 挂载根分区到 /mnt
    mount /dev/disk/by-label/nixos /mnt

    # 创建 boot 目录并挂载引导分区
    mkdir -p /mnt/boot
    mount /dev/disk/by-label/boot /mnt/boot
    ```

## 5. 配置与安装

1.  **生成默认配置**：
    ```bash
    nixos-generate-config --root /mnt
    ```
    这会在 `/mnt/etc/nixos/` 下生成 `configuration.nix` 和 `hardware-configuration.nix`。

2.  **编辑/替换配置文件**：
    *   您可以编辑生成的默认文件：`nano /mnt/etc/nixos/configuration.nix`
    *   **或者**，如果您想使用您现有的 `configuration.nix`，您需要通过 SSH 或其他方式将其复制进去。最简单的方法是先进行最小化安装，重启后再应用您的完整配置。
    *   如果只需最小化安装，请确保 `configuration.nix` 中包含：
        ```nix
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        users.users.root.initialPassword = "root";  # 设置初始密码方便登录（安装后建议修改）
        # 或者开启 SSH
        services.openssh.enable = true;
        ```

3.  **开始安装**：
    ```bash
    nixos-install
    ```
    此过程需要下载数据，速度取决于您的网络环境。

4.  **设置 Root 密码**（如果在配置文件中没设置 initialPassword）：
    安装完成后，在重启前设置密码：
    ```bash
    nixos-enter --root /mnt -c 'passwd root'
    ```

## 6. 重启

1.  重启系统：
    ```bash
    reboot
    ```
2.  在 VirtualBox 卸载 ISO 镜像（通常 VirtualBox 会在重启时自动卸载，或者提示按回车）。
3.  系统启动后，使用 `root` 登录。

## 7. 后续操作

现在您有了一个基础的 NixOS 系统。您可以将您电脑上的 `configuration.nix` 复制到虚拟机的 `/etc/nixos/configuration.nix` 中，然后运行：

```bash
nixos-rebuild switch
```

来应用您的完整配置（包括中文输入法、时区等）。
