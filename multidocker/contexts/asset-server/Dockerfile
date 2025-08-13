FROM node:22-alpine

ARG SSH_KEY
ARG WEBSITE_BRANCH

ARG UTILS_REPO
ARG UTILS_BRANCH
ARG UTILS_DIR

ARG UTILS2_REPO
ARG UTILS2_BRANCH
ARG UTILS2_DIR

ARG UTILS3_REPO
ARG UTILS3_BRANCH
ARG UTILS3_DIR

RUN mkdir /root/.ssh

WORKDIR /root/.ssh
COPY --from=ssh_path . .
RUN apk add bash python3 build-base git openssh
RUN git config --global user.email "invalid@email.address"
RUN git config --global user.name "utility user"

WORKDIR /

RUN GIT_SSH_COMMAND='ssh -i /root/.ssh/${SSH_KEY} -o IdentitiesOnly=yes' git clone https://github.com/stt-datacore/website.git --branch ${WEBSITE_BRANCH} --single-branch --depth 1

RUN GIT_SSH_COMMAND='ssh -i /root/.ssh/${SSH_KEY} -o IdentitiesOnly=yes' git clone ${UTILS_REPO}
RUN mv /${UTILS_DIR} /utils
WORKDIR /utils
RUN git checkout ${UTILS_BRANCH}
RUN git config core.sshCommand 'ssh -i /root/.ssh/${SSH_KEY}'
RUN npm install
RUN chmod 777 ./utils_minor.sh
RUN chmod 777 ./utils_major.sh

WORKDIR /

RUN GIT_SSH_COMMAND='ssh -i /root/.ssh/${SSH_KEY} -o IdentitiesOnly=yes' git clone ${UTILS2_REPO}
RUN mv /${UTILS2_DIR} /utils2
WORKDIR /utils2
RUN git checkout ${UTILS2_BRANCH}
RUN git config core.sshCommand 'ssh -i /root/.ssh/${SSH_KEY}'

WORKDIR /

RUN GIT_SSH_COMMAND='ssh -i /root/.ssh/${SSH_KEY} -o IdentitiesOnly=yes' git clone ${UTILS3_REPO}
RUN mv /${UTILS3_DIR} /utils3
WORKDIR /utils3
RUN git checkout ${UTILS3_BRANCH}
RUN git config core.sshCommand 'ssh -i /root/.ssh/${SSH_KEY}'

RUN mkdir /app

WORKDIR /app

RUN echo */5 * * * * /app/utils_exec.sh > crontab
RUN crontab ./crontab

COPY --from=source package.json package-lock.json ./
RUN npm install

COPY --from=source . .
RUN npm run build

CMD /app/utils_exec.sh --first && crond -f -l 8
