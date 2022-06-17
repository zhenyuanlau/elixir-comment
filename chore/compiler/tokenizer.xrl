% <Header>

Definitions.

% <Macro Definitions>

D = [0-9]

Rules.

% <Token Rules>

{D}+ :
  {token,{integer,TokenLine,list_to_integer(TokenChars)}}.

Erlang code.

% <Erlang code>
