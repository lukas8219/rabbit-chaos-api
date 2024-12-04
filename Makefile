PROJECT = rabbit_chaos
PROJECT_DESCRIPTION = Rabbit Chaos
PROJECT_MOD = rabbit_chaos

RABBITMQ_VERSION ?= v3.12.x
current_rmq_ref = $(RABBITMQ_VERSION)

dep_rabbit_common              = git_rmq-subfolder rabbitmq-common $(RABBITMQ_VERSION)
dep_rabbit                     = git_rmq-subfolder rabbitmq-server $(RABBITMQ_VERSION)

DEPS = rabbit_common rabbit cowboy jiffy
dep_jiffy = hex 1.1.2
TEST_DEPS = rabbitmq_ct_helpers rabbitmq_ct_client_helpers


DEP_EARLY_PLUGINS = rabbit_common/mk/rabbitmq-early-plugin.mk
DEP_PLUGINS = rabbit_common/mk/rabbitmq-plugin.mk cowboy

# FIXME: Use erlang.mk patched for RabbitMQ, while waiting for PRs to be
# reviewed and merged.

ERLANG_MK_REPO = https://github.com/rabbitmq/erlang.mk.git
ERLANG_MK_COMMIT = rabbitmq-tmp

include rabbitmq-components.mk
include erlang.mk
