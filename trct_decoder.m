function [ trct_name ] = trct_decoder( tract_number )

switch (tract_number)
    case 1
        trct_name = 'R_UNC';
    case 2
        trct_name = 'L_UNC';
    case 3
        trct_name = 'CC';
    case 4
        trct_name = 'MCP';
    case 5
        trct_name = 'R_CS';
    case 6
        trct_name = 'L_CS';
    case 7
        trct_name = 'R_IFO';
    case 8
        trct_name = 'L_IFO';
    case 9
        trct_name = 'L_SLF';
end


end

