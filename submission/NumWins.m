function [ wins ] = NumWins( xLen,fs,winLen,winDisp )

    wins = ((1/fs)*xLen - winLen +winDisp)/winDisp;
    
end

