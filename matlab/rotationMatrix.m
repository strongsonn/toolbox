% Performs different operations dealing with a rotation matrix
%
% USAGE
%  R = rotationMatrix( M )
%  [u,theta] = rotationMatrix( R )
%  R = rotationMatrix( theta )
%  R = rotationMatrix( u )
%  R = rotationMatrix( u, theta )
%  R = rotationMatrix( th1, th2, th3 )
%  R = rotationMatrix( R2 )
%
% INPUTS 1 - Finds the closest rotation matrix to a given matrix M
%  M       - 3x3 matrix
%
% INPUTS 2 - Extract the axis and the angle of a 3x3 rotation matrix
%  R       - 3x3 Rotation matrix
%
% INPUTS 3 - Creates a 2x2 rotation matrix from an angle
%  theta   - angle of rotation (radians)
%
% INPUTS 4 - Creates a 3x3 rotation matrix from a rotation vector
%  u       - 1x3 or 3x1 axis of rotation - norm is theta
%
% INPUTS 5 - Creates a 3x3 rotation matrix from a rotation vector
%  u       - axis of rotation
%  theta   - angle of rotation (radians)
%
% INPUTS 6 - Creates a 3x3 rotation matrix from 3 angles (around fixed
%            axes)
%  th1     - angle with respect to X axis
%  th2     - angle with respect to Y axis
%  th3     - angle with respect to Z axis
%      such that R = Rx*Ry*Rz
%
% INPUTS 7 - Creates the full 3x3 rotation matrix from its first 2 rows
%  R       - 2x3 first two rows of the rotation matrix
%
% INPUTS 8 - Extract the 3 angles of a 3x3 rotation matrix
%  R       - 3x3 Rotation matrix
%
% OUTPUTS 1,4,5,6,7
%  R       - 3x3 rotation matrix
%
% OUTPUTS 2
%  u       - axis of rotation
%  theta   - angle of rotation (radians)
%
% OUTPUTS 3
%  R       - 2x2 Rotation matrix
%
% OUTPUTS 8
%  th1     - angle with respect to X axis
%  th2     - angle with respect to Y axis
%  th3     - angle with respect to Z axis
%     such that R = Rx*Ry*Rz
%
% EXAMPLE 1
%  R3 = rotationMatrix( [0 0 1], pi/4 )+rand(3)/50
%  R3r = rotationMatrix( R3 )
%  [u,theta]  = rotationMatrix( R3r )
%
% EXAMPLE 2
%  R3 = rotationMatrix( [0 0 1], pi/4 );
%  [u,theta]  = rotationMatrix( R3 )
%
% EXAMPLE 3
%  R2 = rotationMatrix( pi/4 )
%
% EXAMPLE 4
%  R3 = rotationMatrix( [0 0 .5] )
%
% EXAMPLE 5
%  R3 = rotationMatrix( [0 0 1], pi/4 )
%
% EXAMPLE 6
%  R3 = rotationMatrix( pi/4,pi/4,0 )
%
% EXAMPLE 7
%  R3 = rotationMatrix( pi/4,pi/4,0 )
%  R3bis = rotationMatrix( R3(1:2,:) )
%
% EXAMPLE 7
%  [th1 th2 th3] = rotationmatrix( rotationMatrix( pi/4,pi/4,0 ) );
%
% EXAMPLE 8
%  [th1 th2 th3]=rotationMatrix(rotationMatrix(1,2,3))
%
% See also

% Piotr's Image&Video Toolbox      Version 2.02
% Copyright (C) 2007 Piotr Dollar.  [pdollar-at-caltech.edu]
% Please email me if you find bugs, or have suggestions or questions!
% Licensed under the Lesser GPL [see external/lgpl.txt]

function varargout=rotationMatrix(varargin)

%%% Find the closest orthonormal matrix
if all(size(varargin{1})==[3 3]) && nargout<=1
  [U,S,V]=svd(varargin{1});
  varargout{1}=U*V';
  return
end

%%% Takes a rotation matrix and extracts the rotation angle and axis.
if all(size(varargin{1})==[3 3]) && nargout==2
  r = vrrotmat2vec(varargin{1});
  varargout{1} = r(1:3)';
  varargout{2} = r(4);
  return
end

%%% Returns the matrix: R=[cos(t) -sin(t); sin(t) cos(t)].
if all(size(varargin{1})==[1 1])  && nargin<=1
  theta=varargin{1};
  varargout{1}=[cos(theta) -sin(theta); sin(theta) cos(theta)];
  return
end

%%% Uses Rodrigues's formula to create a 3x3 rotation matrix R.
if all(sort(size(varargin{1}))==[1 3])
  if size(varargin{1},1) == 3; varargin{1}=varargin{1}'; end
  if nargin==1; th=norm(varargin{1}); else th=varargin{2}; end
  varargout{1} = makehgtform('axisrotate',varargin{1},th);
  return
end

%%% creates a 3x3 rotation matrix from 3 angles (around fixed axes)
if nargin==3
  M = makehgtform('xrotate',varargin{1},'yrotate',varargin{2},...
    'zrotate',varargin{3});
  varargout{1}=M(1:3,1:3);
  return
end

%%% creates the full 3x3 rotation matrix from its first 2 rows
if all(size(varargin{1})==[2 3])
  R=varargin{1}; R(3,:)=cross(R(1,:),R(2,:));
  if det(R)<0; R(3,:)=-R(3,:); end
  varargout{1}=R;
  return
end

%%% recover the 3 rotation angles
if all(size(varargin{1})==[3 3]) && nargout==3
  R=varargin{1};
  varargout{2}=pi-asin(R(1,3)); temp = cos(varargout{2});
  varargout{3}=atan2(-R(1,2)/temp,R(1,1)/temp);
  varargout{1}=atan2(-R(2,3)/temp,R(3,3)/temp);
  for i=1:3; varargout{i}=mod(varargout{i},2*pi); end
  return
end

error('Input format not supported');
