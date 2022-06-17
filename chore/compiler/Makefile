Q := @

TOKENIZER := tokenizer.erl
PARSER := parser.erl

compile: $(TOKENIZER) $(PARSER)

$(TOKENIZER): tokenizer.xrl
	$(Q) erlc -o $@ +'{verbose,true}' +'{report,true}' $<

$(PARSER): parser.yrl
	$(Q) erlc -o $@ +'{verbose,true}' +'{report,true}' $<

lang: compile
	$(Q) mkdir -p ebin
	$(Q) erlc -o ebin $(TOKENIZER)
	$(Q) erlc -o ebin $(PARSER)

play: lang
	$(Q) erl -pa ebin

clean:
	rm -fr ebin erl_crash.dump $(TOKENIZER) $(PARSER)
