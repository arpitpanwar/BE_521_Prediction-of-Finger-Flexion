function [ wins ] = NumWins( xLen,fs,winLen,winDisp )
%NUMWINS Summary of this function goes here
%   Detailed explanation goes here
    
    wins = ((1/fs)*xLen - winLen +winDisp)/winDisp;
    
end

