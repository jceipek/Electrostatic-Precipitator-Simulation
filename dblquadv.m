% Attempt at a dblquadv.  It works... ?

function Q = dblquadv(intfcn,xmin,xmax,ymin,ymax,tol,quadf,varargin)
%DBLQUAD Numerically evaluate double integral over a rectangle. 
%   Q = DBLQUAD(FUN,XMIN,XMAX,YMIN,YMAX) evaluates the double integral of
%   FUN(X,Y) over the rectangle XMIN <= X <= XMAX, YMIN <= Y <= YMAX. FUN
%   is a function handle. The function Z=FUN(X,Y) should accept a vector X
%   and a scalar Y and return a vector Z of values of the integrand.
%
%   Q = DBLQUAD(FUN,XMIN,XMAX,YMIN,YMAX,TOL) uses a tolerance TOL instead
%   of the default, which is 1.e-6.
%
%   Q = DBLQUAD(FUN,XMIN,XMAX,YMIN,YMAX,TOL,@QUADL) uses quadrature
%   function QUADL instead of the default QUAD.
%   Q = DBLQUAD(FUN,XMIN,XMAX,YMIN,YMAX,TOL,MYQUADF) uses your own
%   quadrature function MYQUADF instead of QUAD. MYQUADF is a function
%   handle. MYQUADF should have the same calling sequence as QUAD and
%   QUADL. Use [] as a placeholder to obtain the default value of TOL.
%   QUADGK is not supported directly as a quadrature function for 
%   DBLEQUAD, but it can be called from MYQUADF.
%
%   Example:
%   Integrate over the square pi <= x <= 2*pi, 0 <= y <= pi:
%      Q = dblquad(@(x,y)y*sin(x)+x*cos(y), pi, 2*pi, 0, pi) 
%   or:
%      Q = dblquad(@integrnd, pi, 2*pi, 0, pi)
%   where integrnd is the M-file function:
%      %-------------------------% 
%      function z = integrnd(x, y)
%      z = y*sin(x)+x*cos(y);  
%      %-------------------------% 
%
%   Note the integrand can be evaluated with a vector x and a scalar y.
%
%   Nonsquare regions can be handled by setting the integrand to zero
%   outside of the region.  The volume of a hemisphere is:
%
%      V = dblquad(@(x,y) sqrt(max(1-(x.^2+y.^2),0)),-1,1,-1,1)
%   or
%      V = dblquad(@(x,y) sqrt(1-(x.^2+y.^2)).*(x.^2+y.^2<=1),-1,1,-1,1)
%
%   Class support for inputs XMIN,XMAX,YMIN,YMAX and the output of FUN:
%      float: double, single
%
%   See also QUAD2D, QUAD, QUADL, QUADGK, TRIPLEQUAD, TRAPZ, FUNCTION_HANDLE.

%   Copyright 1984-2008 The MathWorks, Inc.
%   $Revision: 1.15.4.6 $  $Date: 2008/10/31 06:19:54 $

if nargin < 5, error('MATLAB:dblquad:NotEnoughInputs',...
                     'Requires at least five inputs.'); end
if nargin < 6 || isempty(tol), tol = 1.e-6; end 
if nargin < 7 || isempty(quadf)
    quadf = @quadv;
else
    quadf = fcnchk(quadf);
end
intfcn = fcnchk(intfcn);

trace = [];

Q = quadf(@innerintegral, ymin, ymax, tol, trace, intfcn, ...
           xmin, xmax, tol, quadf, varargin{:}); 

%---------------------------------------------------------------------------

function Q = innerintegral(y, intfcn, xmin, xmax, tol, quadf, varargin) 
%INNERINTEGRAL Used with DBLQUAD to evaluate inner integral.
%
%   Q = INNERINTEGRAL(Y,INTFCN,XMIN,XMAX,TOL,QUADF)
%   Y is the value(s) of the outer variable at which evaluation is
%   desired, passed directly by QUAD. INTFCN is the name of the
%   integrand function, passed indirectly from DBLQUAD. XMIN and XMAX
%   are the integration limits for the inner variable, passed indirectly
%   from DBLQUAD. TOL is passed to QUAD (QUADL) when evaluating the inner 
%   loop, passed indirectly from DBLQUAD. The function handle QUADF
%   determines what quadrature function is used, such as QUAD, QUADL
%   or some user-defined function.

% Evaluate the inner integral at each value of the outer variable. 

fcl = intfcn(xmin, y(1), varargin{:}); %evaluate only to get the class below
Q = zeros(length(y),length(fcl));

trace = [];
for i = 1:length(y) 
    Q(i,:) = quadf(intfcn, xmin, xmax, tol, trace, y(i), varargin{:}); 
end 
