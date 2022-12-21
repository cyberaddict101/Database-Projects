GO
USE MASTER
GO

DROP DATABASE FitNFine
GO
CREATE DATABASE FitNFine
GO
USE FitNFine
GO
CREATE TABLE Planmaster(
PlanID INT IDENTITY PRIMARY KEY,
PlanType VARCHAR(20), 
Fee MONEY
)

GO
CREATE TABLE MemberDetails(
MemberID INT IDENTITY PRIMARY KEY,
PlanID INT FOREIGN KEY REFERENCES Planmaster(PlanID),
FirstName VARCHAR(25),
LastName VARCHAR(25),
Gender VARCHAR(8) ,
[Address] NVARCHAR(50) ,
Phone_Num VARCHAR(20)
)

GO
CREATE TABLE Branch(
BranchID INT PRIMARY KEY IDENTITY,
BranchName VARCHAR(15),
BranchAddress NVARCHAR (50))

GO
CREATE TABLE StaffDetails(
StaffID INT PRIMARY KEY IDENTITY,
BranchID INT FOREIGN KEY REFERENCES Branch(BranchID),
FirstName VARCHAR(25),
LastName VARCHAR(25),
Designation VARCHAR (25),
[Address] NVARCHAR(50),
Phone_Num VARCHAR(20)
)

GO
CREATE TABLE Facility(
FacilityID INT PRIMARY KEY IDENTITY,
FacilityName VARCHAR(25) )

GO
CREATE TABLE PLANDETAILS(
PlanDetailsID INT PRIMARY KEY IDENTITY,
PlanID INT FOREIGN KEY REFERENCES PLANMASTER(PlanID),
FacilityID INT FOREIGN KEY REFERENCES Facility(FacilityID) 
)

GO
CREATE TABLE Revenue(
PaymentID INT PRIMARY KEY IDENTITY,
MemberID INT FOREIGN KEY REFERENCES MemberDetails(MemberID),
PaymentDate DATETIME, 
PaymentAmount MONEY,
Balance MONEY,
PaymentMethod VARCHAR(25),
CC_NUM NVARCHAR(30),
CC_Name VARCHAR(25),
CC_ExpiryDate DATE,
Check_Num INT,
PaymentStatus VARCHAR(10)
)


GO
CREATE TABLE Booking(
BookingID INT PRIMARY KEY IDENTITY,
StaffID INT FOREIGN KEY REFERENCES StaffDetails(StaffID),
MemberID INT FOREIGN KEY REFERENCES MemberDetails(MemberID),
FacilityID INT FOREIGN KEY REFERENCES Facility(FacilityID),
Desired_Day DATE,
Max_Num INT,
Actual_Num INT,
Booking_status VARCHAR(10),
Desired_Time TIME
)

GO
CREATE TABLE Feedback(
RefID INT PRIMARY KEY IDENTITY,
StaffID INT FOREIGN KEY REFERENCES StaffDetails(StaffID),
BookingID INT FOREIGN KEY REFERENCES Booking(BookingID),
Feedback_Det VARCHAR(50),
Feedback_Type VARCHAR (15),
Action_Taken VARCHAR (50)
)

GO
CREATE TABLE Followup(
Pros_MemberID INT PRIMARY KEY IDENTITY,
StaffID INT FOREIGN KEY REFERENCES StaffDetails(StaffID),
Pros_Fname VARCHAR (25),
Pros_Lname VARCHAR(25),
Phone_Num VARCHAR(20),
Visit_Date DATE
)


------------PLANMASTER CONSTRAINT--------------------
GO
ALTER TABLE Planmaster ALTER COLUMN PlanType VARCHAR(20) NOT NULL
GO
ALTER TABLE Planmaster ADD CONSTRAINT PLANMASTER_UNIQUE UNIQUE (PLANTYPE)
GO
ALTER TABLE Planmaster ALTER COLUMN FEE MONEY NOT NULL
GO
ALTER TABLE PLANMASTER ADD CONSTRAINT FEE_CHK CHECK (FEE>0)

------------------MEMBERDETAILS CONSTRAINT-----------
GO
ALTER TABLE MemberDetails ALTER COLUMN FirstName VARCHAR(25) NOT NULL
GO
ALTER TABLE MemberDetails ALTER COLUMN LastName VARCHAR(25) NOT NULL
GO
ALTER TABLE MemberDetails ALTER COLUMN Gender VARCHAR(8) NOT NULL
GO
ALTER TABLE MemberDetails ADD CONSTRAINT GENDER_CHK CHECK(GENDER IN('MALE','FEMALE'))
GO
ALTER TABLE MemberDetails ALTER COLUMN [Address] NVARCHAR(50) NOT NULL
GO
ALTER TABLE MemberDetails ALTER COLUMN Phone_Num VARCHAR(20) NOT NULL

-------------------------BRANCH CONSTRAINT----------------------
GO
ALTER TABLE Branch ALTER COLUMN BranchName VARCHAR(15) NOT NULL
GO
ALTER TABLE BRANCH ADD CONSTRAINT BRANCH_UNIQUE UNIQUE(BranchName)
GO
ALTER TABLE Branch ALTER COLUMN BranchAddress NVARCHAR (50) NOT NULL
GO
ALTER TABLE Branch ADD CONSTRAINT BRANCH_ADD_UNIQUE UNIQUE(BranchAddress)

------------------STAFFDETAILS CONSTRANT----------------------
GO
ALTER TABLE StaffDetails ALTER COLUMN FirstName VARCHAR(25) NOT NULL
GO
ALTER TABLE StaffDetails ALTER COLUMN LastName VARCHAR(25) NOT NULL
GO
ALTER TABLE StaffDetails ALTER COLUMN Designation VARCHAR (25) NOT NULL
GO
ALTER TABLE StaffDetails ALTER COLUMN [Address] NVARCHAR(50) NOT NULL
GO
ALTER TABLE StaffDetails ALTER COLUMN Phone_Num VARCHAR(20) NOT NULL

------------------FACILITY CONSTRAINT-----------------
GO
ALTER TABLE Facility ALTER COLUMN FacilityName VARCHAR(25) NOT NULL
GO
ALTER TABLE Facility ADD CONSTRAINT FACILITY_NAME_UNIQUE UNIQUE(FacilityName)

------------------REVENUE_CONSTRAINT-----------------
GO
ALTER TABLE Revenue ALTER COLUMN PaymentDate DATETIME NOT NULL
GO
ALTER TABLE Revenue ADD CONSTRAINT PAYMENT_DATE_DEFAULT DEFAULT GETDATE() FOR PaymentDate 
GO
ALTER TABLE Revenue ADD CONSTRAINT PAYMENT_DATE_CHK CHECK(PaymentDate!<GETDATE())
GO
ALTER TABLE Revenue ALTER COLUMN PaymentAmount MONEY NOT NULL
GO
ALTER TABLE Revenue ALTER COLUMN Balance MONEY NOT NULL
GO
ALTER TABLE Revenue ADD CONSTRAINT BALANCE_DEFAULT DEFAULT 0.00 FOR Balance
GO
ALTER TABLE Revenue ALTER COLUMN PaymentStatus VARCHAR(10) NOT NULL
GO
ALTER TABLE Revenue ADD CONSTRAINT PAYMENT_STATUS_DEFAULT DEFAULT 'PENDING' FOR PaymentStatus


----------------BOOKING CONSTRAINT----------------------
GO
ALTER TABLE Booking ALTER COLUMN Desired_Day DATE NOT NULL
GO
ALTER TABLE Booking ALTER COLUMN Max_Num INT NOT NULL
GO
ALTER TABLE Booking ADD CONSTRAINT MAX_NUM_DEFAULT DEFAULT 10 FOR Max_Num
GO
ALTER TABLE Booking ALTER COLUMN Booking_status VARCHAR(10) NOT NULL
GO
ALTER TABLE Booking ADD CONSTRAINT BOOKING_STATUS_DEFAULT DEFAULT 'AVAILABLE' FOR Booking_status
GO
ALTER TABLE Booking ALTER COLUMN Desired_Time TIME NOT NULL

