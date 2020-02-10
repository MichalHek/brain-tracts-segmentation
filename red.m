function [ ReducedSetSize, redrate ] = red( FiberNum, linear_reduction ,redratesnum)
if linear_reduction
    ReducedSetSize = ceil(linspace(FiberNum,FiberNum/10,redratesnum)); % linear
    redrate = FiberNum./ReducedSetSize;
else
    redrate = 1:1:redratesnum;
    ReducedSetSize = round(FiberNum./redrate);% exponential
end
end

