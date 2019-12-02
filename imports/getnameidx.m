% downloaded from MathWorks
function nameidx=getnameidx(ftsnames, seriesname)
%GETNAMEIDX returns the order number of a string in a list of strings.
%
%   GETNAMEIDX finds the occurrence of a name or a list of names in a super 
%   list of names.  It returns an index (order number) of where the name(s) 
%   is(are) within the super list of names.
%
%   NAMEIDX = GETNAMEIDX(SUPERLIST, NAMETOFIND) returns the index (order 
%   number), NAMEIDX, of where name NAMETOFIND is within the super list of 
%   unique names SUPERLIST.  If NAMETOFIND is not found, it will return a   
%   zero (0).  The SUPERLIST must be a cell array of name strings.  
%   NAMETOFIND can be either a string or a cell array of name strings.  
%
%   If NAMETOFIND is a cell array of names, GETNAMEIDX will return a vector 
%   that contains the indices (order number) of the NAMETOFIND strings 
%   within the SUPERLIST.  If none of the names in NAMETOFIND cell array is 
%   in SUPERLIST, it will return a zero (0).  If some of names in NAMETOFIND 
%   cell array are not found, the indices for these names will be zeros 
%   (0's).
%
%   For example,   nametofind = {'Jack', 'Cleve'};
%                  superlist = {'Clay', 'Jack', 'Joe', 'Cleve', 'Loren'};
%                  nameidx = getnameidx(superlist, nametofind)
%
%                  ans = 
%                         2    4
%
%            or,   nametofind = {'Jack', 'Josh', 'Cleve'};
%                  superlist = {'Clay', 'Jack', 'Joe', 'Cleve', 'Loren'};
%                  nameidx = getnameidx(superlist, nametofind)
%
%                  ans = 
%                         2    0    4
%
%   NOTE: It will not find multiple occurrences of a name or a list of names
%         within the SUPERLIST.  It will only find the first occurrence of
%         the name of the list of names.  This function is meant to be used
%         on a list of UNIQUE names (strings) only.
%
%   See also STRCMP, STRFIND.

%   Copyright 1995-2009 The MathWorks, Inc.

if ischar(seriesname)
    if size(seriesname, 1)~=1
        error(message('finance:ftseries:getnameidx:SERIESNAMEMustBeString'));
    end
    for idx=1:length(ftsnames)
        if (strcmp(ftsnames{idx}, seriesname))
            nameidx = idx;
            return
        end
    end
else
    for jdx=1:length(seriesname)
        for idx=1:length(ftsnames)
            if (strcmp(ftsnames{idx}, seriesname{jdx}))
                nameidx(jdx) = idx;
                break;
            else
                nameidx(jdx) = 0;
            end
        end
    end
    return
end

nameidx = 0;

% [EOF]