---------FEEDBACK CONSTRAINTS---------------------
GO
ALTER TABLE Feedback ALTER COLUMN Feedback_Det VARCHAR(50) NOT NULL
GO
ALTER TABLE Feedback ALTER COLUMN Feedback_Type VARCHAR (15) NOT NULL
GO
ALTER TABLE Feedback ADD CONSTRAINT FEEDBACK_TYPE_CHK CHECK(Feedback_Type IN('COMPLAINT', 'SUGGESTION','APPRECIATION'))


------------------FOLLOWUP CONSTRAINT---------
GO
ALTER TABLE Followup ALTER COLUMN Pros_Fname VARCHAR (25) NOT NULL
GO
ALTER TABLE Followup ALTER COLUMN Pros_Lname VARCHAR (25) NOT NULL
GO
ALTER TABLE Followup ALTER COLUMN Phone_Num VARCHAR (20) NOT NULL
GO
ALTER TABLE Followup ALTER COLUMN Visit_Date DATE NOT NULL
GO
ALTER TABLE Followup ADD CONSTRAINT VISIT_DATE_DEFAULT DEFAULT GETDATE() FOR Visit_Date

GO
CREATE RULE Phone_Number_Rule AS @phoneno like '0[789][01]'+REPLICATE('-[0-9][0-9][0-9][0-9]',2)

GO

EXECUTE sp_bindrule Phone_number_rule, 'StaffDetails.Phone_Num'
EXECUTE sp_bindrule Phone_number_rule, 'MemberDetails.Phone_Num'
EXECUTE sp_bindrule Phone_number_rule, 'FollowUp.Phone_Num'

GO
CREATE SCHEMA [HumanResources]
GO
CREATE SCHEMA [Services]
GO
CREATE SCHEMA [Members]
GO
CREATE SCHEMA [Transaction]

