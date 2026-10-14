# Preserve the exact backend/runtime image currently deployed by Beeper.
FROM chatwoot/chatwoot@sha256:b419dded7e9d2f54a24fd427b74ba7e6069d601b500618045c1eb6c01a1cc9a1 AS assets
WORKDIR /app
# Refuse to patch an image whose source differs from the tested release.
RUN echo '5b788e96dd705b67bf92b5983202e8320141c7bab3f15eaba38fae343bad8d49  app/javascript/shared/composables/useFilter.js' | sha256sum -c -
COPY app/javascript/shared/composables/useFilter.js app/javascript/shared/composables/useFilter.js
RUN ln -sf /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
 && ln -sf /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
 && npm install -g pnpm@10.2.0 \
 && pnpm install --frozen-lockfile --ignore-scripts
RUN SECRET_KEY_BASE=precompile_placeholder RAILS_LOG_TO_STDOUT=enabled bundle exec rake assets:precompile
ARG HOTFIX_REV
RUN printf '%s\n' "$HOTFIX_REV" > /app/.git_sha

FROM chatwoot/chatwoot@sha256:b419dded7e9d2f54a24fd427b74ba7e6069d601b500618045c1eb6c01a1cc9a1
WORKDIR /app
COPY --from=assets /app/public/vite /app/public/vite
COPY --from=assets /app/public/assets /app/public/assets
COPY --from=assets /app/app/javascript/shared/composables/useFilter.js /app/app/javascript/shared/composables/useFilter.js
COPY --from=assets /app/.git_sha /app/.git_sha
