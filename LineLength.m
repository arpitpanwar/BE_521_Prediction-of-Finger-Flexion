function [ ll ] = LineLength( x )
	ll = sum(abs(diff(x)));

end