GO
ALTER SCHEMA HumanResources TRANSFER dbo.StaffDetails
ALTER SCHEMA HumanResources TRANSFER dbo.Branch
ALTER SCHEMA HumanResources TRANSFER dbo.Booking
ALTER SCHEMA HumanResources TRANSFER dbo.Feedback
ALTER SCHEMA HumanResources TRANSFER dbo.FollowUp
ALTER SCHEMA [Services] TRANSFER dbo.PlanMaster
ALTER SCHEMA [Services] TRANSFER dbo.Facility
ALTER SCHEMA [Services] TRANSFER dbo.PlanDetails
ALTER SCHEMA Members TRANSFER dbo.MemberDetails
ALTER SCHEMA [Transaction] TRANSFER dbo.Revenue
GO
CREATE TRIGGER PAYMENT ON [Transaction].REVENUE FOR INSERT AS
BEGIN
	SET NOCOUNT ON
	DECLARE @PaymentMethod varchar(15),@MemberID int, @AmountPaid money,@TableBalance int,@LastBalance money,

			@MemberPaymentCount INT,@LastFullPaymentDate DATE,@LastExpiryDate DATE, @AmountDue money, @PaymentID int,
	
			@PaymentDate date, @MemberPlanType varchar(15),@LastPaymentStatus varchar(15), @LastBalanceDue money,
	
			@CC_Name VARCHAR(25),@CC_NUM NVARCHAR(25),@CC_ExpiryDate DATE, @Check_Num INT,@TotalPayment money

	SELECT @PaymentMethod = PaymentMethod, @MemberID = MemberID, @AmountPaid = PaymentAmount,
	
			@PaymentID = PaymentID, @PaymentDate = PaymentDate,@CC_Name = CC_Name, @CC_ExpiryDate = CC_ExpiryDate,
	
			@CC_NUM = CC_NUM,@Check_Num = Check_Num FROM INSERTED

	SELECT @LastBalanceDue = ( SELECT TOP 1 Balance from [Transaction].Revenue 
			WHERE MemberID = @MemberID AND PaymentID != @PaymentID ORDER BY  PaymentDate DESC)
	
	SELECT @MemberPlanType = PlanType FROM [Services].Planmaster WHERE PlanID
			=(SELECT PlanID FROM Members.MemberDetails WHERE MemberID = @MemberID)
	
	SELECT @LastFullPaymentDate = (SELECT TOP 1 CAST(PaymentDate AS DATE) FROM [Transaction].Revenue 
			WHERE MemberID =@MemberID AND  PaymentStatus = 'PAID' AND PaymentID !=@PaymentID ORDER BY PaymentDate DESC)

	SELECT @LastExpiryDate = DATEADD(DAY, 30,@LastFullPaymentDate)

	SELECT @MemberPaymentCount = (select COUNT(MemberID) FROM [Transaction].Revenue WHERE MemberID=@MemberID AND PaymentID !=@PaymentID)

	SELECT @LastBalance = Balance from [Transaction].Revenue  WHERE MemberID = @MemberID AND PaymentID != @PaymentID ORDER BY 
			PaymentDate DESC OFFSET 0  ROWS FETCH NEXT 1 ROWS ONLY

	SELECT @LastPaymentStatus =(SELECT Top 1 PaymentStatus from [Transaction].Revenue  WHERE MemberID =@MemberID AND PaymentID != @PaymentID 
			ORDER BY  PaymentDate DESC)

	SELECT @AmountDue =  fee from [Services].Planmaster where PlanID =(select PlanID from Members.MemberDetails where MemberID =@MemberID)

	SET @TotalPayment = @AmountDue+@AmountPaid-@LastBalanceDue


	IF @AmountPaid > @AmountDue AND @MemberID NOT IN (SELECT MemberID FROM [Transaction].Revenue WHERE PaymentID != @PaymentID)
		BEGIN
			PRINT 'Amount paid iS more than the required amount!'
			PRINT CONCAT('The required amount is ',@AmountDue)
			ROLLBACK
		END--Overpayment for the first ever payment
	ELSE IF @AmountPaid > @AmountDue AND @MemberID IN (SELECT MemberID FROM [Transaction].Revenue WHERE PaymentID != @PaymentID)
		BEGIN
			PRINT 'Amount Paid is more than the required amount!'
			PRINT CONCAT('The required amount is ',@AmountDue)
			ROLLBACK
		END--Overpayment for the subsequent payment
	Else IF @Check_Num is null and @CC_Name is null and @CC_NUM is not null
		BEGIN
			PRINT 'Kindly supply full information for payment with Creditcard! The credit card name can not be left null.'
			ROLLBACK
		END
	Else if @CC_Name is null AND @CC_NUM is not null and @Check_Num is not null
		BEGIN
			PRINT 'you can not make payment simultaneously with check and creditcard! kindly'+
			' choose one and supply the full information accordingly'
			ROLLBACK	
		END
	Else IF @CC_NUM is null and @Check_Num is null and @CC_Name is not null
		BEGIN
			PRINT 'You can not make payment with Credit card Name alone! Kindly supply the Corresponding Creditcard Number'
			ROLLBACK
		END
	Else if @CC_NUM is null and @Check_Num is not null and @CC_Name is not null
		BEGIN
			PRINT 'Payment with cheque does not require a name, kindly clear-off the name supplied to the "CC_Name" column! '+
				'If your prefered mode of payment is credit card kindly supply the right'+
				' information(Creditcard number, Creditcard Name and Creditcard Expiry date).'
			ROLLBACK
		END
	Else If @CC_Name is not null and @CC_NUM is not null and @Check_Num is not null
		BEGIN
			PRINT'Again,you can can not make payment simulteneously with both cheque and credit card! '
			ROLLBACK
		END
	Else If @CC_Name is null and @CC_NUM is null and @Check_Num is null and @CC_ExpiryDate is not null
		BEGIN
			PRINT 'Cash payment can not have Creditcard Expiry date'
			ROLLBACK
		END
	Else If @CC_Name is null and @CC_NUM is null and @Check_Num is not null and @CC_ExpiryDate is not null
		BEGIN
			PRINT 'Cheque payment can not have Creditcard Expiry date'
			ROLLBACK
		END
	Else if @AmountPaid <= 0
		BEGIN
			PRINT 'INVALID VALUE HAS BEEN SUPPLIED AS THE PAYMENT AMOUNT!'
			PRINT 'Kindly supply valid payment amount (value greater than "0.00")'
			ROLLBACK
		END
	ELSE IF @CC_NUM IN(SELECT CC_NUM FROM [Transaction].Revenue WHERE CC_Name !=@CC_Name)
		BEGIN
			PRINT 'You can not have different credit card owner name attached to the same credit card!'
			PRINT 'Kindly check and enter the correct credit card name.'
			ROLLBACK
		END
	ELSE IF @CC_NUM NOT LIKE CONCAT('[2-5]',REPLICATE('[0-9]',3),  REPLICATE('-[0-9][0-9][0-9][0-9]',3))
		BEGIN
			PRINT 'The credit card number entered is not acceptable,use either master, visa or american express card'
			PRINT 'Kindly enter the 16 digits in the following format "xxxx-xxxx-xxxx-xxxx"'
			ROLLBACK
		END
	ELSE
		BEGIN--BEGINING OF CONDITION TO START ACCEPTING PAYMENT

			IF @AmountPaid < @AmountDue AND @MemberID NOT IN (SELECT MemberID FROM [Transaction].Revenue WHERE PaymentID != @PaymentID)
				BEGIN--AMOUNT PAID IS LESS THAN AMOUNT DUE AND MEMBER HAS NO HISTORY OF PAYMENT
					If @CC_NUM IS NULL and @CC_Name is null and @Check_Num is null

						Begin--Part-payment for the first ever payment of member using CASH
							SET CONTEXT_INFO 0x123456
							UPDATE [Transaction].Revenue SET PaymentMethod = 'CASH' where PaymentID = @PaymentID
							UPDATE [Transaction].Revenue SET Balance = @AmountDue - @AmountPaid WHERE PaymentID = @PaymentID
							PRINT CONCAT(' Part-Payment with cash for your subscribed plan ', @MemberPlanType ,' Successful!')
							PRINT CONCAT('You have paid ', @AmountPaid, ' out of ', @AmountDue , ' kindly pay up the balnce of ',
							@AmountDue - @AmountPaid,' to make your payment full and have access to facilities attached to your subscribed plan')	
						End--Part-payment for the first ever payment of member using cash

					Else if  @CC_Name is null and @CC_NUM is null and @Check_Num is not null

						Begin--Part-payment for the first ever payment of member using CHEQUE
							SET CONTEXT_INFO 0x123456
							UPDATE [Transaction].Revenue SET PaymentMethod = 'CHEQUE' where PaymentID = @PaymentID
							UPDATE [Transaction].Revenue SET Balance = @AmountDue - @AmountPaid WHERE PaymentID = @PaymentID
							PRINT CONCAT(' Part-Payment with Cheque for your subscribed plan ', @MemberPlanType ,' Successful!')
							PRINT CONCAT('You have paid ', @AmountPaid, ' out of ', @AmountDue , ' kindly pay up the balnce of ',
							@AmountDue - @AmountPaid,' to make your payment full and have access to facilities attached to your subscribed plan')
						End--Part-payment for the first ever payment of member using CHEQUE

					Else if @Check_Num is null and @CC_Name is not null and @CC_NUM is not null

						Begin--Part-payment for the first ever payment of member using CREDITCARD
							SET CONTEXT_INFO 0x123456
							UPDATE [Transaction].Revenue SET PaymentMethod = 'CREDIT_CARD' where PaymentID = @PaymentID
							UPDATE [Transaction].Revenue SET Balance = @AmountDue - @AmountPaid WHERE PaymentID = @PaymentID
							if @CC_ExpiryDate is null or @CC_ExpiryDate <= GETDATE()
								begin
									print'Credit card expiry Date can not be null and can not be less than or equal to the present date'
									ROLLBACK
								end
							else
								begin
									PRINT CONCAT(' Part-Payment with Creditcard for your subscribed plan ', @MemberPlanType ,' Successful!')
									PRINT CONCAT('You have paid ', @AmountPaid, ' out of ', @AmountDue , ' kindly pay up the balnce of ',
									@AmountDue - @AmountPaid,' to make your payment full and have access to facilities attached to your subscribed plan')
								end
						End--Part-payment for the first ever payment of member using CREDITCARD

				END--AMOUNT PAID IS LESS THAN AMOUNT DUE AND MEMBER HAS NO HISTORY OF PAYMENT


			ELSE IF @AmountPaid = @AmountDue AND @MemberID NOT IN (SELECT MemberID FROM [Transaction].Revenue WHERE PaymentID != @PaymentID)
				BEGIN--AMOUNT PAID IS EQUAL TO AMOUNT DUE AND MEMBER HAS NO HISTORY OF PAYMENT

					IF @CC_NUM IS NULL and @CC_Name is null and @Check_Num is null

						Begin--Full-payment for the first ever payment of member using CASH
							SET CONTEXT_INFO 0x123456
							UPDATE [Transaction].Revenue SET PaymentMethod = 'CASH', PaymentStatus = 'PAID' where PaymentID = @PaymentID
							UPDATE [Transaction].Revenue SET Balance = @AmountDue - @AmountPaid WHERE PaymentID = @PaymentID
							PRINT CONCAT(' Full-Payment with cash for your subscribed plan ', @MemberPlanType ,' Successful!',
								' Your payment EXPIRES ',DATEADD(DAY, 30,CAST(GETDATE() AS DATE)))
						End--Full-payment for the first ever payment of member using CASH

					Else if  @CC_Name is null and @CC_NUM is null and @Check_Num is not null

						Begin--Full-payment for the first ever payment of member using CHEQUE
							SET CONTEXT_INFO 0x123456
							UPDATE [Transaction].Revenue SET PaymentMethod = 'CHEQUE',PaymentStatus = 'PAID' where PaymentID = @PaymentID
							UPDATE [Transaction].Revenue SET Balance = @AmountDue - @AmountPaid WHERE PaymentID = @PaymentID
							PRINT CONCAT('Full-Payment with Cheque for your subscribed plan ', @MemberPlanType ,' Successful!',
							' Your payment EXPIRES ',DATEADD(DAY, 30,CAST(GETDATE() AS DATE)))
						End--Full-payment for the first ever payment of member using CHEQUE

					Else if @Check_Num is null and @CC_Name is not null and @CC_NUM is not null

						Begin--Full-payment for the first ever payment of member using CREDITCARD
							SET CONTEXT_INFO 0x123456
							UPDATE [Transaction].Revenue SET PaymentMethod = 'CREDIT_CARD',PaymentStatus = 'PAID' where PaymentID = @PaymentID
							UPDATE [Transaction].Revenue SET Balance = @AmountDue - @AmountPaid WHERE PaymentID = @PaymentID
							if @CC_ExpiryDate is null or @CC_ExpiryDate <= GETDATE()
								begin
									print'Credit card expiry Date can not be null and can not be less than or equal to the present date'
									ROLLBACK
								end
							else
								begin
									PRINT CONCAT(' Full-Payment with Creditcard for your subscribed plan ', @MemberPlanType ,' Successful!',
									 ' Your payment EXPIRES ',DATEADD(DAY, 30,CAST(GETDATE() AS DATE)))
								end
						EnD--Full-payment for the first ever payment of member using CREDITCARD

				END--AMOUNT PAID IS EQUAL TO AMOUNT DUE AND MEMBER HAS NO HISTORY OF PAYMENT


		ELSE IF @AmountPaid = @AmountDue AND @MemberID IN (SELECT MemberID FROM [Transaction].Revenue WHERE PaymentID != @PaymentID)

			BEGIN--AMOUNT PAID IS EQUAL TO AMOUNT DUE AND MEMBER HAS HISTORY OF PAYMENT
				IF 'PAID' IN (@LastPaymentStatus)
					BEGIN--LAST PAYMENT WAS FULL PAYMENT/BALANCE UP PAYMENT
						IF @LastExpiryDate > GETDATE()
							BEGIN
								PRINT 'You can not make new payment until the last full-payment expires'
								PRINT CONCAT('Your last full-payment will expire ', @LastExpiryDate)
								ROLLBACK
							END
						
						ELSE

							BEGIN--LAST PAYMENT HAS EXPIRED

								If @CC_NUM IS NULL and @CC_Name is null and @Check_Num is null
							
									Begin--RENEWAL PAYMENT WITH CASH
										SET CONTEXT_INFO 0x123456
										UPDATE [Transaction].Revenue SET PaymentMethod = 'CASH', PaymentStatus = 'PAID' where PaymentID = @PaymentID
										UPDATE [Transaction].Revenue SET Balance = @AmountDue - @AmountPaid WHERE PaymentID = @PaymentID
										PRINT CONCAT(' Full-Payment with cash for your subscribed plan ', @MemberPlanType ,' Successful!')
										PRINT 'Thank you for renewing your subscription'
									End--RENEWAL PAYMENT WITH CASH

								Else if  @CC_Name is null and @CC_NUM is null and @Check_Num is not null

									Begin--RENEWAL PAYMENT WITH CHEQUE
										SET CONTEXT_INFO 0x123456
										UPDATE [Transaction].Revenue SET PaymentMethod = 'CHEQUE',PaymentStatus = 'PAID' where PaymentID = @PaymentID
										UPDATE [Transaction].Revenue SET Balance = @AmountDue - @AmountPaid WHERE PaymentID = @PaymentID
										PRINT CONCAT(' Full-Payment with Cheque for your subscribed plan ', @MemberPlanType ,' Successful!')
										PRINT 'Thank you for renewing your subscription'
									End--RENEWAL PAYMENT WITH CHEQUE

								Else if @Check_Num is null and @CC_Name is not null and @CC_NUM is not null
									Begin--RENEWAL PAYMENT WITH CREDITCARD
										SET CONTEXT_INFO 0x123456
										UPDATE [Transaction].Revenue SET PaymentMethod = 'CREDIT_CARD',PaymentStatus = 'PAID' where PaymentID = @PaymentID
										UPDATE [Transaction].Revenue SET Balance = @AmountDue - @AmountPaid WHERE PaymentID = @PaymentID
										if @CC_ExpiryDate is null or @CC_ExpiryDate <= GETDATE()
											begin
												print'Credit card expiry Date can not be null and can not be less or equal to than the present date'
												ROLLBACK
											end
										else
											begin
												PRINT CONCAT(' Full-Payment with Creditcard for your subscribed plan ', @MemberPlanType ,' Successful!')
												PRINT 'Thank you for renewing your subscription'
											end
									EnD--RENEWAL PAYMENT WITH CREDITCARD

							END--LAST PAYMENT HAS EXPIRED
						END--LAST PAYMENT WAS FULL PAYMENT/BALANCE UP PAYMENT
				ELSE
					Begin--LAST PAYMENT WAS PART-PAYMENT
						PRINT 'The Amount paid is more than the required amount to balance up the  recent part-payment'
						PRINT CONCAT('You need just ',@Lastbalance,' to balance up the payment  and not ', @AmountPaid)
						ROLLBACK
					End--LAST PAYMENT WAS PART-PAYMENT	

			END--AMOUNT PAID IS EQUAL TO AMOUNT DUE AND MEMBER HAS HISTORY OF PAYMENT

		ELSE
			BEGIN--AMOUNT PAID IS LESS THAN AMOUNT DUE AND MEMBER HAS HISTORY OF PAYMENT

				IF @AmountPaid = @LastBalanceDue
					BEGIN--AMOUNT PAID IS ENOUGH TO BALANCE UP THE MOST RECENT PART-PAYMENT 

						IF @CC_NUM IS NULL and @CC_Name is null and @Check_Num is null
							Begin
								SET CONTEXT_INFO 0x123456
								UPDATE [Transaction].Revenue SET PaymentMethod = 'CASH', PaymentStatus = 'PAID' where PaymentID = @PaymentID
								UPDATE [Transaction].Revenue SET Balance =(SELECT TOP 1 Balance FROM [Transaction].Revenue WHERE MemberID = @MemberID 
									AND PaymentID !=@PaymentID ORDER BY PaymentDate DESC) - @AmountPaid WHERE PaymentID = @PaymentID
						
								If 'PAID' IN (SELECT PaymentStatus FROM [Transaction].Revenue WHERE MemberID = @MemberID AND PaymentID != @PaymentID)
							
									BEGIN--WHEN MEMBER HAS MADE/COMPLETED FULL-PAYMENT AT LEAST ONCE
										PRINT 'Balance payment has been made with cash Successfully!'
										PRINT CONCAT('Thank you for Renewing your ', @MemberPlanType, ' subscription!',' Your payment EXPIRES ',
											DATEADD(DAY, 30,CAST(GETDATE() AS DATE)))
									END--WHEN MEMBER HAS MADE/COMPLETED FULL-PAYMENT AT LEAST ONCE

								ELSE

									BEGIN--WHEN IT IS THE FIRST TIME OF MEMBER COMPLETING A FULL-PAYMENT
										PRINT CONCAT('Balance payment for ', @MemberPlanType, 'Plan', ' has been made with cash Successfully!',
											' Your payment EXPIRES ',DATEADD(DAY, 30,CAST(GETDATE() AS DATE)))
									END--WHEN IT IS THE FIRST TIME OF MEMBER COMPLETING A FULL-PAYMENT
							EnD
						Else if  @CC_Name is null and @CC_NUM is null and @Check_Num is not null
							Begin
								SET CONTEXT_INFO 0x123456
								UPDATE [Transaction].Revenue SET PaymentMethod = 'CHEQUE',PaymentStatus = 'PAID' where PaymentID = @PaymentID
								UPDATE [Transaction].Revenue SET Balance =(SELECT TOP 1 Balance FROM [Transaction].Revenue WHERE MemberID = @MemberID 
										AND PaymentID !=@PaymentID ORDER BY PaymentDate DESC) - @AmountPaid WHERE PaymentID = @PaymentID
								If 'PAID' IN (SELECT PaymentStatus FROM [Transaction].Revenue WHERE MemberID = @MemberID AND PaymentID != @PaymentID)
							
									BEGIN--WHEN MEMBER HAS MADE/COMPLETED FULL-PAYMENT AT LEAST ONCE
										PRINT 'Balance payment has been made with CHEQUE Successfully!'
										PRINT CONCAT('Thank you for Renewing your ', @MemberPlanType, ' subscription!',' Your payment EXPIRES ',
											DATEADD(DAY, 30,CAST(GETDATE() AS DATE)))
									END--WHEN MEMBER HAS MADE/COMPLETED FULL-PAYMENT AT LEAST ONCE

								ELSE
									BEGIN--WHEN IT IS THE FIRST TIME OF MEMBER COMPLETING A FULL-PAYMENT
										PRINT CONCAT('Balance payment for ', @MemberPlanType, ' Plan', ' has been made with CHEQUE Successfully',
										' Your payment EXPIRES ',DATEADD(DAY, 30,CAST(GETDATE() AS DATE)))
									END--WHEN IT IS THE FIRST TIME OF MEMBER COMPLETING A FULL-PAYMENT
							EnD
						Else if @Check_Num is null and @CC_Name is not null and @CC_NUM is not null
							BEGIN
								SET CONTEXT_INFO 0x123456
								UPDATE [Transaction].Revenue SET PaymentMethod = 'CREDIT_CARD',PaymentStatus = 'PAID' where PaymentID = @PaymentID
								UPDATE [Transaction].Revenue SET Balance =(SELECT TOP 1 Balance FROM [Transaction].Revenue WHERE MemberID = @MemberID
									AND PaymentID !=@PaymentID ORDER BY PaymentDate DESC) - @AmountPaid WHERE PaymentID = @PaymentID
								if @CC_ExpiryDate is null or @CC_ExpiryDate <= GETDATE()
									begin
										print'Credit card expiry Date can not be null and can not be less than or equal to the present date'
										ROLLBACK
									end
								else
									begin 
										If 'PAID' IN (SELECT PaymentStatus FROM [Transaction].Revenue WHERE MemberID = @MemberID AND PaymentID != @PaymentID)
										
											BEGIN--WHEN MEMBER HAS MADE/COMPLETED FULL-PAYMENT AT LEAST ONCE
												PRINT'Balance payment has been made with Creditcard successfully!'
												PRINT CONCAT('Thank you for Renewing your ', @MemberPlanType, ' subscription!',' Your payment EXPIRES ',
													DATEADD(DAY, 30,CAST(GETDATE() AS DATE)))
											END--WHEN MEMBER HAS MADE/COMPLETED FULL-PAYMENT AT LEAST ONCE

										ELSE

											BEGIN--WHEN IT IS THE FIRST TIME OF MEMBER COMPLETING A FULL-PAYMENT
												PRINT CONCAT('Balance payment for ', @MemberPlanType, ' Plan', ' has been made with Creditcard Successfully',
												' Your payment EXPIRES ',DATEADD(DAY, 30,CAST(GETDATE() AS DATE)))
											END--WHEN IT IS THE FIRST TIME OF MEMBER COMPLETING A FULL-PAYMENT

									enD
							END
					END--AMOUNT PAID IS ENOUGH TO BALANCE UP THE MOST RECENT PART-PAYMENT
					

				ELSE IF @AmountPaid < @LastBalanceDue

					BEGIN--WHEN A MEMBER TOP-UP MOST RECENT PART-PAYMENT

						IF @CC_NUM IS NULL and @CC_Name is null and @Check_Num is null

							Begin
								SET CONTEXT_INFO 0x123456
								UPDATE [Transaction].Revenue SET PaymentMethod = 'CASH', PaymentStatus = 'PENDING' where PaymentID = @PaymentID
								UPDATE [Transaction].Revenue SET Balance =(SELECT TOP 1 Balance FROM [Transaction].Revenue WHERE MemberID = @MemberID 
									AND PaymentID !=@PaymentID ORDER BY PaymentDate DESC) - @AmountPaid WHERE PaymentID = @PaymentID
								PRINT CONCAT('TOP-UP of Part-payment for ', @MemberPlanType, ' Plan', ' has been made with cash Successfully')
								PRINT CONCAT('You have made a total payment of ', @TotalPayment, ' and your total amount to balance up is ', 
									@AmountDue-@TotalPayment )
							EnD

						Else if  @CC_Name is null and @CC_NUM is null and @Check_Num is not null
							
							Begin
								SET CONTEXT_INFO 0x123456
								UPDATE [Transaction].Revenue SET PaymentMethod = 'CHEQUE',PaymentStatus = 'PENDING' where PaymentID = @PaymentID
								UPDATE [Transaction].Revenue SET Balance =(SELECT TOP 1 Balance FROM [Transaction].Revenue WHERE MemberID = @MemberID 
									AND PaymentID !=@PaymentID ORDER BY PaymentDate DESC) - @AmountPaid WHERE PaymentID = @PaymentID
								PRINT CONCAT('TOP-UP of Part-payment for ', @MemberPlanType, ' Plan', 
									' has been made with cash Successfully')
								PRINT CONCAT('You have made a total payment of ', @TotalPayment, 
									' and your total amount to balance up is ', @AmountDue-@TotalPayment )
							End

						Else if @Check_Num is null and @CC_Name is not null and @CC_NUM is not null
							
							BEGIN
								SET CONTEXT_INFO 0x123456
								UPDATE [Transaction].Revenue SET PaymentMethod = 'CREDIT_CARD',PaymentStatus = 'PENDING' where PaymentID = @PaymentID
								UPDATE [Transaction].Revenue SET Balance =(SELECT TOP 1 Balance FROM [Transaction].Revenue WHERE MemberID = @MemberID
									AND PaymentID !=@PaymentID ORDER BY PaymentDate DESC) - @AmountPaid WHERE PaymentID = @PaymentID
								if @CC_ExpiryDate is null or @CC_ExpiryDate <= GETDATE()
									begin
										print'Credit card expiry Date can not be null and can not be less than or equal to the present date'
										ROLLBACK
									end
								else
									begin
										PRINT CONCAT('TOP-UP of Part-payment for ', @MemberPlanType, ' Plan', 
										' has been made with cash Successfully')
										PRINT CONCAT('You have made a total payment of ', @TotalPayment, 
										' and your total amount to balance up is ', @AmountDue-@TotalPayment )
									end
							END

					END--WHEN A MEMBER TOP-UP MOST RECENT PART-PAYMENT
				ELSE
					BEGIN--IF AMOUNT PAID IS > THAN THE LAST BALANCE AND MEMBER HAS MADE PREVIOUS PAYMENT

						IF @LastBalanceDue > 0

							BEGIN--MEMBER HAS A RECENT PART PAYMENT YET TO BE BALANCED
								PRINT CONCAT('Amount paid is more than the required amount to balance up the most recent part-payment for your ',
								 @MemberPlanType, ' Plan',' Subscription')
								PRINT CONCAT('You need just ',@Lastbalance,' to balance up the payment  and not ', @AmountPaid)
								ROLLBACK
							END--MEMBER HAS A RECENT PART PAYMENT YET TO BE BALANCED

						ELSE
							BEGIN--LAST PAYMENT WAS FULL/COMPLETED AND THE BALANCE WAS 0
								IF @LastExpiryDate > GETDATE()
									BEGIN
										PRINT 'You can not make new payment until the last full-payment expires'
										PRINT CONCAT('Your last full-payment will expire ', @LastExpiryDate)
										ROLLBACK
									END
								ELSE
									BEGIN--LAST FULL-PAYMENT/BALANCE UP PAYMENT HAS EXPIRED

										If @CC_NUM IS NULL and @CC_Name is null and @Check_Num is null

											Begin--SUBSEQUENT PART-PAYMENT USING CASH
												SET CONTEXT_INFO 0x123456
												UPDATE [Transaction].Revenue SET PaymentMethod = 'CASH' where PaymentID = @PaymentID
												UPDATE [Transaction].Revenue SET Balance = @AmountDue - @AmountPaid WHERE PaymentID = @PaymentID
												PRINT CONCAT('Part-Payment with cash for ', @MemberPlanType, ' Plan',' Successfull')
												PRINT CONCAT('You have paid ', @AmountPaid, ' out of ', @AmountDue , ' kindly pay up the balnce of ',
												@AmountDue - @AmountPaid,' to make your payment full and have access to facilities attached to your subscribed plan')
											End--SUBSEQUENT PART-PAYMENT USING CASH

										Else if  @CC_Name is null and @CC_NUM is null and @Check_Num is not null

											Begin--SUBSEQUENT PART-PAYMENT USING CHEQUE
												SET CONTEXT_INFO 0x123456
												UPDATE [Transaction].Revenue SET PaymentMethod = 'CHEQUE' where PaymentID = @PaymentID
												UPDATE [Transaction].Revenue SET Balance = @AmountDue - @AmountPaid WHERE PaymentID = @PaymentID
												PRINT CONCAT(' Part-Payment with Cheque for your subscribed plan ', @MemberPlanType ,' Successful!')
												PRINT CONCAT('You have paid ', @AmountPaid, ' out of ', @AmountDue , ' kindly pay up the balnce of ',
												@AmountDue - @AmountPaid,' to make your payment full and have access to facilities attached to your subscribed plan')
											End--SUBSEQUENT PART-PAYMENT USING CHEQUE

										Else if @Check_Num is null and @CC_Name is not null and @CC_NUM is not null

											Begin--SUBSEQUENT PART-PAYMENT USING CREDITCARD
												SET CONTEXT_INFO 0x123456
												UPDATE [Transaction].Revenue SET PaymentMethod = 'CREDIT_CARD' where PaymentID = @PaymentID
												UPDATE [Transaction].Revenue SET Balance = @AmountDue - @AmountPaid WHERE PaymentID = @PaymentID
												if @CC_ExpiryDate is null or @CC_ExpiryDate <= GETDATE()
													begin
														print'Credit card expiry Date can not be null and can not be less than or equal to the present date'
														ROLLBACK
													end
												else
													begin
														PRINT CONCAT(' Part-Payment with Creditcard for your subscribed plan ', @MemberPlanType ,' Successful!')
														PRINT CONCAT('You have paid ', @AmountPaid, ' out of ', @AmountDue , ' kindly pay up the balnce of ',
														@AmountDue - @AmountPaid,' to make your payment full and have access to facilities attached to your subscribed plan')
													end
									EnD--SUBSEQUENT PART-PAYMENT USING CREDITCARD
								END--LAST FULL-PAYMENT/BALANCE UP PAYMENT HAS EXPIRED
							END--LAST PAYMENT WAS FULL/COMPLETED AND THE BALANCE WAS 0
				END--IF AMOUNT PAID IS > THAN THE LAST BALANCE AND MEMBER HAS MADE PREVIOUS PAYMENT
			END--AMOUNT PAID IS LESS THAN AMOUNT DUE AND MEMBER HAS HISTORY OF PAYMENT
	END--BEGINING OF CONDITION TO START ACCEPTING PAYMENT
