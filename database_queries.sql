create database Hotel_Reservation;
GO
use Hotel_Reservation;
GO


-- . Guests Table
CREATE TABLE Guests (
    GuestID INT IDENTITY(1,1) PRIMARY KEY, 
    FullName VARCHAR(100) NOT NULL,
    NationalID VARCHAR(50) UNIQUE,
    PhoneNumber VARCHAR(20) UNIQUE NOT NULL,
    Email VARCHAR(100),
    City VARCHAR(50),
    country VARCHAR(50),
    DOB DATE
);
GO

-- . Rooms_types Table
CREATE TABLE Room_Types (
    RoomTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL,        -- Options: Single, Double, Suite, Family
    BasePrice DECIMAL(10, 2) NOT NULL,    
    MaxCapacity INT NOT NULL              -- Maximum number of guests allowed
);
GO
-- . Rooms Table
CREATE TABLE Rooms (
    RoomNumber VARCHAR(10) PRIMARY KEY,
    RoomTypeID INT NOT NULL,             
    HousekeepingStatus VARCHAR(20) DEFAULT 'Clean',
    
    FOREIGN KEY (RoomTypeID) REFERENCES Room_Types(RoomTypeID)
);
GO
-- . Staff Table
CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY, -- Auto-increment starting from 1
    FullName VARCHAR(100) NOT NULL,
    Role VARCHAR(50) NOT NULL,             -- Options: Reception, Billing, Housekeeping, etc.
    IsActive BIT DEFAULT 1 NOT NULL,        -- 1 = Active, 0 = Inactive (Fired/Resigned)
    PasswordHash VARCHAR(255) NOT NULL
);
GO
-- . Services Catalog Table
CREATE TABLE Services_ (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL,
    ServicePrice DECIMAL(10, 2) NOT NULL,
    IsActive BIT DEFAULT 1 NOT NULL        -- 1 = Available, 0 = Discontinued from menu
);
GO
-- =========================================================================
-- PART 2: TRANSACTIONAL TABLES (Dependent tables with foreign keys)
-- =========================================================================

-- . Reservations Table (Core System Hub)
CREATE TABLE Reservations (
    ReservationID INT IDENTITY(1,1) PRIMARY KEY,
    GuestID INT NOT NULL,   
    RoomNumber VARCHAR(10) NOT NULL,
    StaffID INT NOT NULL,           
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    Nights INT NOT NULL CHECK (Nights > 0),
    ReservationStatus VARCHAR(20) DEFAULT 'Booked', -- Options: Booked, Checked-in, Checked-out, Cancelled
    CancellationReason VARCHAR(255) NULL,           

    -- Foreign Key Constraints
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID),
    FOREIGN KEY (RoomNumber) REFERENCES Rooms(RoomNumber) ON UPDATE CASCADE,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),

    CONSTRAINT CHK_Dates CHECK (CheckOutDate > CheckInDate)
);
GO

-- . Service Usage Table (Tracking guest consumption)
CREATE TABLE Service_Usage (
    UsageID INT IDENTITY(1,1) PRIMARY KEY,
    ReservationID INT NOT NULL, 
    ServiceID INT NOT NULL,     
    Quantity INT DEFAULT 1 NOT NULL,
    RequestTime DATETIME DEFAULT GETDATE(), 

    -- Foreign Key Constraints
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID),
    FOREIGN KEY (ServiceID) REFERENCES Services_(ServiceID)
);
GO

-- . Invoices Table
CREATE TABLE Invoices (
    InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
    ReservationID INT NOT NULL, 
    StaffID INT NOT NULL,       
    InvoiceDate DATE DEFAULT CAST(GETDATE() AS DATE),
    TotalAmount DECIMAL(10, 2) NOT NULL,

    -- Foreign Key Constraints
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);
GO

ALTER TABLE Invoices 
DROP COLUMN TotalAmount; -- Remove the old manual column
GO

ALTER TABLE Invoices 
ADD TotalAmount AS dbo.fn_CalculateTotal(ReservationID); -- Add the smart auto-column
GO

