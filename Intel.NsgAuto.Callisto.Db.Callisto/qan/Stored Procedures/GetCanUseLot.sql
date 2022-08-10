

CREATE PROCEDURE [qan].[GetCanUseLot]

 AS
 BEGIN
    TRUNCATE TABLE [qan].[QualifiedLots]

	DECLARE @FailedId int	
	
	DECLARE LotCursor CURSOR FOR SELECT distinct MediaIpn,s_lot from [qan].[QualFilterRaw] 
			--where  s_lot in  ('S836E2QP')
		--('S001E0RU','S001E149','S001E1Z','S001E270','S001E2O4','S001E30C','S001E30D','S001E30E','S001E30F','S002E01Y')
	DECLARE @LotId varchar(50), @MediaIpn varchar(50), @myInt integer

	OPEN LotCursor
    FETCH NEXT FROM LotCursor INTO  @MediaIpn,@LotId
	
	WHILE @@FETCH_STATUS =0
    BEGIN
		
		--select @LotId, @MediaIpn
		INSERT INTO qan.QualifiedLots (ScodeMm, MediaIpn, SLot)
			SELECT DISTINCT Scode,Media_IPN, @LotId FROM qan.MAT where Latest=1 and Media_IPN=@MediaIpn
				EXCEPT
		   SELECT DISTINCT ScodeMm, MediaIpn, @LotId FROM [qan].[QualFilterRaw] WHERE s_lot=@LotId


		FETCH NEXT FROM LotCursor INTO @MediaIpn, @LotId

	END
	CLOSE LotCursor
	DEALLOCATE LotCursor

	Update qan.QualifiedLots   SET qan.QualifiedLots.OdmName = qan.QualFilterRaw.OdmName
		FROM qan.QualifiedLots INNTER JOIN qan.QualFilterRaw on (SLot=qan.QualFilterRaw.s_lot)
	
	--select distinct A.OdmName from qan.QualFilterRaw A where A.s_lot= SLot

	--DECLARE LotCursor CURSOR FOR SELECT distinct ScodeMm, OsatIpn,s_lot from [qan].[QualFilterRawNew] where Latest='Y'  --and  Odm_desc = 'Kingston Taiwan'
	DECLARE @OdmNameVar varchar(50), @OdmBohName varchar(50)
	

 END


    --select * from (
					--SELECT DISTINCT Scode,Media_IPN, @LotId as LotId1 FROM qan.MAT where Latest='Y' and Media_IPN=@MediaIpn
				--			EXCEPT
					--SELECT DISTINCT ScodeMm, MediaIpn, @LotId as LotId1 FROM [qan].[QualFilterRaw] WHERE s_lot=@LotId
					--) as A
		
		  --select @LotId, @MediaIpn				

		--set @myInt = (select count(*) from 
		--				(
		--				  SELECT DISTINCT Scode,Media_IPN, @LotId FROM qan.MAT where Latest='Y' and Media_IPN=@MediaIpn
		--					EXCEPT
		--				  SELECT DISTINCT ScodeMm, MediaIpn, @LotId FROM [qan].[QualFilterRaw] WHERE s_lot=@LotId
		--				 )
		--		      )

		--select 'I am here '