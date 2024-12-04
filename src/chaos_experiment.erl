-module(chaos_experiment).

-callback execute(Metadata :: map()) -> ok.