-- . Payments Table
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceID INT NOT NULL, 
    PaymentDate DATETIME DEFAULT GETDATE(),
    AmountPaid DECIMAL(10, 2) NOT NULL CHECK (AmountPaid > 0),
    PaymentMethod VARCHAR(50) NOT NULL, -- Options: Cash, Card, Online
    PaymentStatus VARCHAR(20) DEFAULT 'Success',

    -- Foreign Key Constraints
    FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID)
);
GO

-- . Housekeeping Logs Table
CREATE TABLE Housekeeping_Logs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    RoomNumber VARCHAR(10) NOT NULL, 
    StaffID INT NOT NULL,            
    LogDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NULL,               -- NULL means the cleaning process is still ongoing

    -- Foreign Key Constraints
    FOREIGN KEY (RoomNumber) REFERENCES Rooms(RoomNumber),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    CONSTRAINT CHK_Times CHECK (EndTime IS NULL OR EndTime >= StartTime)
);

GO



USE Hotel_Reservation;
GO

--  Room Types (Standard English)
INSERT INTO Room_Types (TypeName, BasePrice, MaxCapacity) VALUES 
('Single', 100, 1),
('Double', 150, 2), 
('Suite', 300, 4), 
('Family', 250, 6);

-- Adding 5 new rooms manually (151 to 155) with logical types
-- RoomTypeID 1: Single, 2: Double, 3: Suite, 4: Family
INSERT INTO Rooms (RoomNumber, RoomTypeID, HousekeepingStatus) 
VALUES 
('151', 1, 'Clean'),
('152', 2, 'Clean'),
('153', 2, 'Clean'),
('154', 3, 'Clean'),
('155', 4, 'Clean');

-- 3. Staff (30 Mixed Arabic/Western Names in English)
INSERT INTO Staff (FullName, Role, PasswordHash, IsActive) VALUES 
('Ahmed Mansour', 'Manager', 'h1', 1),
('Sami Al-Fahad', 'Reception', 'h2', 1), ('Jessica Miller', 'Reception', 'h3', 1), ('Mona El-Sayed', 'Reception', 'h4', 1), ('David Clark', 'Reception', 'h5', 1),
('Laila Hassan', 'Billing', 'h6', 1), ('Robert Wilson', 'Billing', 'h7', 1), ('Hany Ramzy', 'Billing', 'h8', 1), ('Sarah Jones', 'Billing', 'h9', 1), ('Omar Khattab', 'Billing', 'h10', 1),
('Mahmoud Gaber', 'Housekeeping', 'h11', 1), ('Elena Rodriguez', 'Housekeeping', 'h12', 1), ('Tarek Ziad', 'Housekeeping', 'h13', 1), ('Sophie Taylor', 'Housekeeping', 'h14', 1), ('Mostafa Bakr', 'Housekeeping', 'h15', 1),
('Ali Mansour', 'Housekeeping', 'h16', 1), ('Maria Garcia', 'Housekeeping', 'h17', 1), ('Yassin Tolba', 'Housekeeping', 'h18', 1), ('Emma Watson', 'Housekeeping', 'h19', 1), ('Khaled Saeed', 'Housekeeping', 'h20', 1),
('Fatma Zahra', 'Housekeeping', 'h21', 1), ('John Doe', 'Housekeeping', 'h22', 1), ('Nour El-Din', 'Housekeeping', 'h23', 1), ('Linda Evans', 'Housekeeping', 'h24', 1), ('Zainab Ali', 'Housekeeping', 'h25', 1),
('Ibrahim Adel', 'Security', 'h26', 1), ('Peter Parker', 'Security', 'h27', 1), ('Amr Diab', 'Management', 'h28', 1), ('Gordon Ramsay', 'Chef', 'h29', 1), ('Steve Jobs', 'IT', 'h30', 1);

