function writeFile(fn, content)

fid = fopen(fn, 'w');
fprintf(fid, content);
fclose(fid);