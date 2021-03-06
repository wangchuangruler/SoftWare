USE [master]
GO
/****** Object:  Database [Software]    Script Date: 2019/2/16 14:21:39 ******/
CREATE DATABASE [Software]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Software', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Software.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Software_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Software_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Software] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Software].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Software] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Software] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Software] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Software] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Software] SET ARITHABORT OFF 
GO
ALTER DATABASE [Software] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Software] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Software] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Software] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Software] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Software] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Software] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Software] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Software] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Software] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Software] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Software] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Software] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Software] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Software] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Software] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Software] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Software] SET RECOVERY FULL 
GO
ALTER DATABASE [Software] SET  MULTI_USER 
GO
ALTER DATABASE [Software] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Software] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Software] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Software] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Software] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Software', N'ON'
GO
ALTER DATABASE [Software] SET QUERY_STORE = OFF
GO
USE [Software]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [Software]
GO
/****** Object:  Table [dbo].[Manage]    Script Date: 2019/2/16 14:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Manage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Password] [nvarchar](50) NULL,
	[RoleId] [int] NULL,
	[CreateTime] [datetime] NULL,
 CONSTRAINT [PK_Manage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Members]    Script Date: 2019/2/16 14:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Members](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OpenId] [varchar](50) NOT NULL,
	[Session_key] [varchar](128) NOT NULL,
	[NickName] [nvarchar](50) NULL,
	[HeadImg] [nvarchar](500) NULL,
	[Sex] [int] NULL,
	[Status] [int] NOT NULL,
	[Province] [nvarchar](50) NULL,
	[City] [nvarchar](50) NULL,
	[CreateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Members] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NLogInfo]    Script Date: 2019/2/16 14:21:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NLogInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Level] [nvarchar](50) NULL,
	[Url] [nvarchar](500) NULL,
	[Parameter] [text] NULL,
	[Message] [text] NULL,
 CONSTRAINT [PK_NLogInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[Members] ADD  CONSTRAINT [DF_Members_Status]  DEFAULT ((2)) FOR [Status]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'微信中用户唯一标识' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'OpenId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'会话密钥' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'Session_key'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'昵称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'NickName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'头像' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'HeadImg'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'性别；0：男 1:女' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'Sex'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'状态（2：正常）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Members', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO
USE [master]
GO
ALTER DATABASE [Software] SET  READ_WRITE 
GO