-- Adding 5 new international guests manually (Starting after the 600 mark)
-- Maintaining the same mix: Arab, Western, Asian, and Mixed
INSERT INTO Guests (FullName, NationalID, PhoneNumber, Email, City, country, DOB) 
VALUES 
('Guest_Arab_601', 'ID_4601', '+966-555-601', 'customer601@global.com', 'Riyadh', 'Saudi Arabia', '1995-04-12'),
('Guest_Western_602', 'ID_4602', '+1-555-602', 'customer602@global.com', 'London', 'UK', '1990-09-25'),
('Guest_Asian_603', 'ID_4603', '+81-555-603', 'customer603@global.com', 'Seoul', 'South Korea', '1988-01-15'),
('Guest_Mixed_604', 'ID_4604', '+49-555-604', 'customer604@global.com', 'Berlin', 'Germany', '1992-11-30'),
('Guest_Arab_605', 'ID_4605', '+20-555-605', 'customer605@global.com', 'Alexandria', 'Egypt', '1985-06-20');


-- 5. Services (20 Services)
INSERT INTO Services_ (ServiceName, ServicePrice, IsActive) VALUES 
('Breakfast Buffet', 25, 1), ('Express Laundry', 15, 1), ('Oriental Spa', 75, 1), ('Gym Pass', 10, 1), ('Dinner Set', 45, 1),
('Premium WiFi', 10, 1), ('Mini Bar Restock', 50, 1), ('Airport Pickup', 40, 1), ('Late Checkout', 30, 1), ('Extra Bed', 35, 1),
('Pool Access', 15, 1), ('Room Service Fee', 10, 1), ('Parking Fee', 20, 1), ('Valet Service', 15, 1), ('Tennis Court', 25, 1),
('Movie Night', 12, 1), ('Dry Clean Suit', 20, 1), ('Sauna Access', 20, 1), ('Kids Care', 15, 1), ('Safari Tour', 120, 1);



-- Adding 5 new reservations manually (601 to 605)
-- Using logical statuses: Booked, Checked-in, Checked-out, Cancelled
INSERT INTO Reservations (GuestID, RoomNumber, StaffID, CheckInDate, CheckOutDate, Nights, ReservationStatus, CancellationReason) 
VALUES 
(601, '101', 2, '2026-03-28', '2026-04-02', 5, 'Booked', NULL),
(602, '110', 3, '2026-03-25', '2026-03-30', 5, 'Checked-in', NULL),
(603, '120', 4, '2026-01-10', '2026-01-15', 5, 'Checked-out', NULL),
(604, '130', 5, '2026-04-05', '2026-04-10', 5, 'Cancelled', 'Change of Plans'),
(605, '155', 2, '2026-03-20', '2026-03-25', 5, 'Checked-out', NULL);



-- 7. Manual Service Usage Entry (For a specific reservation)
INSERT INTO Service_Usage (ReservationID, ServiceID, Quantity, RequestTime)
VALUES (601, 1, 2, GETDATE()), -- 2 Breakfasts for Res 601
       (602, 3, 1, GETDATE()); -- 1 Spa session for Res 602

-- 8. Manual Invoice Entry (Linking Reservation to Billing Staff)
-- StaffID 6-10 are Billing staff based on previous inserts
INSERT INTO Invoices (ReservationID, StaffID, InvoiceDate)
VALUES (601, 6, CAST(GETDATE() AS DATE)),
       (605, 7, CAST(GETDATE() AS DATE));

-- 9. Manual Payment Entry (Linking to Invoice)
-- Using the Scalar Function to get the exact amount automatically
INSERT INTO Payments (InvoiceID, AmountPaid, PaymentMethod, PaymentStatus)
VALUES (167, dbo.fn_CalculateTotal(601), 'Credit Card', 'Success'),
       (168, dbo.fn_CalculateTotal(605), 'Cash', 'Success');

