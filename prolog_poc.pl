% GetVariable description
arg_in(getVariable, variableName).
arg_in(getVariable, vendorGuid).
arg_in(getVariable, dataSize).
arg_out(getVariable, attributes).
arg_out(getVariable, dataSize).
arg_out(getVariable, buffer).
buffer_write(getVariable, buffer, dataSize).

% Source Code description
source_code([
    stack(main, buffer_var2),
    func_call(
        main,
        getVariable,
        [
            arg(variableName_var1, variableName),
            arg(vendorGuid_var1, vendorGuid),
            arg(attributes_var1, attributes),
            arg(dataSize_var, dataSize),
            arg(buffer_var1, buffer)
        ]
    ),
    func_call(
        main,
        getVariable,
        [
            arg(variableName_var2, variableName),
            arg(vendorGuid_var2, vendorGuid),
            arg(attributes_var2, attributes),
            arg(dataSize_var, dataSize),
        arg(buffer_var2, buffer)
    ]
    ),
    buffer_alloc(main, buffer_var2, dataSize_var)
]).

% Rule to check if there are at least two func_calls with the same first two parameters
% and FuncCall1 appears before FuncCall2 in the list
has_duplicate_func_calls(List, FuncCall1, FuncCall2) :-
    append(Prefix, [func_call(Func, Parent, Args1), func_call(Func, Parent, Args2)|_], List),
    
    FuncCall1 = func_call(Func, Parent, Args1),
    FuncCall2 = func_call(Func, Parent, Args2),
    Prefix \= [].

func_call_unzip(func_call(F, P, A), Function, Parent, Arguments) :- Function = F, Parent = P, Arguments = A.

% Rule to check if Element is between Y and Z in the list L
is_between(Element, X, Y, List) :-
    append(_, [X, Element, Y|_], List).

% Rule
stack_overflow(SourceCode) :-
    % there are two calls to getVariable
    has_duplicate_func_calls(SourceCode, FuncCall1, FuncCall2),
    func_call_unzip(FuncCall1, Parent, Function, Args1),
    func_call_unzip(FuncCall2, Parent, Function, Args2),
    
    % There is a parameter in/out
    arg_out(Function, DataSize),
    arg_in(Function, DataSize),
    
% both share the same DataSize parameter (we asume SSA)
    member(arg(DataSizeValue, DataSize), Args1),
    member(arg(DataSizeValue, DataSize), Args2),

    % The getVariable function writes in a buffer
    arg_out(Function, Buffer),
    buffer_write(Function, Buffer, DataSize),
    member(arg(BufferValue, Buffer), Args2),

    % the buffer is located in the stack
    member(stack(Parent, BufferValue), SourceCode),
    % there is no memory alloc in between calls
    \+ is_between(buffer_alloc(Parent, BufferValue, _), FuncCall1, FuncCall2, SourceCode).
