function [ trct_number ] = trct_encoder( tract_name )

switch (tract_name)
    case 'R_UNC'
        trct_number = 1;
    case 'L_UNC'
        trct_number = 2;
    case 'CC'
        trct_number = 3;
    case 'MCP'
        trct_number = 4;
    case 'R_CS'
        trct_number = 5;
    case 'L_CS'
        trct_number = 6;
    case 'R_IFO'
        trct_number = 7;
    case 'L_IFO'
        trct_number = 8;
    case 'L_SLF'
        trct_number = 9;
end


end

