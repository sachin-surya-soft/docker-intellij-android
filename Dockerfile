FROM openkbs/ubuntu-bionic-jdk-mvn-py3

ARG INTELLIJ_VERSION="ideaIC-2020.3"
ARG INTELLIJ_IDE_TAR=${INTELLIJ_VERSION}.tar.gz

# Find the URLs here: https://developer.android.com/studio
ARG ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip"


WORKDIR /opt

COPY jdk.table.xml /etc/idea/config/options/

RUN wget -nv https://download-cf.jetbrains.com/idea/${INTELLIJ_IDE_TAR} && \
    tar xzf ${INTELLIJ_IDE_TAR} && \
    tar tzf ${INTELLIJ_IDE_TAR} | head -1 | sed -e 's/\/.*//' | xargs -I{} ln -s {} idea && \
    rm ${INTELLIJ_IDE_TAR} && \
    echo idea.config.path=/etc/idea/config >> idea/bin/idea.properties && \
    chmod -R 777 /etc/idea && \
    wget -O android-tools.zip -nv ${ANDROID_TOOLS_URL} && \
    unzip android-tools.zip && \
    rm android-tools.zip && \
    yes | cmdline-tools/bin/sdkmanager --licenses --sdk_root=/opt/android-sdk && \
    cmdline-tools/bin/sdkmanager --sdk_root=/opt/android-sdk "platform-tools" "platforms;android-29"
