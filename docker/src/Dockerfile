# docker build -t ros2:Humble .
FROM ubuntu:22.04
ARG distro="humble"
# ENV ROS_DISTRO Humble
RUN perl -p -i.bak -e 's%(deb(?:-src|)\s+)https?://(?!archive\.canonical\.com|security\.ubuntu\.com)[^\s]+%$1http://linux.yz.yamagata-u.ac.jp/pub/linux/ubuntu/archives/%' /etc/apt/sources.list

LABEL maintainer="yabashikazuya"

# shell形式を指定
SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    byobu \
    nano \
    dnsutils \
    git \
    locales \
    curl \
    gnupg2 \
    lsb-release && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Tokyo



# ロケールのセットアップ
RUN apt-get update && apt-get install -y locales && \
    dpkg-reconfigure locales && \
    locale-gen ja_JP ja_JP.UTF-8 && \
    update-locale LC_ALL=ja_JP.UTF-8 LANG=ja_JP.UTF-8
ENV LC_ALL   ja_JP.UTF-8
ENV LANG     ja_JP.UTF-8
ENV LANGUAGE ja_JP.UTF-8

# add key
RUN apt update && sudo apt install curl -y
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null


ENV ROS_DISTRO $distro
# Install ROS2
RUN apt-get update && apt-get install -y ros-$ROS_DISTRO-desktop \
                python3-colcon-common-extensions \
                python3-rosdep \
                python3-argcomplete \
                ~nros-$ROS_DISTRO-rqt* \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init && rosdep update

## 環境設定
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc


ARG UID
ARG USER_NAME
ARG HOSTNAME
ARG DISPLAY
RUN adduser --uid ${UID} --disabled-password --gecos '' --shell /bin/bash ${USER_NAME}&& \
    chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME} && \
    echo "%${username}    ALL=(ALL)   NOPASSWD:    ALL" >> /etc/sudoers.d/${USER_NAME} && \
    chmod 0440 /etc/sudoers.d/${USER_NAME}
WORKDIR /home/ros2/

RUN echo "export PS1='\[\033[01;32m\]${USER_NAME}@${HOSTNAME}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /home/${USER_NAME}/.bashrc


# Set the entry point
COPY ./ros_entrypoint.sh /
RUN chmod +x /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["/bin/bash"]