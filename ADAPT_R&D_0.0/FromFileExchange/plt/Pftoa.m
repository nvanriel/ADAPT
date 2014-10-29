function s = ftoa(fmtstr,val) % floating point to ascii convertion - called by prin.m
%
% ftoa.m:  Alternative number conversion formatting - version 3Dec13
% Author:  Paul Mennen (paul@mennen.org)
%          Copyright (c) 2013, Paul Mennen
%
% returns a string representing the number val using the format specified by fmtstr
%.
% fmtstr: format description string
% val:    the number to be converted to ascii

%
% fmtstr in the form '%nV' --------------------------------------------
% n: the field width
% s: the string representation of x with the maximum resolution possible
%    while using at exactly n characters.
%
% fmtstr in the form '%nv' ---------------------------------------------
% n: the field width, not counting decimal point (since it's so skinny)
% s: the string representation of x with the maximum resolution possible
%    while using at exactly n+1 characters. (If a decimal point is not
%    needed, then only n characters will be used).
%
% fmtstr in the form '%nW' ---------------------------------------------
% n: the field width
% s: the string representation of x with the maximum resolution possible
%    while using at most n characters.
%
% fmtstr in the form '%nw' ---------------------------------------------
% n: the field width, not counting decimal point (since it's so skinny)
% s: the string representation of x with the maximum resolution possible
%    while using at most n+1 characters.
%
% For any of the VWvw formats, if the field width is too small to allow
% even one significant digit, then '*' is returned.
%
% If the format code is not one of the four characters VWvw then use
% the sprintf c conventions: s=sprintf(fmtstr,number);
% e.g.  ftoa('%7.2f',value) is identical to sprintf('%7.2f',value).


% BACKGROUND: ---------------------------------------------------------------
% ftoa() expands on the number conversion capabilities of sprintf's d,f,e,g
% conversion codes (which are identical to the c language conventions). These
% formats are ideal for many situations, however the fact that these formats
% will sometimes output more characters than the specified field width make
% them inappropriate when used to generate a number that is displayed in a
% fixed sized GUI element (such as an edit box) or in a table of numbers
% arranged in fixed width columns. This motivated the invention of ftoa's new
% V and W formats. With the e & g formats one is often forced to specify a very
% small number of signifcant digits since otherwise on the possibly rare
% occations when the numbers are very big or very small an unintelligable
% display is produced in the GUI, or the generated table becomes hopelessly
% misallined. For example, suppose a column of numbers of width 8 characters
% normally contains numbers that look something like 1.234567 but could
% occationally contain a number such as 7.654321E-100. The best you could
      % do with a g format would be '%8.2g' which would produce the strings
% 1.2 and 7.6E-100 which means the numbers we see most often are truncated
% far more than necessary. Essentially with the e and g formats, you specify
% the precision you want and you accept whatever size string is produced.
% With the V and W formats, this is turned around. You specify the length
% of the string you want, and ftoa supplies as much precision as possible
% with this constraint.
%
% For displaying columns of numbers (using a fixed spaced font) the V format
% is best since it always outputs a character string of the specified length.
% For example, the format string '%7V' will output seven characters. Never
% less and never more.
%
% For displaying a number in an edit box the W format is best. For example
% '%7W' will output at most seven characters, although it will output fewer
% than 7 characters if this does not reduce the precision of the output.
% For example, the integer "34" will be displayed with just two characters
% (instead of padding with blanks like the V format does). Since the text
% in an edit box is most often center aligned, this produces a more pleasing
% result. Using a lower case w (i.e. the '%7w' format) behaves similarly
% except that periods are not counted in the character count. This means
% that if a decimal point is needed to represent the number, 8 characters
% will be output and if a decimal point is not included in the representation
% then only 7 characters are output. This is most useful when using
% proportional width fonts. The period is not counted because the character
% width of the period is small compared with the '0-9' digits. Actually
% since most GUIs are rendered using proportially spaced fonts, the w format
% is used more often than the W format.
%
if nargin ~= 2
  disp('Calling sequence: resultString = ftoa(formatString,val)');
  if nargin==1 % Call with just one argument to run ftoa test code
    [fi pth] = uiputfile('ftoaTEST.txt','Select a file to save the test output. Hit Cancel to abort');
    if isnumeric(fi) disp('ftoa test aborted'); ftoa; return; end;
     fi = fopen([pth fi],'wt');                                % open file to contain test output
     a = [9;2.1;3.99;4.012;5.9876;6.54321;7.065432;8.7654321]; % generate test values
    a = a * [1e-105 1e-50 1e-5 1e-4 .001 .01 .1 1 10 100 1e3 1e4 1e5 1e6 1e7 1e8 1e9 1e10 1e105];
    a = [0; NaN; a(:); -a(:)];                                 % 306 test values in total
    fc = 'WwVv';  fm = '%c:%5s%6s%7s%8s%9s%10s%11s%12s%13s\n';
    f = cell(4,9);  s = cell(1,9);  sep = [prin('%d{=}  ',2:12) '\n'];
    c = '%%1W ~, %%2W ~, %%3W ~, %%4W ~, %%5W ~, %%6W ~, %%7W ~, %%8W ~, %%9W';
    for m=1:4 f(m,:) = prin(strrep(c,'W',fc(m))); end;         % generate the 36 ftoa format codes
    prin(fi,['Each number is printed 37 times using the following formats:\n\n' sep '85{ }%%1.8g\n']);
    for m=1:4 prin(fi,fm,fc(m),f{m,:}); end;  prin(fi,sep);    % print the format codes that will be used
    for j = 1:length(a)                                        % loop 306 times
      prin(fi,'\ng:83{ }%1.8g\n',a(j));                        % print test value using a g format
      for m = 1:4                                              % use W,w,V,v formats on successive lines
        for k = 1:9  s{k} = prin(['(' f{m,k} ')'],a(j)); end;
        prin(fi,fm,fc(m),s{:});                                % print test value usint the 36 ftoa format codes
      end;
    end;
    s = 'ftoa test complete. Test file written';  fclose(fi);  % done with test code
  end
  return;
end;
% if length(val) ~= 1 disp('2nd argument of ftoa must be a scalar'); return; end;
fcode = fmtstr(end);  fc = upper(fcode);  % extract format code. Convert to upper case
uc = fc==fcode;                           % upper case code (i.e. V or W)
if fc~='W' & fc~='V'  s = sprintf(fmtstr,val); return; end; % use sprintf if format isn't v,V,w,W
w = sscanf(fmtstr(2:end-1),'%d'); v = w;     % extract field width
if fc=='V' s = [blanks(v-1) '*']; else s = '*'; end;  ss = s;
if val==0  s = strrep(s,'*','0'); return; end;
if isnan(val) s = [blanks(length(s)-3) 'NaN']; if v<3 s=s(1:v); end; return; end;
q = [6 0 1 1; 5 1 1 2; 4 0 3 3; 0 0 0 0; 3 0 4 4; 4 1 2 3; 5 2 0 2;   % v,w formats
     7 1 0 0; 6 2 0 1; 5 1 2 2; 0 0 0 0; 4 1 3 3; 5 2 1 2; 6 3 -1 1]; % V,W formats
neg = val<0;
q = q(7*uc+min(find(abs(val) < [1e-99 1e-9 .01 10^(v-neg) 1e10 1e100 inf])),:);
fp = v - q(1) - neg;                         % compute fp, the format precision
if fp==-1 & uc fp=0; v=v+1; end;
if fp<0 return; end;                         % not enough digits available
if q(1) fmt = 'e'; else fmt = 'g'; end;      % select the e or g format
if ~fp  q = q + [0,1,-1,-1]; end;            % e format sometimes removes the "."
s = sprintf(sprintf('%%1.%d%c',fp,fmt),val); % convert to decimal string
n = length(s);                               % length of result
if n>3 & s(n-3)=='e'                         % is it a 2 digit exponent (for MAC)
  s = [s(1:n-2) '0' s(n-1:n)];               % change it to 3 digits
  n = n + 1;
end;
if q(1) q = [1:v-q(2) v+q(3):v+q(4)];        % here for e format
else                                         % here for g format
  fdot = findstr('.',s);
  if length(fdot)
    i = uc;  lz = 0;
    if fdot==2 & s(1)=='0' | length(findstr('-0.',s))
       i = i + 1;
       lz = length(findstr('0.0',s));
    end;
    if i s = sprintf(sprintf('%%1.%dg',fp-i),val); % use one or two fewer digits
         n = length(s);
    end;
    if lz s = strrep(s,'0.0','.0'); n=n-1; end;
  end;
  q = 1:min(~uc+v,n);
end; % end if q(1)
if max(q)>n s = ss; return; end;             % don't go over array bounds
s = s(q);  n = length(s);
if length([findstr(s,'0') findstr(s,'.') findstr(s,'-')]) == n % is there at least one nonzero digit?
  s = ss; return;                                              % return if not
end;
if fc=='V'
  p = w-length(s);                           % number of padding characters required
  isp = length(findstr('.',s));              % true if there is a period
  if ~uc p=p+isp; end;
  if p<=0 return; end;                       % no padding required
  if fmt=='e' s = [' ' s]; return; end;      % pad with blanks on left (p will be 1)
  if ~isp s=[s '.']; if uc p=p-1; end; end;  % if there is no period, add one before padding
  s = [s repmat('0',1,p)];                   % pad with zeros on the right
end;
% end function ftoa