END




----------------------------------TRIGGER TO PREVENT MANUAL UPDATING OF REVENUE TABLE-----------------------------
GO
CREATE TRIGGER REVENUE_UPDATE ON [Transaction].Revenue FOR UPDATE  AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CONT_INFO VARBINARY(128)
	SELECT @CONT_INFO = CONTEXT_INFO()
	IF @CONT_INFO = 0X123456
		BEGIN
			RETURN
		END
	ELSE
		BEGIN
			PRINT 'YOU ARE NOT ALLOWED TO UPDATE THE REVENUE TABLE'
			ROLLBACK
		END

END

GO
CREATE TRIGGER REVENUE_DELETE ON [Transaction].Revenue FOR DELETE  AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CONT_INFO VARBINARY(128)
	SELECT @CONT_INFO = CONTEXT_INFO()
	IF @CONT_INFO = 0X123456
		BEGIN
			RETURN
		END
	ELSE
		BEGIN
			PRINT 'YOU ARE NOT ALLOWED TO DELETE FROM THE REVENUE TABLE'
			ROLLBACK
		END

END






		

-------------------------PLANMASTER---------------------------------
-- trigger to prevent PlanID delete 
GO
CREATE TRIGGER PlanID_not_deletable on [services].Planmaster AFTER DELETE AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CONT_INFO VARBINARY(128)
	SELECT @CONT_INFO = CONTEXT_INFO()
	IF @CONT_INFO = 0X123456
		BEGIN
			RETURN
		END
	ELSE
		BEGIN
		PRINT 'YOU ARE NOT ALLOWED DELETE FROM PLAN MASTER TABLE!'
		ROLLBACK
	END 
