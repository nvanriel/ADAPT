function s = prin(fmt,varargin)
%
% prin.m:  An alternative to sprintf() & fprintf() - version 3Dec13
%          Calls Pftoa.m
%
% Calling sequence: ------------------------------
% s = prin(FormatString,OptionalArguments)
%               or
% s = prin(FileID,FormatString,OptionalArguments)
%
% Author:  Paul Mennen (paul@mennen.org)
%          Copyright (c) 2013, Paul Mennen

s = '';
if isnumeric(fmt)                                             % is 1st argument a FileID or a file name?
  s = prin(varargin{:});                                      % yes, come here
  if length(fmt)>1                                            % is the first argument a file name?
       if fmt(1)>0 p = 'at'; else p = 'wt'; fmt=-fmt; end;    % yes, come here (+/- = append/write)
       fmt = fopen(char(fmt),p); fwrite(fmt,s); fclose(fmt);
  else fwrite(fmt,s);                                         % no, come here if it's a FileID
  end;
  return;
end;
fmt = strrep(strrep(fmt,'\{','\173'),'\}','\175'); % replace \{ and \} with octal codes
p = find(fmt=='{');                     % search for last repeat block
while length(p)                         % keep going until all {} repeat blocks are expanded
  p = p(end);  v = p;                   % p points to left bracket, v points to repeat count
  q = find(fmt(p:end)=='}');
  if isempty(q) disp('unmatched { in format string'); return; end;
  q = q(1)+p;                           % point to character after matching end brace
  bb = fmt(p+1:q-2);                    % contents between the braces
  r = fmt(max(1,p-1))-48;               % get single digit repeat count
  if r>=0 & r<=9                        % valid repeat count.
       v = v-1;
       if p>2 r2 = fmt(p-2)-48;                                 % is this a 2 digit repeat count?
              if r2>=0 & r2<=9  v=v-1; r=r+10*r2; end;          % if yes, compute new repeat count
       end;
       bb = repmat(bb,1,r);                                     % replicate the repeat block
       e = find(bb=='!');                                       % find all the explanation points
       if length(e) bb([e e(end)+1:end]) = []; end;             % remove all ! & text after the last !
       fmt = [fmt(1:v-1) bb fmt(q:end)];                        % insert the replicated text
  else if length(find(bb=='%'))~=1 | r==46 | r==47              % no valid repeat count
            fmt = [fmt(1:p-1) '\173' bb '\175' fmt(q:end)];     % assume normal text (super/subscripts)
       else fmt = [fmt(1:p-1) 'LbRaCe' bb 'RbRaCe' fmt(q:end)]; % assume vector format (exactly one %)
       end;
  end;
  p = find(fmt=='{');                   % cycle thru all repeat blocks (back to front order)
