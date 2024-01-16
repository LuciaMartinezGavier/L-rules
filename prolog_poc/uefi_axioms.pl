:- module(uefi_axioms, [arg_in/2, arg_out/2, buffer_write/3]).

% GetVariable description
arg_in(getVariable, variableName).
arg_in(getVariable, vendorGuid).
arg_in(getVariable, dataSize).
arg_out(getVariable, attributes).
arg_out(getVariable, dataSize).
arg_out(getVariable, buffer).
buffer_write(getVariable, buffer, dataSize).