END

GO
CREATE TRIGGER PLAN_MASTER ON [services].Planmaster FOR INSERT AS
BEGIN
	SET NOCOUNT ON
	DECLARE @PlanType VARCHAR(10)
	SELECT @PlanType =PlanType FROM INSERTED

	IF @PlanType NOT IN ('PREMIUM', 'STANDARD', 'GUEST')
		BEGIN
			PRINT' You have entered an invalid Plantype!'
			PRINT'Acceptable PlanType include "PREMIUM", "STANDARD" OR "GUEST"'
			ROLLBACK
		END
	ELSE
		BEGIN
			PRINT 'Plan Succesfully Included in Planmaster!'
		END

END

 -----------------------PLANDETAILS TRIGGER
GO
create trigger PlanDetails_planID on [services].PlanDetails for insert  as
BEGIN
	SET NOCOUNT ON
	DECLARE @PlanID int, @FacilityID int
	SELECT @PlanID = PlanID, @FacilityID= FacilityID FROM inserted
	IF (SELECT COUNT (PLANID) FROM [services].PlanDetails WHERE FacilityID =@FacilityID AND PlanID = @PlanID) > 1
		BEGIN
			PRINT 'You can not attach same facility more than once to the same PlanID'
			ROLLBACK
		END-- TO ENSURE THAT YOU CAN ONLY ATTACH PLANID TO A FACILITY ONCE
	ELSE
		BEGIN
			PRINT 'PlanID attached to facility successfully'
		END