end;  % end while length(p)
fmt = strrep(strrep(fmt,'LbRaCe','{'),'RbRaCe','}'); % change back to braces around the delimiters
p = find(fmt=='%');     % search for '%' format codes
q = find(diff(p)==1);   % search for '%%'
while length(q) p(q(1):q(1)+1) = []; q = find(diff(p)==1); end; % remove all '%%' from the list
n = length(p);          % number of format codes
nn = length(fmt);       % length of fmt argument
codes = 'vVwWscdiouxXfeEgG';
c = cell(1,n+1);        % will contain all the characters of fmt with format strings removed
f = cell(1,n);          % will contain all the format strings contain in fmt
ws = zeros(1,n);        % used to save the code index associated with f{n}
g=f; d=f; e=ws;         % f,d has format text surrounding bracketed format string f{k}. e has position of '!'
cb = 1;                 % point to beginning of next c{} string
for k=1:n               % extract the n format strings into f{1} to f{n}
  q = p(k);  w = '';    % q is the location of the % sign for this format string
  c{k} = fmt(cb:q-1);   % save format text between f{k-1} and f{k} (not including format strings)
  lb = find(c{k}=='{'); % pointer to left bracket
  if length(lb)
    lb = lb(1);
    g{k} = sprintf(c{k}(lb+1:end));  % remove first part of bracketed format from c and put it in g
    c{k} = c{k}(1:lb-1);
  end;
  for j=q+1:nn         % search for the format code (i.e. the end of the format string)
    w = find(codes==fmt(j));
    if length(w) break; end;
  end;
  if isempty(w) disp(sprintf('sprint: Unknown format code starting with %s',fmt(q:end))); return; end;
  ws(k) = w;               % save format code index
  f{k} = ['%' fmt(q+1:j)]; % save format string from the '%' to the format code
  cb = j+1;
  if length(lb)
    w = find(fmt(cb:end)=='}');
    if isempty(w) disp('unmatched { in format string'); return; end;
    w = w(1) + cb;                  % point to character after the matching right brace
    d{k} = sprintf(fmt(cb:w-2));    % the remaining portion of the bracket vecotr format
    ek = find(d{k}=='!');           % search for delimiter character
    if length(ek) d{k} = strrep(strrep(d{k},'!row','! ~, '),'!col','! ~; ');
                  ek=ek(1); e(k)=ek; d{k}(ek)=[];    % if found, record its position and remove it
    else          e(k) = length(d{k})+1;             % nonzero indicates a bracket vector format
    end;
    cb = w;
  end;
end;  % end for k=1:n
if cb<=nn c{n+1} = sprintf(fmt(cb:nn)); end;         % save format text that follows the last format string
for k=1:n c{k} = sprintf(c{k}); end;                 % sprintf conversions (e.g. \t to tab character)
s = c{1};  q = 1;                                    % q points to the next format string
na = length(varargin);
if na & ~n disp('prin() warning: No format codes. Variables not converted.'); na=0; end;
for k=1:na                                           % cycle thru all the arguments
  arg = varargin{k};
  if e(q)>0
    arg = arg(:);  nb = length(arg);                 % bracket vector format comes here
    for j=1:nb                                       % loop thru each number in the vector
      ft = Pftoa(f{q},arg(j));                       % convert the next number in the vector to ascii
      if j<nb s = [s g{q} ft d{q}];                  % surround the number with left and right text (g,d)
      else    s = [s g{q} ft d{q}(1:e(q)-1) c{q+1}]; % for last vector element, don't include the delimiter
      end;
    end;
    q = q + 1;                                       % advance to next format string
    if q>n & k<na q=1; s=[s c{1}]; end;              % reuse the format string from the beginning
  else                                               % here for not a bracket vector format
    if ws(q)==5 s = [s sprintf(f{q},arg) c{q+1}];    % here for %s format
                q = q + 1;                           % advance to next format string
                if q>n & k<na q=1; s=[s c{1}]; end;  % reuse the format string
    else                                             % here for all other formats (except %s)
      arg = arg(:);  nb = length(arg);
      for j=1:nb                                     % cycle thru each element of next argument
        s = [s Pftoa(f{q},arg(j)) c{q+1}];           % conversion with Pftoa
        q = q + 1;                                   % advance to next format string
        if q>n & (j<nb | k<na) q=1; s=[s c{1}]; end; % reuse the format string from the beginning
      end;    % end for j=1:nb
    end;      % end if ws(q)==5
  end;        % end if e(k)>=0
end;          % end for k=1:na
pr = findstr(s,' ~, '); pc = findstr(s,' ~; ');      % find the cell array row & column separators
n = length(pr) + length(pc);
if ~n return; end;                                   % return if cell seperators were not used
pp = sort([pr pc+.1 length(s)+1]);  p = round(pp);   % fractional part indicates column marker
row = 1;  col = 1;  c = s;  s = [];  p2 = -3;
for k = 1:n+1                                        % break the output string into a cell array
  p1 = p2;  p2 = p(k);                               % p1/p2 are previous and current separator locations
  s{row,col} = c(p1+4:p2-1);                         % exclude the separator characters
  if p2==pp(k) col=col+1; else col=1; row=row+1; end; % advance column or row as appropriate
end; 
% end function prin
