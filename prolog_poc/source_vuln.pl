:- module(source, [source_vuln/1]).

% Source Code description
source_vuln([
    stack(buffer_var2),
    func_call(
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
        getVariable,
        [
            arg(variableName_var2, variableName),
            arg(vendorGuid_var2, vendorGuid),
            arg(attributes_var2, attributes),
            arg(dataSize_var, dataSize),
            arg(buffer_var2, buffer)
    ]
    ),
    buffer_alloc(buffer_var2, dataSize_var)
]).