END
	
-------------------BOOKING
--set booking such that once a member books a facility, the payment status on revenue table is updated to paid

GO
CREATE TRIGGER Facility_Booking_trg ON HumanResources.Booking AFTER INSERT AS
BEGIN
	SET NOCOUNT ON
	DECLARE @FacilityID int, @MemberID int,@MaxNum int,  @DesiredDay date, @LatestExpiryDate date,@LatestFullPaymentDate date, 
		@ClosingTime time,@DesiredTime time

	
	SELECT @FacilityID = FacilityID, @MemberID = MemberID, @DesiredDay = Desired_Day, @DesiredTime =  Desired_Time FROM inserted

	SET @ClosingTime = '20:30'
	
	SELECT @LatestFullPaymentDate =(SELECT TOP 1 CAST(PaymentDate AS DATE) FROM [Transaction].Revenue 
			WHERE MemberID =@MemberID AND  PaymentStatus = 'PAID' ORDER BY PaymentDate DESC)

	SELECT @LatestExpiryDate= DATEADD(DAY, 30,@LatestFullPaymentDate)

	SELECT @MaxNum = Max_Num FROM BOOKING WHERE FacilityID = @FacilityID AND Desired_Day = @DesiredDay
	IF  GETDATE() !< @LatestExpiryDate
		BEGIN
			PRINT 'This member payment for the subscribed plan has expired! '+
					'Kindly make new payment in full for plan before booking facility'
			ROLLBACK--TO ENSURE THAT SUBSCRIPTION IS FULLY PAID FOR OR ACTIVE BEFORE BOOKING FACILITY
		END
	ELSE IF @DesiredTime >@ClosingTime
		BEGIN
			PRINT 'you can not use the facility outside the closing hours!'+ 
				'kindly choose another time of the day withine the working hours "7am-8:30pm" '
			ROLLBACK
		END
	ELSE IF @LatestExpiryDate IS NULL
		BEGIN
			PRINT 'Member is yet to make full payment for the subscribed plan'+
					'Kindly make payment in full for plan before booking facility'
			ROLLBACK
		END
	ELSE IF @MemberID NOT IN(Select MemberID from Members.MemberDetails where PlanID=(select PlanID from [Services].PLANDETAILS where FacilityID = @FacilityID))--check it out and confirm
		BEGIN
			PRINT 'This member does not have access to BOOK/USE the facility! ' +
					'Kindly upgrade Plan subscription to be able to enjoy this service. Thank you.'
			ROLLBACK
		END--TO CHECK IF MEMBER'S PLAN CAN ACCESS THE FACILITY HE/SHE WANTS TO BOOK
	ELSE IF @DesiredDay <= cast(GETDATE() AS DATE)
		BEGIN
			PRINT 'Desired day to use the facility while booking can not be day/s before nor the present day! '+
					'The facility has to be booked for day/s after the present day'
			ROLLBACK
		END--TO ENSURE THAT YOU HAVE TO BOOK THE FACILITY AHEAD BEFORE USE
	ELSE IF @MemberID in (SELECT memberID from HumanResources.Booking where Desired_Day>=cast(GETDATE() AS DATE))
		BEGIN
			PRINT 'You can not make more than one booking per time! '+
				'Please use the already booked facility before making another booking'
			ROLLBACK
		END--TO ENSURE THAT MEMBER CAN NOT MAKE MULTIPLE BOOKING ON SAME FACILITY OR ANY OTHER FACILITY
	ELSE
		BEGIN
			SET NOCOUNT ON
			DECLARE @Booked_members_for_facility int,@MemberBookingID int, @BookingID INT
			SELECT @Booked_members_for_facility = COUNT(BookingID)  FROM HumanResources.Booking WHERE FacilityID = @FacilityID AND Desired_Day = @DesiredDay
			SELECT @BookingID = BookingID FROM INSERTED
			SELECT @MemberBookingID = BookingID FROM HumanResources.Booking WHERE FacilityID = @FacilityID AND Desired_Day = @DesiredDay and MemberID = @MemberID
			
			IF @Booked_members_for_facility = (SELECT TOP 1 MAX_NUM FROM HumanResources.Booking WHERE FacilityID = @FacilityID 
							and Desired_Day =@DesiredDay ORDER BY BookingID ASC)--added bookingID to ensure specificity(2022/16/11)
				BEGIN
					PRINT 'Facility successfully booked! '+ 
							'This is the last member the facility can take '
					SET CONTEXT_INFO 0x123456
					UPDATE HumanResources.Booking SET BOOKING_STATUS = 'BOOKED' WHERE FacilityID = @FacilityID AND Desired_Day = @DesiredDay
					UPDATE Booking SET Actual_Num = @Booked_members_for_facility WHERE FacilityID = @FacilityID AND Desired_Day = @DesiredDay
						AND BookingID = @BOOKINGID
				END--TO CHANGE THE BOOKING STATUS TO BOOKED ONCE THE MAXNUM FOR THE FACILITY HAS BEEN REACHED.
			ELSE IF @Booked_members_for_facility < (SELECT TOP 1 MAX_NUM FROM HumanResources.Booking WHERE FacilityID = @FacilityID and Desired_Day =@DesiredDay ORDER BY BookingID ASC)--CONDITION STATEMENT FOR THE FIRST SUCCESSFUL BOOKING
				BEGIN
					PRINT 'Facility successfully booked for member ' + CAST(@MemberID AS VARCHAR(10)) +
							' BookingID is ' + CAST(@MemberBookingID AS VARCHAR(10))
						SET CONTEXT_INFO 0x123456
						UPDATE Booking SET Actual_Num = @Booked_members_for_facility WHERE FacilityID = @FacilityID AND Desired_Day = @DesiredDay
						AND BookingID = @BOOKINGID
				IF @Booked_members_for_facility >= 1 --CONDITION STATEMENT TO SET SUBSEQUENT MAXNUM ENTRY AUTOMATICALLY TO THE FIRST ENTRTY
					BEGIN
						SET CONTEXT_INFO 0x123456
						UPDATE Booking SET Max_Num = (SELECT TOP 1 Max_Num FROM HumanResources.Booking WHERE FacilityID = @FacilityID AND Desired_Day = @DesiredDay)
					END
				END
			ELSE
				BEGIN
					PRINT CONCAT('Facility is fully booked for the desired day!',' ','Kindly choose another day to use the facility')
					ROLLBACK
				END--TO PREVENT BOOKING MORE THAN THE SET MAX NUMBER FOR THE FACILITY WITH REFERENCE TO THE DESIRED DAY OF USAGE

		END
