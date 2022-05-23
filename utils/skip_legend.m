function skip_legend( h )
% skip_legend: Skips legend for a plot figure h

% Copyright (c) 2022 Rodrigo Aldana López, Universidad de Zaragoza, Spain. All rights reserved
% Licensed under the MIT license. See LICENSE.txt file in the project root for details.

set( get( get( h, 'Annotation'), 'LegendInformation' ), 'IconDisplayStyle', 'off' );

end