-- 10. Manual Housekeeping Log Entry (Room cleaning record)
-- StaffID 11-25 are Housekeeping staff
INSERT INTO Housekeeping_Logs (RoomNumber, StaffID, LogDate, StartTime, EndTime)
VALUES ('101', 11, CAST(GETDATE() AS DATE), '10:00:00', '11:00:00'),
       ('155', 12, CAST(GETDATE() AS DATE), '12:00:00', '13:00:00');
       
       GO
------------------------------------------------------------------------------------





-- Trigger to automatically update room status to 'Dirty' when a guest checks out

CREATE TRIGGER trg_UpdateRoomStatus
ON Reservations
AFTER UPDATE
AS
BEGIN
    -- Check if the specific column 'ReservationStatus' was changed during this update
    IF UPDATE(ReservationStatus)
    BEGIN
        -- Start the action: Update the 'Rooms' table
        UPDATE Rooms
        
        -- Change the housekeeping status of the target room to 'Dirty'
        SET HousekeepingStatus = 'Dirty'
        
        -- Define 'R' as an alias for the Rooms table
        FROM Rooms R
        
        -- Join with the special system table called 'inserted' (aliased as 'NewData')
        -- This holds the NEW updated row from the Reservations table
        INNER JOIN inserted NewData ON R.RoomNumber = NewData.RoomNumber
        
        -- The final condition: Only do this IF the new status in the reservation is 'Checked-out'
        WHERE NewData.ReservationStatus = 'Checked-out';
    END
END;
GO




-- 2. Create the Function
CREATE FUNCTION dbo.fn_CalculateTotal(@ResID INT)
RETURNS DECIMAL(10,2) -- The function will output a decimal number (the total money)
AS
BEGIN
    -- Declare a local variable to store the final calculation
    DECLARE @Total DECIMAL(10,2);
    
    -- Start the calculation logic
    SELECT @Total = 
        -- PART A: Calculate Room Cost (BasePrice from Room_Types * Nights from Reservations)
        (RT.BasePrice * R.Nights) + 
        
        -- PART B: Calculate Services Cost (Sub-query)
        -- We use ISNULL(..., 0) so if a guest ordered 0 services, the math doesn't break
        ISNULL((
            SELECT SUM(S.ServicePrice * SU.Quantity) 
            FROM Service_Usage SU 
            JOIN Services_ S ON SU.ServiceID = S.ServiceID 
            WHERE SU.ReservationID = @ResID
        ), 0)

    -- Join the necessary tables to get Room Prices and Reservation details
    FROM Reservations R
    JOIN Rooms RM ON R.RoomNumber = RM.RoomNumber
    JOIN Room_Types RT ON RM.RoomTypeID = RT.RoomTypeID
    
    -- Filter by the specific Reservation ID provided to the function
    WHERE R.ReservationID = @ResID;

    -- Return the final calculated amount to the user
    RETURN @Total;
END;
GO



USE Hotel_Reservation;
GO

--Guest Master View
CREATE VIEW vw_GuestMaster AS
SELECT 
    G.GuestID, G.FullName, G.NationalID, G.PhoneNumber, G.Email, G.City,
    COUNT(R.ReservationID) AS TotalStays,
    ISNULL(SUM(P.AmountPaid), 0) AS LifetimeSpend
FROM Guests G
LEFT JOIN Reservations R ON G.GuestID = R.GuestID AND R.ReservationStatus = 'Checked-out'
LEFT JOIN Invoices I ON R.ReservationID = I.ReservationID
LEFT JOIN Payments P ON I.InvoiceID = P.InvoiceID
GROUP BY G.GuestID, G.FullName, G.NationalID, G.PhoneNumber, G.Email, G.City;
GO

-- Query: Top 20 guests by LifetimeSpend
SELECT TOP 20 * FROM vw_GuestMaster ORDER BY LifetimeSpend DESC;

Go



--Room Availability View
CREATE VIEW vw_RoomBookings AS
SELECT 
    R.RoomNumber, RT.TypeName, RT.BasePrice, RES.CheckInDate, RES.CheckOutDate
