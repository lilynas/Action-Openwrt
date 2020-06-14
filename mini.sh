
#!/bin/bash

## 小米 Mini 路由器
# 更新并安装源
cd lede
# sed -i 's#lienol https://github.com/Lienol/openwrt-package#lienol https://github.com/kang-mk/openwrt-package#g' feeds.conf.default #更换默认包源
cat feeds.conf.default
./scripts/feeds clean
./scripts/feeds update -a && ./scripts/feeds install -a

# 添加第三方软件包
git clone -b master https://github.com/vernesong/OpenClash package/openclash
git clone https://github.com/tty228/luci-app-serverchan package/luci-app-serverchan
git clone https://github.com/animefansxj/luci-app-smartinfo package/luci-app-smartinfo
# git clone https://github.com/kang-mk/luci-app-passwall package/luci-app-passwall

# 自定义定制选项
sed -i 's#192.168.1.1#10.0.0.1#g' package/base-files/files/bin/config_generate #定制默认IP
sed -i 's#max-width:200px#max-width:1000px#g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm #修改首页样式
# sed -i 's#max-width:200px#max-width:1000px#g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index_x86.htm #修改X86首页样式
sed -i 's#option commit_interval 24h#option commit_interval 10m#g' feeds/packages/net/nlbwmon/files/nlbwmon.config #修改流量统计写入为10分钟
sed -i 's#option database_directory /var/lib/nlbwmon#option database_directory /etc/config/nlbwmon_data#g' feeds/packages/net/nlbwmon/files/nlbwmon.config #修改流量统计数据存放默认位置
# sed -i 's#o.default = "admin"#o.default = ""#g' lienol/luci-app-passwall/luasrc/model/cbi/passwall/balancing.lua #去除haproxy默认密码(最新版已无密码)

# 创建自定义配置文件 - D2

rm -f ./.config*
touch ./.config

#
# ========================固件定制部分========================
# 

# 
# 如果不对本区块做出任何编辑, 则生成默认配置固件. 
# 

# 以下为定制化固件选项和说明:
#

#
# 有些插件/选项是默认开启的, 如果想要关闭, 请参照以下示例进行编写:
# 
#          =========================================
#         |  # 取消编译VMware镜像:                   |
#         |  cat >> .config <<EOF                   |
#         |  # CONFIG_VMDK_IMAGES is not set        |
#         |  EOF                                    |
#          =========================================
#

# 
# 以下是一些提前准备好的一些插件选项.
# 直接取消注释相应代码块即可应用. 不要取消注释代码块上的汉字说明.
# 如果不需要代码块里的某一项配置, 只需要删除相应行.
#
# 如果需要其他插件, 请按照示例自行添加.
# 注意, 只需添加依赖链顶端的包. 如果你需要插件 A, 同时 A 依赖 B, 即只需要添加 A.
# 
# 无论你想要对固件进行怎样的定制, 都需要且只需要修改 EOF 回环内的内容.
# 

# 编译固件:

## 原始 .config 文件固定点
cat >> .config <<EOF
CONFIG_MODULES=y
CONFIG_HAVE_DOT_CONFIG=y
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7620=y
CONFIG_TARGET_ramips_mt7620_DEVICE_xiaomi_miwifi-mini=y
CONFIG_HAS_SUBTARGETS=y
CONFIG_HAS_DEVICES=y
CONFIG_TARGET_BOARD="ramips"
CONFIG_TARGET_SUBTARGET="mt7620"
CONFIG_TARGET_PROFILE="DEVICE_xiaomi_miwifi-mini"
CONFIG_TARGET_ARCH_PACKAGES="mipsel_24kc"
CONFIG_DEFAULT_TARGET_OPTIMIZATION="-Os -pipe -mno-branch-likely -mips32r2 -mtune=24kc"
CONFIG_CPU_TYPE="24kc"
CONFIG_LINUX_4_14=y
CONFIG_DEFAULT_base-files=y
CONFIG_DEFAULT_block-mount=y
CONFIG_DEFAULT_busybox=y
CONFIG_DEFAULT_ca-certificates=y
CONFIG_DEFAULT_coremark=y
CONFIG_DEFAULT_ddns-scripts_aliyun=y
CONFIG_DEFAULT_ddns-scripts_dnspod=y
CONFIG_DEFAULT_default-settings=y
CONFIG_DEFAULT_dnsmasq-full=y
CONFIG_DEFAULT_dropbear=y
CONFIG_DEFAULT_firewall=y
CONFIG_DEFAULT_fstools=y
CONFIG_DEFAULT_iptables=y
CONFIG_DEFAULT_kmod-gpio-button-hotplug=y
CONFIG_DEFAULT_kmod-ipt-offload=y
CONFIG_DEFAULT_kmod-ipt-raw=y
CONFIG_DEFAULT_kmod-leds-gpio=y
CONFIG_DEFAULT_kmod-mt76x2=y
CONFIG_DEFAULT_kmod-nf-nathelper=y
CONFIG_DEFAULT_kmod-nf-nathelper-extra=y
CONFIG_DEFAULT_kmod-rt2800-soc=y
CONFIG_DEFAULT_kmod-tcp-bbr=y
CONFIG_DEFAULT_kmod-usb-ohci=y
CONFIG_DEFAULT_kmod-usb2=y
CONFIG_DEFAULT_libc=y
CONFIG_DEFAULT_libgcc=y
CONFIG_DEFAULT_libustream-openssl=y
CONFIG_DEFAULT_logd=y
CONFIG_DEFAULT_luci=y
CONFIG_DEFAULT_luci-app-accesscontrol=y
CONFIG_DEFAULT_luci-app-adbyby-plus=y
CONFIG_DEFAULT_luci-app-arpbind=y
CONFIG_DEFAULT_luci-app-autoreboot=y
CONFIG_DEFAULT_luci-app-cpufreq=y
CONFIG_DEFAULT_luci-app-ddns=y
CONFIG_DEFAULT_luci-app-filetransfer=y
CONFIG_DEFAULT_luci-app-flowoffload=y
CONFIG_DEFAULT_luci-app-nlbwmon=y
CONFIG_DEFAULT_luci-app-ramfree=y
CONFIG_DEFAULT_luci-app-sfe=y
CONFIG_DEFAULT_luci-app-ssr-plus=y
CONFIG_DEFAULT_luci-app-unblockmusic=y
CONFIG_DEFAULT_luci-app-upnp=y
CONFIG_DEFAULT_luci-app-vlmcsd=y
CONFIG_DEFAULT_luci-app-vsftpd=y
CONFIG_DEFAULT_luci-app-wol=y
CONFIG_DEFAULT_mtd=y
CONFIG_DEFAULT_netifd=y
CONFIG_DEFAULT_opkg=y
CONFIG_DEFAULT_ppp=y
CONFIG_DEFAULT_ppp-mod-pppoe=y
CONFIG_DEFAULT_swconfig=y
CONFIG_DEFAULT_uci=y
CONFIG_DEFAULT_uclient-fetch=y
CONFIG_DEFAULT_urandom-seed=y
CONFIG_DEFAULT_urngd=y
CONFIG_DEFAULT_wget=y
CONFIG_DEFAULT_wpad-openssl=y
CONFIG_AUDIO_SUPPORT=y
CONFIG_GPIO_SUPPORT=y
CONFIG_PCI_SUPPORT=y
CONFIG_USB_SUPPORT=y
CONFIG_USES_DEVICETREE=y
CONFIG_USES_INITRAMFS=y
CONFIG_USES_SQUASHFS=y
CONFIG_HAS_MIPS16=y
CONFIG_NAND_SUPPORT=y
CONFIG_mipsel=y
CONFIG_ARCH="mipsel"
CONFIG_TARGET_ROOTFS_INITRAMFS=y
CONFIG_TARGET_INITRAMFS_COMPRESSION_LZMA=y
CONFIG_EXTERNAL_CPIO=""
CONFIG_TARGET_ROOTFS_SQUASHFS=y
CONFIG_TARGET_SQUASHFS_BLOCK_SIZE=256
CONFIG_TARGET_UBIFS_FREE_SPACE_FIXUP=y
CONFIG_TARGET_UBIFS_JOURNAL_SIZE=""
CONFIG_BUILD_PATENTED=y
CONFIG_SHADOW_PASSWORDS=y
CONFIG_KERNEL_BUILD_USER=""
CONFIG_KERNEL_BUILD_DOMAIN=""
CONFIG_KERNEL_PRINTK=y
CONFIG_KERNEL_CRASHLOG=y
CONFIG_KERNEL_SWAP=y
CONFIG_KERNEL_DEBUG_FS=y
CONFIG_KERNEL_MIPS_FPU_EMULATOR=y
CONFIG_KERNEL_KALLSYMS=y
CONFIG_KERNEL_DEBUG_KERNEL=y
CONFIG_KERNEL_DEBUG_INFO=y
CONFIG_KERNEL_AIO=y
CONFIG_KERNEL_FHANDLE=y
CONFIG_KERNEL_FANOTIFY=y
CONFIG_KERNEL_MAGIC_SYSRQ=y
CONFIG_KERNEL_COREDUMP=y
CONFIG_KERNEL_ELF_CORE=y
CONFIG_KERNEL_PRINTK_TIME=y
CONFIG_KERNEL_KEYS=y
CONFIG_KERNEL_CGROUPS=y
CONFIG_KERNEL_FREEZER=y
CONFIG_KERNEL_CGROUP_FREEZER=y
CONFIG_KERNEL_CGROUP_DEVICE=y
CONFIG_KERNEL_CGROUP_PIDS=y
CONFIG_KERNEL_CPUSETS=y
CONFIG_KERNEL_CGROUP_CPUACCT=y
CONFIG_KERNEL_RESOURCE_COUNTERS=y
CONFIG_KERNEL_MM_OWNER=y
CONFIG_KERNEL_MEMCG=y
CONFIG_KERNEL_MEMCG_KMEM=y
CONFIG_KERNEL_CGROUP_SCHED=y
CONFIG_KERNEL_FAIR_GROUP_SCHED=y
CONFIG_KERNEL_RT_GROUP_SCHED=y
CONFIG_KERNEL_BLK_CGROUP=y
CONFIG_KERNEL_NET_CLS_CGROUP=y
CONFIG_KERNEL_NETPRIO_CGROUP=y
CONFIG_KERNEL_NAMESPACES=y
CONFIG_KERNEL_UTS_NS=y
CONFIG_KERNEL_IPC_NS=y
CONFIG_KERNEL_USER_NS=y
CONFIG_KERNEL_PID_NS=y
CONFIG_KERNEL_NET_NS=y
CONFIG_KERNEL_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_KERNEL_POSIX_MQUEUE=y
CONFIG_KERNEL_IP_MROUTE=y
CONFIG_KERNEL_IPV6=y
CONFIG_KERNEL_IPV6_MULTIPLE_TABLES=y
CONFIG_KERNEL_IPV6_SUBTREES=y
CONFIG_KERNEL_IPV6_MROUTE=y
CONFIG_KERNEL_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_KERNEL_CC_OPTIMIZE_FOR_PERFORMANCE=y
CONFIG_IPV6=y
CONFIG_USE_SSTRIP=y
CONFIG_USE_UCLIBCXX=y
CONFIG_PKG_CHECK_FORMAT_SECURITY=y
CONFIG_PKG_ASLR_PIE_REGULAR=y
CONFIG_PKG_CC_STACKPROTECTOR_REGULAR=y
CONFIG_KERNEL_CC_STACKPROTECTOR_REGULAR=y
CONFIG_KERNEL_STACKPROTECTOR=y
CONFIG_PKG_FORTIFY_SOURCE_1=y
CONFIG_PKG_RELRO_FULL=y
CONFIG_BINARY_FOLDER=""
CONFIG_DOWNLOAD_FOLDER=""
CONFIG_LOCALMIRROR=""
CONFIG_AUTOREBUILD=y
CONFIG_BUILD_SUFFIX=""
CONFIG_TARGET_ROOTFS_DIR=""
CONFIG_EXTERNAL_KERNEL_TREE=""
CONFIG_KERNEL_GIT_CLONE_URI=""
CONFIG_EXTRA_OPTIMIZATION="-fno-caller-saves -fno-plt"
CONFIG_TARGET_OPTIMIZATION="-Os -pipe -mno-branch-likely -mips32r2 -mtune=24kc"
CONFIG_SOFT_FLOAT=y
CONFIG_USE_MIPS16=y
CONFIG_EXTRA_BINUTILS_CONFIG_OPTIONS=""
CONFIG_EXTRA_GCC_CONFIG_OPTIONS=""
CONFIG_GDB=y
CONFIG_USE_MUSL=y
CONFIG_SSP_SUPPORT=y
CONFIG_BINUTILS_VERSION_2_31_1=y
CONFIG_BINUTILS_VERSION="2.31.1"
CONFIG_GCC_VERSION="7.5.0"
CONFIG_LIBC="musl"
CONFIG_TARGET_SUFFIX="musl"
CONFIG_TARGET_PREINIT_SUPPRESS_STDERR=y
CONFIG_TARGET_PREINIT_TIMEOUT=2
CONFIG_TARGET_PREINIT_IFNAME=""
CONFIG_TARGET_PREINIT_IP="192.168.1.1"
CONFIG_TARGET_PREINIT_NETMASK="255.255.255.0"
CONFIG_TARGET_PREINIT_BROADCAST="192.168.1.255"
CONFIG_TARGET_INIT_PATH="/usr/sbin:/usr/bin:/sbin:/bin"
CONFIG_TARGET_INIT_ENV=""
CONFIG_TARGET_INIT_CMD="/sbin/init"
CONFIG_TARGET_INIT_SUPPRESS_STDERR=y
CONFIG_PER_FEED_REPO=y
CONFIG_FEED_packages=y
CONFIG_FEED_luci=y
CONFIG_FEED_routing=y
CONFIG_PACKAGE_base-files=y
CONFIG_PACKAGE_block-mount=y
CONFIG_PACKAGE_busybox=y
CONFIG_BUSYBOX_DEFAULT_HAVE_DOT_CONFIG=y
CONFIG_BUSYBOX_DEFAULT_INCLUDE_SUSv2=y
CONFIG_BUSYBOX_DEFAULT_LONG_OPTS=y
CONFIG_BUSYBOX_DEFAULT_SHOW_USAGE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_VERBOSE_USAGE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_COMPRESS_USAGE=y
CONFIG_BUSYBOX_DEFAULT_LFS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_DEVPTS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_PIDFILE=y
CONFIG_BUSYBOX_DEFAULT_PID_FILE_PATH="/var/run"
CONFIG_BUSYBOX_DEFAULT_FEATURE_SUID=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_PREFER_APPLETS=y
CONFIG_BUSYBOX_DEFAULT_BUSYBOX_EXEC_PATH="/proc/self/exe"
CONFIG_BUSYBOX_DEFAULT_FEATURE_SYSLOG=y
CONFIG_BUSYBOX_DEFAULT_PLATFORM_LINUX=y
CONFIG_BUSYBOX_DEFAULT_CROSS_COMPILER_PREFIX=""
CONFIG_BUSYBOX_DEFAULT_SYSROOT=""
CONFIG_BUSYBOX_DEFAULT_EXTRA_CFLAGS=""
CONFIG_BUSYBOX_DEFAULT_EXTRA_LDFLAGS=""
CONFIG_BUSYBOX_DEFAULT_EXTRA_LDLIBS=""
CONFIG_BUSYBOX_DEFAULT_INSTALL_APPLET_SYMLINKS=y
CONFIG_BUSYBOX_DEFAULT_PREFIX="./_install"
CONFIG_BUSYBOX_DEFAULT_NO_DEBUG_LIB=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_BUFFERS_GO_ON_STACK=y
CONFIG_BUSYBOX_DEFAULT_PASSWORD_MINLEN=6
CONFIG_BUSYBOX_DEFAULT_MD5_SMALL=1
CONFIG_BUSYBOX_DEFAULT_SHA3_SMALL=1
CONFIG_BUSYBOX_DEFAULT_FEATURE_FAST_TOP=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_EDITING=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_EDITING_MAX_LEN=512
CONFIG_BUSYBOX_DEFAULT_FEATURE_EDITING_HISTORY=256
CONFIG_BUSYBOX_DEFAULT_FEATURE_TAB_COMPLETION=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_EDITING_FANCY_PROMPT=y
CONFIG_BUSYBOX_DEFAULT_SUBST_WCHAR=0
CONFIG_BUSYBOX_DEFAULT_LAST_SUPPORTED_WCHAR=0
CONFIG_BUSYBOX_DEFAULT_FEATURE_NON_POSIX_CP=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_USE_SENDFILE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_COPYBUF_KB=4
CONFIG_BUSYBOX_DEFAULT_IOCTL_HEX2STR_ERROR=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_SEAMLESS_GZ=y
CONFIG_BUSYBOX_DEFAULT_GUNZIP=y
CONFIG_BUSYBOX_DEFAULT_ZCAT=y
CONFIG_BUSYBOX_DEFAULT_BUNZIP2=y
CONFIG_BUSYBOX_DEFAULT_BZCAT=y
CONFIG_BUSYBOX_DEFAULT_BZIP2_SMALL=0
CONFIG_BUSYBOX_DEFAULT_FEATURE_BZIP2_DECOMPRESS=y
CONFIG_BUSYBOX_DEFAULT_GZIP=y
CONFIG_BUSYBOX_DEFAULT_GZIP_FAST=0
CONFIG_BUSYBOX_DEFAULT_FEATURE_GZIP_DECOMPRESS=y
CONFIG_BUSYBOX_DEFAULT_TAR=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_CREATE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_FROM=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_GNU_EXTENSIONS=y
CONFIG_BUSYBOX_DEFAULT_BASENAME=y
CONFIG_BUSYBOX_DEFAULT_CAT=y
CONFIG_BUSYBOX_DEFAULT_CHGRP=y
CONFIG_BUSYBOX_DEFAULT_CHMOD=y
CONFIG_BUSYBOX_DEFAULT_CHOWN=y
CONFIG_BUSYBOX_DEFAULT_CHROOT=y
CONFIG_BUSYBOX_DEFAULT_CP=y
CONFIG_BUSYBOX_DEFAULT_CUT=y
CONFIG_BUSYBOX_DEFAULT_DATE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_DATE_ISOFMT=y
CONFIG_BUSYBOX_DEFAULT_DD=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_DD_SIGNAL_HANDLING=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_DD_IBS_OBS=y
CONFIG_BUSYBOX_DEFAULT_DF=y
CONFIG_BUSYBOX_DEFAULT_DIRNAME=y
CONFIG_BUSYBOX_DEFAULT_DU=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_DU_DEFAULT_BLOCKSIZE_1K=y
CONFIG_BUSYBOX_DEFAULT_ECHO=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FANCY_ECHO=y
CONFIG_BUSYBOX_DEFAULT_ENV=y
CONFIG_BUSYBOX_DEFAULT_EXPR=y
CONFIG_BUSYBOX_DEFAULT_EXPR_MATH_SUPPORT_64=y
CONFIG_BUSYBOX_DEFAULT_FALSE=y
CONFIG_BUSYBOX_DEFAULT_FSYNC=y
CONFIG_BUSYBOX_DEFAULT_HEAD=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FANCY_HEAD=y
CONFIG_BUSYBOX_DEFAULT_ID=y
CONFIG_BUSYBOX_DEFAULT_LN=y
CONFIG_BUSYBOX_DEFAULT_LS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_FILETYPES=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_FOLLOWLINKS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_RECURSIVE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_WIDTH=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_SORTFILES=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_TIMESTAMPS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_USERNAME=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_COLOR=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_COLOR_IS_DEFAULT=y
CONFIG_BUSYBOX_DEFAULT_MD5SUM=y
CONFIG_BUSYBOX_DEFAULT_SHA256SUM=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_MD5_SHA1_SUM_CHECK=y
CONFIG_BUSYBOX_DEFAULT_MKDIR=y
CONFIG_BUSYBOX_DEFAULT_MKFIFO=y
CONFIG_BUSYBOX_DEFAULT_MKNOD=y
CONFIG_BUSYBOX_DEFAULT_MKTEMP=y
CONFIG_BUSYBOX_DEFAULT_MV=y
CONFIG_BUSYBOX_DEFAULT_NICE=y
CONFIG_BUSYBOX_DEFAULT_PRINTF=y
CONFIG_BUSYBOX_DEFAULT_PWD=y
CONFIG_BUSYBOX_DEFAULT_READLINK=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_READLINK_FOLLOW=y
CONFIG_BUSYBOX_DEFAULT_RM=y
CONFIG_BUSYBOX_DEFAULT_RMDIR=y
CONFIG_BUSYBOX_DEFAULT_SEQ=y
CONFIG_BUSYBOX_DEFAULT_SLEEP=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FANCY_SLEEP=y
CONFIG_BUSYBOX_DEFAULT_SORT=y
CONFIG_BUSYBOX_DEFAULT_SYNC=y
CONFIG_BUSYBOX_DEFAULT_TAIL=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FANCY_TAIL=y
CONFIG_BUSYBOX_DEFAULT_TEE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_TEE_USE_BLOCK_IO=y
CONFIG_BUSYBOX_DEFAULT_TEST=y
CONFIG_BUSYBOX_DEFAULT_TEST1=y
CONFIG_BUSYBOX_DEFAULT_TEST2=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_TEST_64=y
CONFIG_BUSYBOX_DEFAULT_TOUCH=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_TOUCH_SUSV3=y
CONFIG_BUSYBOX_DEFAULT_TR=y
CONFIG_BUSYBOX_DEFAULT_TRUE=y
CONFIG_BUSYBOX_DEFAULT_UNAME=y
CONFIG_BUSYBOX_DEFAULT_UNAME_OSNAME="GNU/Linux"
CONFIG_BUSYBOX_DEFAULT_UNIQ=y
CONFIG_BUSYBOX_DEFAULT_WC=y
CONFIG_BUSYBOX_DEFAULT_YES=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_PRESERVE_HARDLINKS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_HUMAN_READABLE=y
CONFIG_BUSYBOX_DEFAULT_CLEAR=y
CONFIG_BUSYBOX_DEFAULT_DEFAULT_SETFONT_DIR=""
CONFIG_BUSYBOX_DEFAULT_RESET=y
CONFIG_BUSYBOX_DEFAULT_START_STOP_DAEMON=y
CONFIG_BUSYBOX_DEFAULT_WHICH=y
CONFIG_BUSYBOX_DEFAULT_AWK=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_AWK_LIBM=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_AWK_GNU_EXTENSIONS=y
CONFIG_BUSYBOX_DEFAULT_CMP=y
CONFIG_BUSYBOX_DEFAULT_SED=y
CONFIG_BUSYBOX_DEFAULT_VI=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_MAX_LEN=1024
CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_COLON=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_YANKMARK=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_SEARCH=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_USE_SIGNALS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_DOT_CMD=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_READONLY=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_SETOPTS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_SET=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_WIN_RESIZE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_ASK_TERMINAL=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_UNDO_QUEUE_MAX=0
CONFIG_BUSYBOX_DEFAULT_FEATURE_ALLOW_EXEC=y
CONFIG_BUSYBOX_DEFAULT_FIND=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_PRINT0=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_MTIME=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_PERM=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_TYPE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_XDEV=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_MAXDEPTH=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_NEWER=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_EXEC=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_USER=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_GROUP=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_NOT=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_DEPTH=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_PAREN=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_SIZE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_PRUNE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_PATH=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_REGEX=y
CONFIG_BUSYBOX_DEFAULT_GREP=y
CONFIG_BUSYBOX_DEFAULT_EGREP=y
CONFIG_BUSYBOX_DEFAULT_FGREP=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_GREP_CONTEXT=y
CONFIG_BUSYBOX_DEFAULT_XARGS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_XARGS_SUPPORT_CONFIRMATION=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_XARGS_SUPPORT_QUOTES=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_XARGS_SUPPORT_TERMOPT=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_XARGS_SUPPORT_ZERO_TERM=y
CONFIG_BUSYBOX_DEFAULT_HALT=y
CONFIG_BUSYBOX_DEFAULT_POWEROFF=y
CONFIG_BUSYBOX_DEFAULT_REBOOT=y
CONFIG_BUSYBOX_DEFAULT_TELINIT_PATH=""
CONFIG_BUSYBOX_DEFAULT_FEATURE_KILL_DELAY=0
CONFIG_BUSYBOX_DEFAULT_INIT_TERMINAL_TYPE=""
CONFIG_BUSYBOX_DEFAULT_FEATURE_SHADOWPASSWDS=y
CONFIG_BUSYBOX_DEFAULT_LAST_ID=0
CONFIG_BUSYBOX_DEFAULT_FIRST_SYSTEM_ID=0
CONFIG_BUSYBOX_DEFAULT_LAST_SYSTEM_ID=0
CONFIG_BUSYBOX_DEFAULT_FEATURE_DEFAULT_PASSWD_ALGO="md5"
CONFIG_BUSYBOX_DEFAULT_LOGIN=y
CONFIG_BUSYBOX_DEFAULT_LOGIN_SESSION_AS_CHILD=y
CONFIG_BUSYBOX_DEFAULT_PASSWD=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_PASSWD_WEAK_CHECK=y
CONFIG_BUSYBOX_DEFAULT_DEFAULT_MODULES_DIR=""
CONFIG_BUSYBOX_DEFAULT_DEFAULT_DEPMOD_FILE=""
CONFIG_BUSYBOX_DEFAULT_DMESG=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_DMESG_PRETTY=y
CONFIG_BUSYBOX_DEFAULT_FLOCK=y
CONFIG_BUSYBOX_DEFAULT_HEXDUMP=y
CONFIG_BUSYBOX_DEFAULT_HWCLOCK=y
CONFIG_BUSYBOX_DEFAULT_MKSWAP=y
CONFIG_BUSYBOX_DEFAULT_MOUNT=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_HELPERS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_CIFS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_FLAGS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_FSTAB=y
CONFIG_BUSYBOX_DEFAULT_PIVOT_ROOT=y
CONFIG_BUSYBOX_DEFAULT_SWITCH_ROOT=y
CONFIG_BUSYBOX_DEFAULT_UMOUNT=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_UMOUNT_ALL=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_LOOP=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_BEEP_FREQ=0
CONFIG_BUSYBOX_DEFAULT_FEATURE_BEEP_LENGTH_MS=0
CONFIG_BUSYBOX_DEFAULT_CROND=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_CROND_DIR="/etc"
CONFIG_BUSYBOX_DEFAULT_CRONTAB=y
CONFIG_BUSYBOX_DEFAULT_LESS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_LESS_MAXLINES=9999999
CONFIG_BUSYBOX_DEFAULT_LOCK=y
CONFIG_BUSYBOX_DEFAULT_STRINGS=y
CONFIG_BUSYBOX_DEFAULT_TIME=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_IPV6=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_PREFER_IPV4_ADDRESS=y
CONFIG_BUSYBOX_DEFAULT_VERBOSE_RESOLUTION_ERRORS=y
CONFIG_BUSYBOX_DEFAULT_BRCTL=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_BRCTL_FANCY=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_BRCTL_SHOW=y
CONFIG_BUSYBOX_DEFAULT_IFCONFIG=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_IFCONFIG_STATUS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_IFCONFIG_HW=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_IFCONFIG_BROADCAST_PLUS=y
CONFIG_BUSYBOX_DEFAULT_IFUPDOWN_IFSTATE_PATH=""
CONFIG_BUSYBOX_DEFAULT_IP=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_ADDRESS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_LINK=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_ROUTE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_ROUTE_DIR="/etc/iproute2"
CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_RULE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_NEIGH=y
CONFIG_BUSYBOX_DEFAULT_NC=y
CONFIG_BUSYBOX_DEFAULT_NETMSG=y
CONFIG_BUSYBOX_DEFAULT_NETSTAT=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_NETSTAT_WIDE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_NETSTAT_PRG=y
CONFIG_BUSYBOX_DEFAULT_NSLOOKUP_OPENWRT=y
CONFIG_BUSYBOX_DEFAULT_NTPD=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_NTPD_SERVER=y
CONFIG_BUSYBOX_DEFAULT_PING=y
CONFIG_BUSYBOX_DEFAULT_PING6=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_FANCY_PING=y
CONFIG_BUSYBOX_DEFAULT_ROUTE=y
CONFIG_BUSYBOX_DEFAULT_TRACEROUTE=y
CONFIG_BUSYBOX_DEFAULT_TRACEROUTE6=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_TRACEROUTE_VERBOSE=y
CONFIG_BUSYBOX_DEFAULT_DHCPD_LEASES_FILE=""
CONFIG_BUSYBOX_DEFAULT_UDHCPC=y
CONFIG_BUSYBOX_DEFAULT_UDHCPC_DEFAULT_SCRIPT="/usr/share/udhcpc/default.script"
CONFIG_BUSYBOX_DEFAULT_UDHCP_DEBUG=0
CONFIG_BUSYBOX_DEFAULT_UDHCPC_SLACK_FOR_BUGGY_SERVERS=80
CONFIG_BUSYBOX_DEFAULT_FEATURE_UDHCP_RFC3397=y
CONFIG_BUSYBOX_DEFAULT_IFUPDOWN_UDHCPC_CMD_OPTIONS=""
CONFIG_BUSYBOX_DEFAULT_FEATURE_MIME_CHARSET=""
CONFIG_BUSYBOX_DEFAULT_FREE=y
CONFIG_BUSYBOX_DEFAULT_KILL=y
CONFIG_BUSYBOX_DEFAULT_KILLALL=y
CONFIG_BUSYBOX_DEFAULT_PGREP=y
CONFIG_BUSYBOX_DEFAULT_PIDOF=y
CONFIG_BUSYBOX_DEFAULT_PS=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_PS_WIDE=y
CONFIG_BUSYBOX_DEFAULT_BB_SYSCTL=y
CONFIG_BUSYBOX_DEFAULT_TOP=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_TOP_CPU_USAGE_PERCENTAGE=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_TOP_CPU_GLOBAL_PERCENTS=y
CONFIG_BUSYBOX_DEFAULT_UPTIME=y
CONFIG_BUSYBOX_DEFAULT_SV_DEFAULT_SERVICE_DIR=""
CONFIG_BUSYBOX_DEFAULT_SH_IS_ASH=y
CONFIG_BUSYBOX_DEFAULT_BASH_IS_NONE=y
CONFIG_BUSYBOX_DEFAULT_ASH=y
CONFIG_BUSYBOX_DEFAULT_ASH_INTERNAL_GLOB=y
CONFIG_BUSYBOX_DEFAULT_ASH_BASH_COMPAT=y
CONFIG_BUSYBOX_DEFAULT_ASH_JOB_CONTROL=y
CONFIG_BUSYBOX_DEFAULT_ASH_ALIAS=y
CONFIG_BUSYBOX_DEFAULT_ASH_EXPAND_PRMT=y
CONFIG_BUSYBOX_DEFAULT_ASH_ECHO=y
CONFIG_BUSYBOX_DEFAULT_ASH_PRINTF=y
CONFIG_BUSYBOX_DEFAULT_ASH_TEST=y
CONFIG_BUSYBOX_DEFAULT_ASH_GETOPTS=y
CONFIG_BUSYBOX_DEFAULT_ASH_CMDCMD=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_SH_MATH=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_SH_MATH_64=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_SH_NOFORK=y
CONFIG_BUSYBOX_DEFAULT_LOGGER=y
CONFIG_BUSYBOX_DEFAULT_FEATURE_SYSLOGD_READ_BUFFER_SIZE=0
CONFIG_BUSYBOX_DEFAULT_FEATURE_IPC_SYSLOG_BUFFER_SIZE=0
CONFIG_PACKAGE_ca-certificates=y
CONFIG_PACKAGE_dnsmasq-full=y
CONFIG_PACKAGE_dnsmasq_full_dhcp=y
CONFIG_PACKAGE_dnsmasq_full_ipset=y
CONFIG_PACKAGE_dropbear=y
CONFIG_DROPBEAR_CURVE25519=y
CONFIG_DROPBEAR_DBCLIENT=y
CONFIG_PACKAGE_firewall=y
CONFIG_PACKAGE_fstools=y
CONFIG_FSTOOLS_UBIFS_EXTROOT=y
CONFIG_PACKAGE_fwtool=y
CONFIG_PACKAGE_getrandom=y
CONFIG_PACKAGE_jsonfilter=y
CONFIG_PACKAGE_libc=y
CONFIG_PACKAGE_libgcc=y
CONFIG_PACKAGE_libpthread=y
CONFIG_PACKAGE_librt=y
CONFIG_PACKAGE_logd=y
CONFIG_PACKAGE_mtd=y
CONFIG_PACKAGE_netifd=y
CONFIG_PACKAGE_opkg=y
CONFIG_PACKAGE_procd=y
CONFIG_PACKAGE_rpcd=y
CONFIG_PACKAGE_swconfig=y
CONFIG_PACKAGE_ubox=y
CONFIG_PACKAGE_ubus=y
CONFIG_PACKAGE_ubusd=y
CONFIG_PACKAGE_uci=y
CONFIG_PACKAGE_urandom-seed=y
CONFIG_PACKAGE_urngd=y
CONFIG_PACKAGE_wireless-regdb=y
CONFIG_PACKAGE_kmod-crypto-aead=y
CONFIG_PACKAGE_kmod-crypto-arc4=y
CONFIG_PACKAGE_kmod-crypto-authenc=y
CONFIG_PACKAGE_kmod-crypto-ecb=y
CONFIG_PACKAGE_kmod-crypto-hash=y
CONFIG_PACKAGE_kmod-crypto-manager=y
CONFIG_PACKAGE_kmod-crypto-null=y
CONFIG_PACKAGE_kmod-crypto-pcompress=y
CONFIG_PACKAGE_kmod-crypto-sha1=y
CONFIG_PACKAGE_kmod-crypto-user=y
CONFIG_PACKAGE_kmod-cryptodev=y
CONFIG_PACKAGE_kmod-leds-gpio=y
CONFIG_PACKAGE_kmod-lib-crc-ccitt=y
CONFIG_PACKAGE_kmod-lib-textsearch=y
CONFIG_PACKAGE_kmod-nls-base=y
CONFIG_PACKAGE_kmod-ipt-conntrack=y
CONFIG_PACKAGE_kmod-ipt-core=y
CONFIG_PACKAGE_kmod-ipt-fullconenat=y
CONFIG_PACKAGE_kmod-ipt-ipset=y
CONFIG_PACKAGE_kmod-ipt-nat=y
CONFIG_PACKAGE_kmod-ipt-offload=y
CONFIG_PACKAGE_kmod-ipt-raw=y
CONFIG_PACKAGE_kmod-nf-conntrack=y
CONFIG_PACKAGE_kmod-nf-conntrack-netlink=y
CONFIG_PACKAGE_kmod-nf-conntrack6=y
CONFIG_PACKAGE_kmod-nf-flow=y
CONFIG_PACKAGE_kmod-nf-ipt=y
CONFIG_PACKAGE_kmod-nf-nat=y
CONFIG_PACKAGE_kmod-nf-nathelper=y
CONFIG_PACKAGE_kmod-nf-nathelper-extra=y
CONFIG_PACKAGE_kmod-nf-reject=y
CONFIG_PACKAGE_kmod-nfnetlink=y
CONFIG_PACKAGE_kmod-macvlan=y
CONFIG_PACKAGE_kmod-ppp=y
CONFIG_PACKAGE_kmod-mppe=y
CONFIG_PACKAGE_kmod-pppoe=y
CONFIG_PACKAGE_kmod-pppox=y
CONFIG_PACKAGE_kmod-slhc=y
CONFIG_PACKAGE_kmod-tcp-bbr=y
CONFIG_PACKAGE_kmod-gpio-button-hotplug=y
CONFIG_PACKAGE_kmod-usb-core=y
CONFIG_PACKAGE_kmod-usb-ehci=y
CONFIG_PACKAGE_kmod-usb-ohci=y
CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-cfg80211=y
CONFIG_PACKAGE_kmod-mac80211=y
CONFIG_PACKAGE_MAC80211_DEBUGFS=y
CONFIG_PACKAGE_MAC80211_MESH=y
CONFIG_PACKAGE_kmod-mt76-core=y
CONFIG_PACKAGE_kmod-mt76x02-common=y
CONFIG_PACKAGE_kmod-mt76x2=y
CONFIG_PACKAGE_kmod-mt76x2-common=y
CONFIG_PACKAGE_kmod-rt2800-lib=y
CONFIG_PACKAGE_kmod-rt2800-mmio=y
CONFIG_PACKAGE_kmod-rt2800-soc=y
CONFIG_PACKAGE_kmod-rt2x00-lib=y
CONFIG_PACKAGE_kmod-rt2x00-mmio=y
CONFIG_PACKAGE_libiwinfo-lua=y
CONFIG_PACKAGE_lua=y
CONFIG_PACKAGE_luci-lib-fs=y
CONFIG_ZSTD_OPTIMIZE_O3=y
CONFIG_PACKAGE_libip4tc=y
CONFIG_PACKAGE_libip6tc=y
CONFIG_PACKAGE_libxtables=y
CONFIG_PACKAGE_libopenssl=y
CONFIG_OPENSSL_OPTIMIZE_SPEED=y
CONFIG_OPENSSL_WITH_ASM=y
CONFIG_OPENSSL_WITH_DEPRECATED=y
CONFIG_OPENSSL_WITH_ERROR_MESSAGES=y
CONFIG_OPENSSL_WITH_TLS13=y
CONFIG_OPENSSL_WITH_SRP=y
CONFIG_OPENSSL_WITH_CMS=y
CONFIG_OPENSSL_WITH_CHACHA_POLY1305=y
CONFIG_OPENSSL_PREFER_CHACHA_OVER_GCM=y
CONFIG_OPENSSL_WITH_PSK=y
CONFIG_OPENSSL_ENGINE=y
CONFIG_OPENSSL_ENGINE_BUILTIN=y
CONFIG_OPENSSL_ENGINE_BUILTIN_AFALG=y
CONFIG_OPENSSL_ENGINE_BUILTIN_DEVCRYPTO=y
CONFIG_PACKAGE_libopenssl-conf=y
CONFIG_PACKAGE_libblobmsg-json=y
CONFIG_PACKAGE_libiwinfo=y
CONFIG_PACKAGE_libjson-c=y
CONFIG_PACKAGE_liblua=y
CONFIG_PACKAGE_libnl-tiny=y
CONFIG_PACKAGE_libpcre=y
CONFIG_PACKAGE_libubox=y
CONFIG_PACKAGE_libubus=y
CONFIG_PACKAGE_libubus-lua=y
CONFIG_PACKAGE_libuci=y
CONFIG_PACKAGE_libuci-lua=y
CONFIG_PACKAGE_libuclient=y
CONFIG_PACKAGE_libustream-openssl=y
CONFIG_PACKAGE_libuuid=y
CONFIG_PACKAGE_rpcd-mod-rrdns=y
CONFIG_PACKAGE_zlib=y
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-base=y
CONFIG_LUCI_SRCDIET=y
CONFIG_LUCI_LANG_zh-cn=y
CONFIG_PACKAGE_luci-mod-admin-full=y
CONFIG_PACKAGE_luci-app-accesscontrol=y
CONFIG_PACKAGE_luci-app-autoreboot=y
CONFIG_PACKAGE_luci-app-filetransfer=y
CONFIG_PACKAGE_luci-app-firewall=y
CONFIG_PACKAGE_luci-app-flowoffload=y
CONFIG_PACKAGE_luci-app-frpc=y
CONFIG_PACKAGE_luci-app-nlbwmon=y
CONFIG_PACKAGE_luci-app-privoxy=y
CONFIG_PACKAGE_luci-app-ramfree=y
CONFIG_PACKAGE_luci-app-samba=y
CONFIG_PACKAGE_luci-app-upnp=y
CONFIG_PACKAGE_luci-app-vlmcsd=y
CONFIG_PACKAGE_luci-theme-bootstrap=y
CONFIG_PACKAGE_luci-theme-netgear=y
CONFIG_PACKAGE_luci-proto-ppp=y
CONFIG_PACKAGE_luci-lib-ip=y
CONFIG_PACKAGE_luci-lib-jsonc=y
CONFIG_PACKAGE_luci-lib-nixio=y
CONFIG_PACKAGE_default-settings=y
CONFIG_PACKAGE_luci-i18n-accesscontrol-zh-cn=y
CONFIG_PACKAGE_luci-i18n-autoreboot-zh-cn=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y
CONFIG_PACKAGE_luci-i18n-filetransfer-zh-cn=y
CONFIG_PACKAGE_luci-i18n-firewall-zh-cn=y
CONFIG_PACKAGE_luci-i18n-flowoffload-zh-cn=y
CONFIG_PACKAGE_luci-i18n-frpc-zh-cn=y
CONFIG_PACKAGE_luci-i18n-nlbwmon-zh-cn=y
CONFIG_PACKAGE_luci-i18n-privoxy-zh-cn=y
CONFIG_PACKAGE_luci-i18n-ramfree-zh-cn=y
CONFIG_PACKAGE_luci-i18n-samba-zh-cn=y
CONFIG_PACKAGE_luci-i18n-upnp-zh-cn=y
CONFIG_PACKAGE_luci-i18n-vlmcsd-zh-cn=y
CONFIG_POSTFIX_TLS=y
CONFIG_POSTFIX_SASL=y
CONFIG_POSTFIX_LDAP=y
CONFIG_POSTFIX_CDB=y
CONFIG_POSTFIX_SQLITE=y
CONFIG_POSTFIX_PCRE=y
CONFIG_PACKAGE_wget=y
CONFIG_PACKAGE_iptables=y
CONFIG_PACKAGE_iptables-mod-fullconenat=y
CONFIG_PACKAGE_miniupnpd=y
CONFIG_PACKAGE_ddns-scripts=y
CONFIG_PACKAGE_ddns-scripts_aliyun=y
CONFIG_PACKAGE_ddns-scripts_dnspod=y
CONFIG_OPENLDAP_DEBUG=y
CONFIG_PACKAGE_frpc=y
CONFIG_PACKAGE_pdnsd-alt=y
CONFIG_PACKAGE_privoxy=y
CONFIG_PACKAGE_uhttpd=y
CONFIG_PACKAGE_uhttpd-mod-ubus=y
CONFIG_PACKAGE_hostapd-common=y
CONFIG_PACKAGE_iw=y
CONFIG_PACKAGE_nlbwmon=y
CONFIG_PACKAGE_ppp=y
CONFIG_PACKAGE_ppp-mod-pppoe=y
CONFIG_PACKAGE_samba36-server=y
CONFIG_PACKAGE_SAMBA_MAX_DEBUG_LEVEL=-1
CONFIG_PACKAGE_uclient-fetch=y
CONFIG_PACKAGE_vlmcsd=y
CONFIG_WPA_MSG_MIN_PRIORITY=3
CONFIG_DRIVER_11N_SUPPORT=y
CONFIG_DRIVER_11AC_SUPPORT=y
CONFIG_DRIVER_11W_SUPPORT=y
CONFIG_PACKAGE_wpad-openssl=y
CONFIG_PACKAGE_coremark=y
CONFIG_DOCKER_KERNEL_OPTIONS=y
CONFIG_PACKAGE_jshn=y
CONFIG_PACKAGE_libjson-script=y
CONFIG_PACKAGE_openssl-util=y
CONFIG_PACKAGE_shellsync=y
CONFIG_STRACE_NONE=y
CONFIG_PACKAGE_ubi-utils=y
EOF

## 增配点
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-wrtbwmon=y #实时流量监测
# CONFIG_PACKAGE_luci-app-oaf=y #应用过滤
CONFIG_PACKAGE_luci-app-openclash=y #OpenClash客户端
CONFIG_PACKAGE_luci-app-serverchan=y #微信推送
# CONFIG_PACKAGE_luci-app-smartinfo=y #磁盘健康监控
EOF

# 
# ========================固件定制部分结束========================
# 

sed -i 's/^[ \t]*//g' ./.config

# 配置文件创建完成
