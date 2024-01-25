:- module(source_novuln, [source_novuln/1]).
/*
int main(){
    char buffer;
    GetVariable (VariableName, VendorGuid, Attributes, DataSize, Data);
    DataSize_1 = f(DataSize);
    GetVariable (VariableName1, VendorGuid1, Attributes1, DataSize_1, Data1);
}
*/

% Source Code description
source_novuln(
    [function_def(
        main,
        [],
        [
            decl(buffer_var2, stack),
            func_call(
                getVariable,
                [
                    arg(variableName_var1, variableName),
                    arg(vendorGuid_var1, vendorGuid),
                    arg(attributes_var1, attributes),
                    arg(dataSize_var1, dataSize),
                    arg(buffer_var1, buffer)
                ]
            ),
            assign(
                dataSize_var2,
                func_call(
                    f,
                    [arg(dataSize_var1, f_param)]
                )
            ),
            func_call(
                getVariable,
                [
                    arg(variableName_var2, variableName),
                    arg(vendorGuid_var2, vendorGuid),
                    arg(attributes_var2, attributes),
                    arg(dataSize_var2, dataSize),
                    arg(buffer_var2, buffer)
                ]
            ),
            buffer_alloc(buffer_var2, dataSize_var)
        ]
    )]
).