FROM Rooms R
JOIN Room_Types RT ON R.RoomTypeID = RT.RoomTypeID
LEFT JOIN Reservations RES ON R.RoomNumber = RES.RoomNumber 
WHERE RES.ReservationStatus IN ('Booked', 'Checked-in');
GO

-- Query: Find available rooms between '2026-03-05' and '2026-03-07'
SELECT R.RoomNumber, RT.TypeName, RT.BasePrice
FROM Rooms R
JOIN Room_Types RT ON R.RoomTypeID = RT.RoomTypeID
WHERE R.RoomNumber IN (
    
    SELECT RoomNumber FROM Rooms
    
    EXCEPT
    
    SELECT RoomNumber FROM vw_RoomBookings 
    WHERE CheckInDate < '2026-03-07' AND CheckOutDate > '2026-03-05'
);



select * from vw_RoomBookings
GO



--Daily Occupancy Rate
DECLARE @Today DATE = '2026-03-02';

DECLARE @TotalRooms FLOAT = (SELECT COUNT(*) FROM Rooms);

SELECT 
    @Today AS [AnalysisDate],
    @TotalRooms AS [TotalCapacity],
    COUNT(*) AS [OccupiedRooms],
    (COUNT(*) / @TotalRooms) * 100 AS [OccupancyRate%]
FROM Reservations
WHERE @Today >= CheckInDate AND @Today < CheckOutDate
AND ReservationStatus IN ('Booked', 'Checked-in');

GO


--Reservation Details View

CREATE VIEW vw_ReservationDetails AS
SELECT 
    R.ReservationID, G.FullName AS GuestName, R.RoomNumber, RT.TypeName AS RoomType,
    R.CheckInDate, R.CheckOutDate, R.Nights, R.ReservationStatus,
    (R.Nights * RT.BasePrice) AS TotalRoomCharge
FROM Reservations R
JOIN Guests G ON R.GuestID = G.GuestID
JOIN Rooms RM ON R.RoomNumber = RM.RoomNumber
JOIN Room_Types RT ON RM.RoomTypeID = RT.RoomTypeID;

select * from vw_ReservationDetails

GO

--Cancellation Analysis
SELECT 
    FORMAT(CheckInDate, 'yyyy-MM') AS [Month],
    COUNT(*) AS [Total Bookings],
    SUM(IIF(ReservationStatus = 'Cancelled', 1, 0)) AS [Cancelled Count],
    SUM(IIF(ReservationStatus = 'Cancelled', 1.0, 0)) * 100 / COUNT(*) AS [Cancellation Rate %]

FROM Reservations
GROUP BY FORMAT(CheckInDate, 'yyyy-MM');

-- Top 5 Reasons
SELECT TOP 5 CancellationReason, COUNT(*) as Count_
FROM Reservations
WHERE ReservationStatus = 'Cancelled'
GROUP BY CancellationReason
ORDER BY Count_ DESC;
GO


--Services Revenue View
CREATE VIEW vw_ServiceRevenue AS
SELECT 
    S.ServiceName,
    FORMAT(SU.RequestTime, 'yyyy-MM') AS YearMonth,
    COUNT(SU.UsageID) AS TotalUsageCount,
    SUM(SU.Quantity * S.ServicePrice) AS TotalServiceRevenue
FROM Services_ S
JOIN Service_Usage SU ON S.ServiceID = SU.ServiceID
GROUP BY S.ServiceName, FORMAT(SU.RequestTime, 'yyyy-MM');
GO

-- Query: Top 5 services last 3 months
SELECT TOP 5 ServiceName, SUM(TotalServiceRevenue) as Revenue
FROM vw_ServiceRevenue
WHERE YearMonth >= FORMAT(DATEADD(MONTH, -3, GETDATE()), 'yyyy-MM')
GROUP BY ServiceName ORDER BY Revenue DESC;
GO

