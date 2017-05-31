Use QPPlatformManagerDB
GO

CREATE TABLE Countrys (  
  ID INT IDENTITY(1,1),  
  CountryID VARCHAR(20) NOT NULL,  
  CountryName VARCHAR(50) NOT NULL
)

GO
  
INSERT INTO Countrys(CountryID,CountryName) 
VALUES ('China','ÖÐ¹ú')