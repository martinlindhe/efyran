lint:
    luacheck . --exclude-files mq-definitions

test:
    lua ezmq_test.lua

deps:
    echo "Update dependencies ..."
    git pull --recurse-submodules