END


-----------------------TRIGGER TO PREENT MANUAL UPDATE OF BOOKING TABLE--------------------------------------------
GO
CREATE TRIGGER BOOKING_UPDATE ON HumanResources.Booking FOR UPDATE AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CONT_INFO VARBINARY(128)
	SELECT @CONT_INFO = CONTEXT_INFO()
	IF @CONT_INFO = 0X123456
		BEGIN
			RETURN
		END
	ELSE
		BEGIN
			PRINT 'YOU ARE NOT ALLOWED TO UPDATE FROM THE BOOKING TABLE'
			ROLLBACK
		END

END

---------------------------------------TRIGGER TO PREVENT MANUAL DELETE OF THE BOOKING TABLE---------------------------------

GO
CREATE TRIGGER BOOKIN_DELETE ON HumanResources.Booking FOR DELETE AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CONT_INFO VARBINARY(128)
	SELECT @CONT_INFO = CONTEXT_INFO()
	IF @CONT_INFO = 0X123456
		BEGIN
			RETURN
		END
	ELSE
		BEGIN
			PRINT 'YOU ARE NOT ALLOWED TO DELETE FROM THE BOOKING TABLE'
			ROLLBACK
		END

END




---------------------------------FEEDBACK TRIGGER------------------------------------

GO
CREATE TRIGGER FEEDBACK_TRIGGER ON HumanResources.Feedback FOR INSERT  AS
BEGIN
	SET NOCOUNT ON
	DECLARE @BookingID INT, @Desired_Day DATE, @FeedbackType VARCHAR(15), @FeedbackDetail VARCHAR (50)
	
	SELECT @BookingID= BookingID, @FeedbackType = Feedback_Type, @FeedbackDetail = Feedback_Det FROM INSERTED
	SELECT @Desired_Day = Desired_Day FROM HumanResources.Booking WHERE BookingID =@BookingID

	IF @BookingID NOT IN(SELECT BookingID FROM HumanResources.Booking)
		BEGIN
			PRINT'You have enterd an invalid BookingID!'
			PRINT 'Kindly enter the BookingID gotten during facility booking!'
			ROLLBACK
		END
	ELSE IF @Desired_Day > GETDATE()
		BEGIN
			PRINT 'You can not give feedback on a facility before using it!'
			ROLLBACK
		END
	ELSE IF @FeedbackType NOT IN ('COMPLAINT', 'SUGGESTION', 'APPRECIATION')
		BEGIN
			PRINT 'Invalid FeedBack  type entered!'+
				' FeedBackType should be "COMPLAINT", "SUGGESTION" OR "APPRECIATION"'
			ROLLBACK
		END
	ELSE IF @FeedbackDetail IS NULL or @FeedbackDetail =''
		BEGIN
			PRINT 'Kindly give a conscise detail about the feedback as this will help management improve on services '+
					'and take necessary action where needed'
			ROLLBACK
		END
	ELSE
		BEGIN
			PRINT 'FeedBack succefully submitted! Thank you for your Feedback!'
		END
END


-----------------------------------------TRIGGER TO PREVENT MANUAL DELETE OF THE FEEDBACK TABLE-------------------

GO
CREATE TRIGGER FEEDBACK_DELETE ON HumanResources.Feedback FOR DELETE AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CONT_INFO VARBINARY(128)
	SELECT @CONT_INFO = CONTEXT_INFO()
	IF @CONT_INFO = 0X123456
		BEGIN
			RETURN
		END
	ELSE
		BEGIN
			PRINT 'YOU ARE NOT ALLOWED TO DELETE FROM THE FEEDBACK TABLE'
			ROLLBACK
		END

END




-------------------------------STAFFDETAILS TRIGGER------------------------
GO
CREATE TRIGGER Staff_Details ON HumanResources.StaffDetails FOR INSERT AS
BEGIN
	SET NOCOUNT ON
	DECLARE	@FirstName VARCHAR(25),@LastName VARCHAR(25),@Designation VARCHAR(25),@Address VARCHAR(50)

	SELECT @FirstName = FirstName, @LastName = LastName,@Designation = Designation,@Address = [Address] FROM INSERTED

	IF @FirstName IS NULL OR @LastName IS NULL OR @Designation IS NULL OR @Address IS NULL
		BEGIN
			PRINT'FirstName,LastName,Designation,Address can not be null! kindly supply required data to all feilds'
			ROLLBACK
		END
	ELSE IF @FirstName ='' OR @LastName ='' OR @Designation ='' OR @Address =''
		BEGIN
			PRINT 'FirstName,LastName,Designation,Address can not be BLANK! kindly supply required data to all feilds'
			ROLLBACK
		END
	ELSE
		BEGIN
			PRINT 'Staff details successfully entered'
		END

END



-----------------------MEMBERDETAILS TRIGGER--------------
GO
CREATE TRIGGER MEMBER_DETAILS_TRIGGER ON Members.MemberDetails FOR INSERT AS
BEGIN
	SET NOCOUNT ON
	DECLARE 	@FirstName VARCHAR(25),@LastName VARCHAR(25),@Gender VARCHAR(8),@Address VARCHAR(50)
	SELECT @FirstName = FirstName, @LastName = LastName,@Gender = Gender,@Address = [Address] FROM INSERTED
	IF @FirstName IS NULL OR @LastName IS NULL OR @Gender IS NULL OR @Address IS NULL
		BEGIN
			PRINT'FirstName,LastName,Gender,Address can not be null! kindly supply required data to all feilds'
			ROLLBACK
		END
	ELSE IF @FirstName ='' OR @LastName ='' OR @Gender ='' OR @Address =''
		BEGIN
			PRINT 'FirstName,LastName,Gender,Address can not be BLANK! kindly supply required data to all feilds'
			ROLLBACK
		END

		ELSE
	BEGIN
		PRINT 'Member details entered succesfully!'
	END
END


-------------booking_insert-----------
GO

CREATE PROCEDURE booking_insert(@staffid int,@memberid int, @facilityid int, 
@desiredday date,@maxnum int=NULL, @desiredtime time
)
	 AS BEGIN SET NOCOUNT ON

	
		INSERT INTO HumanResources.Booking(
		StaffID,MemberID,FacilityID,
		Desired_Day, Max_Num, Desired_Time
		)
		VALUES(
		@staffid,@memberid,@facilityid,
		@desiredday,@maxnum,@desiredtime
		)
	
