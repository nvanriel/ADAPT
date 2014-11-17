function [sourceVal, sourceStd, val, std] = dataSum(A, B)

sourceVal = A.source.val + B.source.val;
sourceStd = A.source.std + B.source.std;
val = A.val + B.val;
std = A.std + B.std;