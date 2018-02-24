GM.LevelValues = {}

for i = 1, 99 do
	GM.LevelValues[ i ] = math.floor( ( 1 / 8 ) * i * ( i - 1 ) + 75 * ( ( 2^( ( i - 1 ) / 7 ) ) - 1 ) / ( 1 - 2^( -1 / 7 ) ) )
end