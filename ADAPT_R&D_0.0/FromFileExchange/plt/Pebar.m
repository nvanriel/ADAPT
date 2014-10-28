function e = ebar(x,y,l,u,dx)
% ebar(x,y,l,u,dx) - creates error bars for plotting (vertical bars
%                    with horizontal "T" sections top and bottom)
%
% If the input arguments are vectors, then ebar returns a complex
% vector e that displays a set of error bars (all in a single color)
% when plotted with plt or plot. If the input arguments are matrices
% with n columns, then ebar returns a complex matrix e with n columns,
% so that n sets of vertical bars are plotted in n different colors
% (one color for each column of the inputs)
%
%   x,y : reference coordinates for the error bars
%         (often on or near the middle of each error bar)
%   l,u : vertical distance of the lower/upper ends respectively
%         of the error bar from the reference location
%   dx  : width of the error bar (in percent of the average x spacing)
%
%   Top    error bar position  = y+u
%   Bottom error bar position  = y-l
%   Error bar width            = .01 * dx * average x spacing
% 
%   if x,y,l,u are column or row vectors
%     - returns a complex column vector (9 times as long as x)
%
%   if x,y,l,u are matrices
%     - returns a complex matrix with the same number of columns
%       as x and nine times as many rows
%
%   x,y,l,u all must be the same size.
%   (Although y,l, and u are allowed to be scalar.)
%
%   By default (fewer than 5 arguments) the error bar width is
%   30% of the average x axis spacing.
%
%   If only 3 arguments are given, the error bars are centered
%   around the reference y values (i.e. u = l).
%
% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org


switch nargin
  case 3,  dx = 30;  u = l;
  case 4,  dx = 30;
end;

[n,nc] = size(x);
if length(y)==1 y = y+zeros(n,nc); end; % allow y to be scaler

if n==1  % special case if one row
  x = x(:); y = y(:); l = l(:); u = u(:); % turn rows into columns
  n = nc;  nc = 1;
end;

dx = .005 * dx * (max(x(:))-min(x(:)))/n;  % half the error bar width

r = zeros(9*n,nc) + NaN;
i = r;

f = repmat(9*(0:n-1),1,6)';
g = repmat([1 2 4 7 8 5],n,1);
h = repmat([1 5 2 7 4 8],n,1);

r(f+g(:),:) = repmat([x-dx;x+dx;x],2,1); 
i(f+h(:),:) = repmat([y+u;y-l],3,1);
e = complex(r,i);
