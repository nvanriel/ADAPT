% Function that grabs a token, but shows you which chars were removed

function [ token, remain, tokensLost ] = strtok2( string, tokens )

    l = length( string );
    [ token, remain ] = strtok( string, tokens );
    
    missing = length( string ) - length( token ) - length( remain );
    
    tokensLost = string( 1 : missing );
    
    

