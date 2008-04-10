% xformSurfaceWorld2Array.m
%
%        $Id$
%      usage: surf = xformSurfaceWorld2Array(surf,hdr)
%         by: justin gardner
%       date: 04/10/08
%    purpose: This function transforms the surface
%             coordinates loaded by loadSurfOFf into
%             array coordinates that specify the
%             voxel number in 1-based matlab coordinates
%             in the 3D anatomy. surf is a surface
%             returned by loadSurfOFF
%
function surf = xformSurfaceWorld2Array(surf,hdr)

% check arguments
if ~any(nargin == [2])
  help xformSurfaceWorld2Array
  return
end

% use jonas' function to get the world2array xform
world2array = mlrXFormFromHeader(hdr,'world2array');

% check to see if we have already xformd or not
if isfield(surf,'originalVtcs')
  vtcs = surf.originalVtcs;
else
  % if this is the first time, then get the vtcs
  % and save an original copy
  vtcs = surf.vtcs;
  surf.originalVtcs = vtcs;
end
% make into homogeneous coords
vtcs(:,4) = 1;
% now do conversion
vtcs = world2array*vtcs';
% and add 1 to convert from C-style 0 offset to Matlab-style 1 offset
vtcs(1:3,:) = vtcs(1:3,:)+1;
% and store them back as the vtcs
surf.vtcs = vtcs(1:3,:)';
