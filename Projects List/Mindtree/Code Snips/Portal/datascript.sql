-- Begin datascript

-- First insert the new NodeKey into the SitemapNode table of the master database
DECLARE @RelyingPartyId AS INT = (SELECT Id FROM RelyingParty WHERE RPKey = 'WFM')
IF NOT EXISTS (SELECT * FROM [SitemapNode] WHERE RelyingPartyId = @RelyingPartyId AND NodeKey = 'WFM')
BEGIN
INSERT INTO [SitemapNode]
           ([RelyingPartyId]
           ,[RelyingPartyKey]
           ,[NodeKey]
           ,[IntegrationMode]
           ,[IsHidden]
           ,[IsPortalPage]
           ,[ModifiedBy])
     VALUES
           (@RelyingPartyId
           ,'WFM'
           ,'WFM'
           ,3
           ,0
           ,1
           ,'-1')
END
GO

-- Next we insert the translation into the database
-- WARNING:
-- @Culture needs to be set to the correct culture
DECLARE @NewString AS NVARCHAR(MAX) = N'考勤',
@NodeKey AS VARCHAR(255) = 'WFM',
@Culture AS VARCHAR(10) = 'zh-Hans', 
@PropertyName AS VARCHAR(50) = 'Name',
@ObjectType AS VARCHAR(255) = 'SumTotal.Models.Sitemap.SitemapNode'
DECLARE @ObjectId AS INT = (SELECT Id FROM SitemapNode WHERE NodeKey = @NodeKey)
IF NOT EXISTS (SELECT * FROM TRANSLATION WHERE Culture = @Culture AND PropertyName = @PropertyName AND ObjectType = @ObjectType AND ObjectId = @ObjectId)
BEGIN
INSERT INTO Translation (ObjectId, ObjectType, PropertyName, Culture, Value)
VALUES (@ObjectId, @ObjectType, @PropertyName, @Culture, @NewString)
END
ELSE
BEGIN
UPDATE Translation SET Value = @NewString WHERE Culture = @Culture AND PropertyName = @PropertyName AND ObjectType = @ObjectType AND ObjectId = @ObjectId
END

-- End datascript
