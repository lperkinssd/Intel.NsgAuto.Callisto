

CREATE PROCEDURE [qan].[PARSEATTRIBUTES]
	@AttribString nvarchar(max),
	@AttribColumn varchar(max),
	@ParsedString varchar(max) OUTPUT

AS 
BEGIN
	CREATE TABLE #AttribTable (Attrib varchar(50))

	-- This is a generic store procedure that is called by the ODMQualFiter Stored procedure to construct the strings needed for each attribute matching within the MAT table.

	DECLARE @AttribArray varchar(max)
	DECLARE @AttribCount Int
	DECLARE @AttribPos Int
	DECLARE @AttribGPos Int
	DECLARE @AttribLPos Int
	DECLARE @NewAttribString varchar(max)
	DECLARE @AttribOperator varchar(10)
	DECLARE @AttribEndWhereString varchar(max)
	--select @AttribString
	--select 'I am in parse'
	
	SET @AttribArray = @AttribString
	SET @AttribArray = 'select ''' + replace(@AttribArray, '/', ''' union all select ''') + ''''
	--select @AttribColumn, @AttribArray

	IF @AttribColumn = 'major_probe_prog_rev'
		BEGIN
			INSERT INTO #MpprTable EXEC (@AttribArray)
			SELECT @AttribCount = COUNT(*)  from #MpprTable
			SET @AttribEndWhereString = ' NOT IN (SELECT * FROM #MpprTable)'
			
		END
	ELSE IF @AttribColumn = 'burn_tape_revision'
		BEGIN
			--select 'I am here'
			INSERT INTO #BurnTable EXEC (@AttribArray)
			SELECT @AttribCount = COUNT(*)  from #BurnTable
			SET @AttribEndWhereString = ' NOT IN (SELECT * FROM #BurnTable)'
			
		END
	ELSE IF @AttribColumn = 'cell_revision'
		BEGIN
			--select 'I am here'
			INSERT INTO #CellTable EXEC (@AttribArray)
			SELECT @AttribCount = COUNT(*)  from #CellTable
			--SET @AttribEndWhereString = ' IN (SELECT * FROM #CellTable)'
			SET @AttribEndWhereString = ' NOT IN (SELECT * FROM #CellTable)'
			
		END
	ELSE IF @AttribColumn = 'fab_excr_id'
		BEGIN
			INSERT INTO #FabExcrTable EXEC (@AttribArray)
			SELECT @AttribCount = COUNT(*)  from #FabExcrTable
			SET @AttribEndWhereString = ' NOT IN (SELECT * FROM #FabExcrTable)'
		END
	ELSE IF @AttribColumn = 'product_grade'
		BEGIN
			INSERT INTO #ProdGradeTable EXEC (@AttribArray)
			SELECT @AttribCount = COUNT(*)  from #ProdGradeTable
			SET @AttribEndWhereString = ' NOT IN (SELECT * FROM #ProdGradeTable)'
		END
	ELSE IF @AttribColumn = 'fab_conv_id'
		BEGIN
			INSERT INTO #FabConvTable EXEC (@AttribArray)
			SELECT @AttribCount = COUNT(*)  from #FabConvTable
			SET @AttribEndWhereString = ' NOT IN (SELECT * FROM #FabConvTable)'
			
		END
	ELSE IF @AttribColumn = 'reticle_wave_id'
		BEGIN
			INSERT INTO #ReticleWaveTable EXEC (@AttribArray)
			SELECT @AttribCount = COUNT(*)  from #ReticleWaveTable
			SET @AttribEndWhereString = ' NOT IN (SELECT * FROM #ReticleWaveTable)'
			
		END
	ELSE
		BEGIN
			INSERT INTO #AttribTable EXEC (@AttribArray)
			SELECT @AttribCount = COUNT(*)  from #AttribTable
		END
	--END

	--select * from #AttribTable  --testing

	--SELECT @AttribCount = COUNT(Attrib)  from #AttribTable
	IF @AttribCount > 1
		BEGIN
			--select @AttribString
			--SET @AttribString  = ' And ' + @AttribColumn   + ' IN (SELECT * FROM #AttribTable)'
			SET @AttribString  = ' Or ' + @AttribColumn   + @AttribEndWhereString
			--print @AttribString
			--select @AttribString
		End
	ELSE IF @AttribCount =0 
		BEGIN
			SET @AttribString = ' Or ' + @AttribColumn  + ' IS NULL'
			--SELECT @AttribString
		END
	ELSE 
		BEGIN
			--select charindex('=',@AttribString) AS @AttribPos
			-- Covers >=, <=, = cases
			SELECT @AttribPos = CHARINDEX('=',@AttribString)
			SELECT @AttribGPos = CHARINDEX('>', @AttribString)
			SELECT @AttribLPos = CHARINDEX('<', @AttribString)

			IF CHARINDEX('=',@AttribString) = 0 AND CHARINDEX('<',@AttribString) =0 AND CHARINDEX('>',@AttribString) = 0  -- No =,<=,>= criteria defined.
				BEGIN
					--select 'I am here'
					--SELECT @AttribColumn
					--SELECT @NewAttribString
					--SET @AttribString = ' And  ' +  @AttribColumn +   ' >= '''  + @AttribString + ''''	
					IF @AttribColumn = 'product_grade'
						SET @AttribString = ' Or  ' +  @AttribColumn +   ' <> '''  + @AttribString + ''''	
					ELSE
						SET @AttribString = ' Or  ' +  @AttribColumn +   ' < '''  + @AttribString + ''''
					--select @AttribString
				END
		    ELSE IF @AttribGPos = 1   -- either > or >=
				BEGIN
					IF @AttribPos =2  -- >=
						BEGIN
							--select 'I am here2'
							--set  @AttribOperator = SUBSTRING (@AttribString, 1,2) --SELECT
							set  @AttribOperator = '<' --SELECT
							--print @AttribOperator
							set @NewAttribString = SUBSTRING(@AttribString, 3, len(@AttribString)) --SELECT

							-- special treatment for MPPR as the qual filter query starts with MPPR.
							If @AttribColumn = 'major_probe_prog_rev'
								SET  @AttribString = ' And ( ' +  @AttribColumn +  ' ' + @AttribOperator  + ' '''  + @NewAttribString + ''''	
							ELSE
								SET @AttribString = ' Or  ' +  @AttribColumn +  ' ' + @AttribOperator  + ' '''  + @NewAttribString + ''''	
						END
					ELSE
						BEGIN
							--select 'I am here2'
							--set  @AttribOperator = SUBSTRING (@AttribString, 1,2) --SELECT
							set  @AttribOperator = '<=' --SELECT
							--print @AttribOperator
							set @NewAttribString = SUBSTRING(@AttribString, 2, len(@AttribString)) --SELECT
							-- special treatment for MPPR as the qual filter query starts with MPPR.
							If @AttribColumn = 'major_probe_prog_rev'
								SET @AttribString = ' And (  ' +  @AttribColumn +  ' ' + @AttribOperator  + ' '''  + @NewAttribString + ''''	
							ELSE
								SET @AttribString = ' Or  ' +  @AttribColumn +  ' ' + @AttribOperator  + ' '''  + @NewAttribString + ''''	
						END
				END
			ELSE IF @AttribLPos = 1   -- either < or <=
				BEGIN
					
					IF @AttribPos =2  -- <=
						BEGIN
							--select 'I am here for <='
							--set  @AttribOperator = SUBSTRING (@AttribString, 1,2) --SELECT
							set  @AttribOperator = '>' --SELECT
							--print @AttribOperator
							set @NewAttribString = SUBSTRING(@AttribString, 3, len(@AttribString)) --SELECT
							-- special treatment for MPPR as the qual filter query starts with MPPR.
							If @AttribColumn = 'major_probe_prog_rev'
								SET @AttribString = ' And (  ' +  @AttribColumn +  ' ' + @AttribOperator  + ' '''  + @NewAttribString + ''''
							ELSE
								SET @AttribString = ' Or  ' +  @AttribColumn +  ' ' + @AttribOperator  + ' '''  + @NewAttribString + ''''
						END
					ELSE
						BEGIN
							--select 'I am here for <'
							--set  @AttribOperator = SUBSTRING (@AttribString, 1,2) --SELECT
							set  @AttribOperator = '>=' --SELECT
							--print @AttribOperator
							set @NewAttribString = SUBSTRING(@AttribString, 2, len(@AttribString)) --SELECT
							If @AttribColumn = 'major_probe_prog_rev'
								SET @AttribString = ' And (  ' +  @AttribColumn +  ' ' + @AttribOperator  + ' '''  + @NewAttribString + ''''
							ELSE
								SET @AttribString = ' Or  ' +  @AttribColumn +  ' ' + @AttribOperator  + ' '''  + @NewAttribString + ''''
						END
				END
			ELSE IF @AttribPos =  1  --- =
				BEGIN
					--select 'I am here3'
					set  @AttribOperator = '<>' ---SELECT
					set @NewAttribString = SUBSTRING(@AttribString, 2, len(@AttribString))  --select
					If @AttribColumn = 'major_probe_prog_rev'
						SET @AttribString = ' And (  ' +  @AttribColumn +  ' ' + @AttribOperator  + ' '''  + @NewAttribString + ''''	
					ELSE
						SET @AttribString = ' Or  ' +  @AttribColumn +  ' ' + @AttribOperator  + ' '''  + @NewAttribString + ''''	
				END
			 
			
		END
	--select @AttribString
	--select * from #AttribTable
	SET @ParsedString = @AttribString
	--select @ParsedString

END