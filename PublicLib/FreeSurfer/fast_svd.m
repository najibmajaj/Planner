function [u,s,v,M] = fast_svd(y,M)
% [u s v M] = fast_svd(y,<M>)
% 
% Computes efficient SVD when the number of rows and columns are
% not the same. It is efficient in the sense that only the minimum
% number of eigen components are computed. If M is supplied, then
% must be M = y*y' or M = y'*y depending upon the size of y.
%
% nmin = min(nrows,ncols)
% u will have dimension nrows by nmin
% v will have dimension ncols by nmin
% s will have dimension nmin by nmin
% 
% In any case, y = u*s*v';
%
% Note: all vectors are returned even if the corresponding value is 0
%
% $Id: fast_svd.m,v 1.6 2004/12/10 00:31:48 greve Exp $
%

u=[];
s=[];
v=[];

if(nargin < 1 | nargin > 2)
  fprintf('[u s v M] = fast_svd(y,<M>)\n');
  return;
end

[nr nc] = size(y);

if(nr == nc) 
  [u s v] = svd(y); 
  return;
end

if(nr > nc)
  if(~exist('M','var')) M = y'*y; end
  [v s blah] = svd(M);
  s = sqrt(s);
  % Could do: u = y*v*inv(s)), but inv(s) is just a scale factor
  % which will be removed during normalization
  u = y*v;
  uss2 = sqrt(sum(u.^2));
  u = u./repmat(uss2,[nr 1]);
  return;
end

% only gets here if(nr < nc)

if(~exist('M','var')) M = y*y'; end
[u s blah] = svd(M);
s = sqrt(s);
% Could do: v = y'*(u*inv(s)), but inv(s) is just a scale factor
% which will be removed during normalization
v = y'*u; 
vss2 = sqrt(sum(v.^2));
indnz = find(vss2~=0);
v(:,indnz) = v(:,indnz)./repmat(vss2(indnz),[nc 1]);

return;



