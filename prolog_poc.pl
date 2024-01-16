% GetVariable description
arg_in(getVariable, variableName).
arg_in(getVariable, vendorGuid).
arg_in(getVariable, dataSize).
arg_out(getVariable, attributes).
arg_out(getVariable, dataSize).
arg_out(getVariable, buffer).

buffer_write(_, getVariable, buffer, dataSize).

% Source Code description
stack(1, main, buffer).
func_call(2, main, getVariable).
func_call(4, main, getVariable).
buffer_alloc(_, main, buffer,_) :- false.
assign(3, main, dataSize, _).

% Rule
stack_overflow(X,Y) :-
    func_call(X, Parent, Func1),
    func_call(Y, Parent, Func1),
    arg_in(Func1, DataSize),
    arg_out(Func1, DataSize),
    arg_out(Func1, Buffer),
    stack(Z, Parent, Buffer), % ?
    \+ buffer_alloc(_, Parent, Buffer, _),
    buffer_write(_, Func1, Buffer, DataSize),
    (
        (
            assign(W, Parent, DataSize, _),
            (X > W; W > Y)
        );
        \+ assign(_, Parent, DataSize, _)
    ),
    X < Y,
    Z < X.