--Invoice Aging & Outstanding Balances
CREATE VIEW vw_InvoiceAging AS
SELECT 
    I.InvoiceID, G.FullName AS GuestName, I.InvoiceDate, I.TotalAmount,
    ISNULL(SUM(P.AmountPaid), 0) AS PaidAmount,
    (I.TotalAmount - ISNULL(SUM(P.AmountPaid), 0)) AS OutstandingAmount,
    DATEDIFF(DAY, I.InvoiceDate, GETDATE()) AS DaysOld,
    CASE 
        WHEN DATEDIFF(DAY, I.InvoiceDate, GETDATE()) <= 7 THEN '0–7'
        WHEN DATEDIFF(DAY, I.InvoiceDate, GETDATE()) <= 30 THEN '8–30'
        WHEN DATEDIFF(DAY, I.InvoiceDate, GETDATE()) <= 60 THEN '31–60'
        ELSE '60+' 
    END AS AgingBucket
FROM Invoices I
JOIN Reservations R ON I.ReservationID = R.ReservationID
JOIN Guests G ON R.GuestID = G.GuestID
LEFT JOIN Payments P ON I.InvoiceID = P.InvoiceID
GROUP BY I.InvoiceID, G.FullName, I.InvoiceDate, I.TotalAmount;
GO

--all outstanding invoices in the 60+ bucket
SELECT * FROM vw_InvoiceAging
WHERE AgingBucket = '60+' 
AND OutstandingAmount > 0
ORDER BY OutstandingAmount DESC;
GO


--Payment Method Breakdown
SELECT 
    FORMAT(PaymentDate, 'yyyy-MM') AS YearMonth,
    SUM(AmountPaid) AS TotalPaid,
    SUM(CASE WHEN PaymentMethod = 'Cash' THEN AmountPaid ELSE 0 END) AS PaidByCash,
    SUM(CASE WHEN PaymentMethod = 'Credit Card' THEN AmountPaid ELSE 0 END) AS PaidByCard,
    SUM(CASE WHEN PaymentMethod = 'Online' THEN AmountPaid ELSE 0 END) AS PaidByOnline
FROM Payments
WHERE PaymentStatus = 'Success'
GROUP BY FORMAT(PaymentDate, 'yyyy-MM');
GO


--Housekeeping & Room Turnover Report

CREATE VIEW vw_HousekeepingPerformance AS
SELECT 
    RoomNumber,
    COUNT(LogID) AS CleaningCount,
    AVG(DATEDIFF(MINUTE, StartTime, EndTime)) AS AvgCleanTimeMinutes,
    SUM(CASE WHEN CAST(EndTime AS TIME) > '15:00:00' THEN 1 ELSE 0 END) AS CleanedLateCount
FROM Housekeeping_Logs
WHERE LogDate >= DATEADD(DAY, -30, GETDATE())
GROUP BY RoomNumber;

SELECT * FROM vw_HousekeepingPerformance
GO

--Staff Performance View


CREATE VIEW vw_StaffPerformance AS
SELECT 
    S.FullName AS StaffName, S.Role,
    COUNT(DISTINCT R.ReservationID) AS ReservationsHandled,
    SUM(CASE WHEN R.ReservationStatus = 'Checked-in' THEN 1 ELSE 0 END) AS CheckInsProcessed,
    SUM(CASE WHEN R.ReservationStatus = 'Checked-out' THEN 1 ELSE 0 END) AS CheckOutsProcessed,
    COUNT(DISTINCT P.PaymentID) AS TotalPaymentsProcessed,
    ISNULL(SUM(P.AmountPaid), 0) AS TotalRevenueProcessed
FROM Staff S
LEFT JOIN Reservations R ON S.StaffID = R.StaffID
LEFT JOIN Invoices I ON R.ReservationID = I.ReservationID
LEFT JOIN Payments P ON I.InvoiceID = P.InvoiceID
WHERE R.CheckInDate >= DATEADD(DAY, -30, GETDATE()) OR R.CheckInDate IS NULL
GROUP BY S.FullName, S.Role;
GO

-- Query: Top 10 staff by Revenue
SELECT TOP 10 * FROM vw_StaffPerformance ORDER BY TotalRevenueProcessed DESC;









