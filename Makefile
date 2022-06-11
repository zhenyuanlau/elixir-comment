ELIXIRC := bin/elixirc --ignore-module-conflict $(ELIXIRC_OPTS)
ERLC := erlc
ERL_MAKE := if [ -n "$(ERLC_OPTS)" ]; then ERL_COMPILER_OPTIONS=$(ERLC_OPTS) erl -make; else erl -make; fi
ERL := erl -noshell -pa ebin
GENERATE_APP := $(CURDIR)/generate_app.escript
VERSION := $(strip $(shell cat VERSION))
Q := @

.PHONY: compile erlang elixir unicode app clean clean_elixir clean_residual_files
.NOTPARALLEL: compile

#==> Functions

define CHECK_ERLANG_RELEASE
	erl -noshell -eval '{V,_} = string:to_integer(erlang:system_info(otp_release)), io:fwrite("~s", [is_integer(V) and (V >= 23)])' -s erlang halt | grep -q '^true'; \
		if [ $$? != 0 ]; then \
		  echo "At least Erlang/OTP 23.0 is required to build Elixir"; \
		  exit 1; \
		fi
endef

#==> Compilation tasks

APP := ebin/elixir.app
PARSER := src/elixir_parser.erl
KERNEL := ebin/Elixir.Kernel.beam
UNICODE := ebin/Elixir.String.Unicode.beam

default: compile

compile: erlang $(APP) elixir

erlang: $(PARSER)
	$(Q) if [ ! -f $(APP) ]; then $(call CHECK_ERLANG_RELEASE); fi
	$(Q) mkdir -p ebin && $(ERL_MAKE)

$(PARSER): src/elixir_parser.yrl
	$(Q) erlc -o $@ +'{verbose,true}' +'{report,true}' $<

elixir: stdlib

stdlib: $(KERNEL) VERSION

$(KERNEL): lib/*.ex lib/*/*.ex lib/*/*/*.ex
	$(Q) if [ ! -f $(KERNEL) ]; then \
		echo "==> bootstrap (compile)"; \
		$(ERL) -s elixir_compiler bootstrap -s erlang halt; \
	fi
	$(Q) $(MAKE) unicode
	@ echo "==> elixir (compile)";
	$(Q) $(ELIXIRC) "lib/**/*.ex" -o ebin;
	$(Q) $(MAKE) app

app: $(APP)
$(APP): src/elixir.app.src ebin VERSION $(GENERATE_APP)
	$(Q) $(GENERATE_APP) $< $@ $(VERSION)

unicode: $(UNICODE)

$(UNICODE): unicode/*
	@ echo "==> unicode (compile)";
	$(Q) $(ELIXIRC) unicode/unicode.ex -o ebin;
	$(Q) $(ELIXIRC) unicode/security.ex -o ebin;
	$(Q) $(ELIXIRC) unicode/tokenizer.ex -o ebin;

clean:
	rm -rf ebin
	rm -rf $(PARSER)
	$(Q) $(MAKE) clean_residual_files

clean_elixir:
	$(Q) rm -f ebin/Elixir.*.beam

clean_residual_files:
	rm -f erl_crash.dump
