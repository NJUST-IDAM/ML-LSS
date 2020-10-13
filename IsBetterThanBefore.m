function [r] = IsBetterThanBefore(Result,CurrentResult)
    a = CurrentResult(1,1) + CurrentResult(1,2)  + CurrentResult(1,3) + CurrentResult(1,4) - CurrentResult(1,5);
    b = Result(1,1) + Result(1,2) + Result(1,3) + Result(1,4) - Result(1,5);
    if a < b
       r =1;
    else
        r = 0;
    end
   
end