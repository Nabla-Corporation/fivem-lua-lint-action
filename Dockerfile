FROM evandarwin/lua:5.3.5
RUN luarocks install argparse && \
    luarocks install luafilesystem && \
    luarocks install luacheck

RUN mkdir -p /luacheck-fivem
ADD . /luacheck-fivem/
RUN apk add --no-cache yarn nodejs && \
    cd /luacheck-fivem/ && \
    yarn --prod --frozen-lockfile && yarn build && \
    chmod +x /luacheck-fivem/.docker/entrypoint.sh 
ENTRYPOINT ["/luacheck-fivem/.docker/entrypoint.sh"]
