:- module(source_novuln, [source_novuln/1]).
/*
int main(){
    char buffer;
    GetVariable (VariableName, VendorGuid, Attributes, DataSize, Data);
    DataSize_1 = f(DataSize);
    GetVariable (VariableName1, VendorGuid1, Attributes1, DataSize_1, Data1);
}
*/

stack(buffer_var2).
func_call(
    1,
    getVariable,
    [
        variableName_var1,
        vendorGuid_var1,
        attributes_var1,
        dataSize_var1,
        buffer_var1
    ]
).
assign(
    2,
    dataSize_var2,
    func_call(f, [dataSize_var1])
).
func_call(
    3,
    getVariable,
    [
        variableName_var2,
        vendorGuid_var2,
        attributes_var2,
        dataSize_var2,
        buffer_var2
    ]
).