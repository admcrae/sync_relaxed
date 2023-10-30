function h = sigmap_heatmap(T, cvar, f, figsize, exportpdf, filename)
h = heatmap(T, 'sigma', 'p',...
    ColorVariable=cvar,...
    Colorlimits=[0, 1],...
    CellLabelColor='none',...
    Colormap=gray(256)...
);
title('');
f.Position(3:4) = figsize;

if exportpdf
    exportgraphics(gca, filename, 'ContentType', 'vector');
end

end