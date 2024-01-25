:- use_module(uefi_axioms, [arg_in/2, arg_out/2, buffer_write/3]).

% sublist_between/3 extracts a sublist between Element1 and Element2
% in the given List and unifies it with Sublist.
sublist_between(Element1, Element2, List, Sublist) :-
    append(_, [Element1|Rest1], List),
    append(Sublist, [Element2|_], Rest1).

sublist_between_func_calls(List, Sublist, FuncCall1, FuncCall2) :-
    sublist_between(func_call(FunctionName, Args1), func_call(FunctionName, Args2), List, Sublist),
    FuncCall1 = func_call(FunctionName, Args1),
    FuncCall2 = func_call(FunctionName, Args2).

func_call_unzip(func_call(F, A), Function, Arguments) :- 
    Function = F, Arguments = A.

% Rule
stack_overflow(SourceCode) :-
    member(function_def(_, _, FunctionBody), SourceCode),

    % there are two calls to getVariable
    sublist_between_func_calls(FunctionBody, BetweenCallsCode, FuncCall1, FuncCall2),
    func_call_unzip(FuncCall1, Function, Args1),
    func_call_unzip(FuncCall2, Function, Args2),

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
    member(decl(BufferValue, stack), FunctionBody),
    % there is no memory alloc in between calls
    \+ member(
        buffer_alloc(BufferValue, _),
        BetweenCallsCode
    ).
