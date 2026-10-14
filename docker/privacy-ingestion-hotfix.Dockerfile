FROM chatwoot/chatwoot@sha256:b419dded7e9d2f54a24fd427b74ba7e6069d601b500618045c1eb6c01a1cc9a1
WORKDIR /app
RUN echo '687081820ff9259c1a982b66b0faf6eb04aec51775a80191b1f9ed9b41c9a2ee app/mailboxes/application_mailbox.rb' | sha256sum -c -
COPY app/mailboxes/application_mailbox.rb /app/app/mailboxes/application_mailbox.rb
RUN bundle exec ruby -c app/mailboxes/application_mailbox.rb
ARG HOTFIX_REV
RUN printf '%s' "$HOTFIX_REV" > /app/.git_sha
LABEL org.opencontainers.image.source="https://github.com/iFixRobots/chatwoot"
