FROM node:18-alpine
ARG SSH_KEY
ARG UTILS_REPO
ARG UTILS_BRANCH
ARG UTILS2_REPO
ARG UTILS2_BRANCH
ARG UTILS_DIR
ARG UTILS2_DIR
RUN mkdir /root/.ssh
WORKDIR /root/.ssh
COPY --from=ssh_path . .
RUN apk add bash python3 build-base git openssh
RUN git config --global user.email "invalid@email.address"
RUN git config --global user.name "utility user"
RUN mkdir /website
WORKDIR /website
COPY --from=website . .
RUN yarn install
WORKDIR /
RUN GIT_SSH_COMMAND='ssh -i /root/.ssh/${SSH_KEY} -o IdentitiesOnly=yes' git clone ${UTILS_REPO}
RUN mv /${UTILS_DIR} /utils
WORKDIR /utils
RUN git checkout ${UTILS_BRANCH}
RUN git config core.sshCommand 'ssh -i /root/.ssh/${SSH_KEY}'
RUN npm install
RUN npm run build
WORKDIR /
RUN GIT_SSH_COMMAND='ssh -i /root/.ssh/${SSH_KEY} -o IdentitiesOnly=yes' git clone ${UTILS2_REPO}
RUN mv /${UTILS2_DIR} /utils2
WORKDIR /utils2
RUN git checkout ${UTILS2_BRANCH}
RUN git config core.sshCommand 'ssh -i /root/.ssh/${SSH_KEY}'
RUN mkdir /app
WORKDIR /app
RUN echo */30 * * * * /app/utils_exec.sh > crontab
RUN echo 40 5,17 * * * /utils/utils_major.sh >> crontab
RUN crontab ./crontab
COPY --from=source package.json package-lock.json ./
RUN npm install
COPY --from=source . .
RUN npm run build
CMD /app/utils_exec.sh && crond -f -l 8