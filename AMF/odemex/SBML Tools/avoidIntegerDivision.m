function str = avoidIntegerDivision( string )

    expressionTokens = '&()[]/*+-^@ %<>,;={}';
    
    str = [];
    
    [ tok, remainder, z ] = strtok2( string, expressionTokens );
    
    while ( ( ~isempty( remainder ) ) || ( ~isempty( tok ) ) )
        
        no = str2num( tok );
        if ~isempty( no )
            if round( no ) == no
                tok = sprintf( '%d.0', no );
            end
        end
        
        str = [ str, z, tok ];
        
        [ tok, remainder, z ] = strtok2( remainder, expressionTokens );
        
    end
    
    str = [ str, z, tok ];