END	

------------feedback_insert-------------
GO

CREATE PROCEDURE feedback_insert(
@staffid int,@bookingid int,
@feedbackdet varchar(50)='',
@feedbacktype varchar(15),
@actiontaken varchar(50)=NULL
)
  AS BEGIN SET NOCOUNT ON


		INSERT INTO HumanResources.Feedback(
		StaffID,BookingID,Feedback_Det,
		Feedback_Type, Action_Taken
		)
		VALUES(
		@staffid,@bookingid,
		@feedbackdet,
		@feedbacktype ,
		@actiontaken 
		 )
	


END

---------------followup_insert------------
GO
CREATE PROCEDURE followup_insert(
@staffid int,@prosfname varchar(25),
@proslname varchar(25),@phonenum varchar(20)
)
  AS 
 BEGIN SET NOCOUNT ON
			INSERT INTO HumanResources.Followup(
			StaffID,Pros_Fname,Pros_Lname,Phone_Num)
			VALUES(
			@staffid,@prosfname,@proslname,@phonenum
			
			)
		
 END

 --------staffdetails_insert-------------
 GO

 CREATE PROCEDURE staffdetails_insert(
@branchid int, @firstname varchar(25),
@lastname varchar(25),@designation varchar(25),
@address nvarchar(50), @phonenum varchar(20)
)
  AS 
 BEGIN SET NOCOUNT ON
	INSERT INTO HumanResources.StaffDetails(
	BranchID,FirstName,LastName,Designation,
	[Address],Phone_Num)
	VALUES(
	@branchid,@firstname,@lastname,
	@designation,@address,@phonenum
	)
 END


 ------------memberdetails_insert------------
 GO
 CREATE PROCEDURE memberdetails_insert(
 @planid int,@firstname varchar(25),
@lastname varchar(25),@gender varchar(8),
@address nvarchar(50), @phonenum varchar(20)
 )

 AS 
BEGIN SET NOCOUNT ON
	INSERT INTO Members.MemberDetails(
	PlanID,FirstName,LastName,Gender,
	[Address],Phone_Num)
	VALUES(
	@planid,@firstname,@lastname,@gender,
	@address,@phonenum
	)


END

--------------facility_insert--------------
GO
CREATE PROCEDURE facility_insert(
@facilityname varchar(25))

 AS 
BEGIN SET NOCOUNT ON
	INSERT INTO [Services].Facility(
	FacilityName)
	VALUES(
	@facilityname
	)
END

-----------------plandetails_insert-------------
GO
CREATE PROCEDURE plandetails_insert(
@planid int, @facilityid int
)
 AS 
BEGIN SET NOCOUNT ON
	INSERT INTO [Services].PLANDETAILS(
	PlanID,FacilityID)
	VALUES(
	@planid,
	@facilityid
	)
END

--------------------planmaster_insert----------------------
GO
CREATE PROCEDURE planmaster_insert(
@plantype varchar(20),@fee money)

 AS 
BEGIN SET NOCOUNT ON
	INSERT INTO [Services].Planmaster(
	PlanType,Fee
	)
	VALUES(
	@plantype,@fee
	)
END


---REVENUE INSERT PROCEDURE------
GO

ALTER PROCEDURE Revenue_insert(
@memberid int,
@paymentamount money,
@ccnum NVARCHAR(25) = NULL,
@ccname varchar(15) =NULL,
@ccexpirydate date = NULL,
@checknum int = NULL
)

  AS BEGIN SET NOCOUNT ON
		
				INSERT INTO [Transaction].Revenue(
				MemberID,PaymentAmount,CC_NUM,
				CC_Name,CC_ExpiryDate,Check_Num
				)
				VALUES (@memberid,@paymentamount,
				@ccnum,@ccname,@ccexpirydate,@checknum
				)
			
	END


/*GO
insert into [services].planmaster values('Guest', 1000),
('Standard', 1500),('Premium', 2000)
SELECT*FROM [SERVICES].Planmaster

GO
	insert into MemberDetails values
(1, 'tinker', 'paul', 'male', 'mowe ibafo', '07036005209'),
(2, 'udoka', 'paul', 'male', 'ikeja ibafo', '08160066915'),
(3, 'oluyole', 'bewaji', 'male', 'sango ota', '08036005209')
SELECT*FROM MemberDetails

INSERT INTO [Services].Facility(FacilityName) VALUES ('MainStudio')
TRUNCATE TABLE [SERVICES].FACILITY
SELECT *FROM [Services].Facility
*/

-------------BRANCH------
INSERT INTO HumanResources.Branch (BranchName,  BranchAddress) VALUES('GOODNESS','OSHODI')
GO
INSERT INTO HumanResources.Branch (BranchName,  BranchAddress) VALUES('JOY','AKUTE')
GO
INSERT INTO HumanResources.Branch (BranchName,  BranchAddress) VALUES('CUTE','MAGODO')


-------------STAFFDETAILS
GO
EXEC staffdetails_insert 1, 'IBRAHIM','GOODMAN','INSTRUCTOR','SANGO','070-3611-2255'
GO
EXEC staffdetails_insert 2, 'JOHN','ABODERIN','INSTRUCTOR','ABEOKUTA','080-3511-2215'
GO
EXEC staffdetails_insert 2, 'ENIOLA','NICEMAN','INSTRUCTOR','LAGOS','090-3511-2215'

----------PLANMASTER-------
GO
EXEC planmaster_insert 'PREMIUM', 2000
GO
EXEC planmaster_insert 'STANDARD', 1500
GO
EXEC planmaster_insert 'GUEST', 1000


---------------MEMBERDETAILS-----------
GO
EXEC memberdetails_insert 1, 'tinker', 'paul', 'male', 'mowe ibafo', '070-3600-5209'
GO
EXEC memberdetails_insert 2, 'udoka', 'paul', 'male', 'ikeja ibafo', '081-6006-6915'
GO
EXEC memberdetails_insert 3, 'oluyole', 'bewaji', 'male', 'sango ota', '080-3600-5209'

----------FACILITY-------
EXEC facility_insert 'Main Studio'
GO
EXEC facility_insert 'Free Weights Area'
GO
EXEC facility_insert 'Weight Lifting '
GO
EXEC facility_insert'Cardio Area'
GO
EXEC facility_insert'Strength Area'
GO
EXEC facility_insert'Cycling Studio'
GO
EXEC facility_insert'Kick Boxing Zone'
GO
EXEC facility_insert'Lounge Area'
GO
EXEC facility_insert'Yoga'
GO
EXEC facility_insert'swimming pool'
GO
EXEC facility_insert'sauna'
GO
EXEC facility_insert'Aerobic'

-------PLANDETAILS---
GO
EXEC plandetails_insert 1,1
GO
EXEC plandetails_insert 1,2
GO
EXEC plandetails_insert 1,3
GO
EXEC plandetails_insert 2,1
GO
EXEC plandetails_insert 2,2
GO
EXEC plandetails_insert 2,3
GO
EXEC plandetails_insert 2,4
GO
EXEC plandetails_insert 2,5
GO
EXEC plandetails_insert 2,6
GO
EXEC plandetails_insert 2,7
GO
EXEC plandetails_insert 2,8
GO
EXEC plandetails_insert 3,1
GO
EXEC plandetails_insert 3,2
GO
EXEC plandetails_insert 3,3
GO
EXEC plandetails_insert 3,4
GO
EXEC plandetails_insert 3,5
GO
EXEC plandetails_insert 3,6
GO
EXEC plandetails_insert 3,7
GO
EXEC plandetails_insert 3,8
GO
EXEC plandetails_insert 3,9
GO
EXEC plandetails_insert 3,10
GO
EXEC plandetails_insert 3,11
GO
EXEC plandetails_insert 3,12

SELECT * FROM [Transaction].Revenue
--------------payment------------

 
select * from Members.MemberDetails
go
select * from HumanResources.Branch
go
select * from HumanResources.StaffDetails
go
select * from  [Services].PLANDETAILS
go
select * from [Services].Planmaster
go
select * from [Transaction].Revenue