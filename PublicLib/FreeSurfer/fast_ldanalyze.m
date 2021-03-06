function [vol, hdr] = fast_ldanalyze(volid)
% [vol, hdr] = fast_ldanalyze(volid)
%
% Uses spm functions, so you have to have spm installed and
% in your path.
%
% vol is nslices, nrow, ncols
% vol does not have multiple time points because spm cannot
% read them.

vol = [];
hdr = [];

if(nargin ~= 1)
  fprintf('USAGE: [vol, hdr] = fast_ldanalyze(volid)\n');
  return;
end

anafile = sprintf('%s.img',volid);

[DIM VOX SCALE TYPE OFFSET ORIGIN DESCRIP] = spm_hread(anafile);
if(isempty(DIM))
  fprintf('ERROR: could not read %s header\n',anafile);
  return;
end

hdr.dim = DIM;
hdr.vox = VOX;
hdr.scale = SCALE;
hdr.type = TYPE;
hdr.offset = OFFSET;
hdr.origin = ORIGIN;
hdr.descrip = DESCRIP;

volspec = spm_vol(anafile);
if(isempty(volspec))
  fprintf('ERROR: could not read %s voxel data\n',anafile);
  return;
end

fprintf('INFO: Loading %s\n',anafile);
vol = spm_read_vols(volspec);
if(isempty(vol))
  fprintf('ERROR: could not load %s voxel data\n',anafile);
  return;
end

vol = permute(vol,[3 2 1]);

return;
