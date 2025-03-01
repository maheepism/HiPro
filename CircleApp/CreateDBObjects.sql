IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
CREATE TABLE [Posts] (
    [PostId] int NOT NULL IDENTITY,
    [Content] nvarchar(max) NOT NULL,
    [ImageUrl] nvarchar(max) NULL,
    [NrOfReports] int NOT NULL,
    [DateCreated] datetime2 NOT NULL,
    [DateUpdated] datetime2 NOT NULL,
    CONSTRAINT [PK_Posts] PRIMARY KEY ([PostId])
);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240612222002_Initial', N'9.0.2');

EXEC sp_rename N'[Posts].[PostId]', N'Id', 'COLUMN';

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240612223459_Changed_PostId_Id', N'9.0.2');

CREATE TABLE [Users] (
    [Id] int NOT NULL IDENTITY,
    [FullName] nvarchar(max) NOT NULL,
    [ProfilePictureUrl] nvarchar(max) NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY ([Id])
);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241109142907_User_Added', N'9.0.2');

ALTER TABLE [Posts] ADD [UserId] int NOT NULL DEFAULT 0;

CREATE INDEX [IX_Posts_UserId] ON [Posts] ([UserId]);

ALTER TABLE [Posts] ADD CONSTRAINT [FK_Posts_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241109144713_Added_User_Post_Relation', N'9.0.2');

CREATE TABLE [Likes] (
    [PostId] int NOT NULL,
    [UserId] int NOT NULL,
    [Id] int NOT NULL,
    CONSTRAINT [PK_Likes] PRIMARY KEY ([PostId], [UserId]),
    CONSTRAINT [FK_Likes_Posts_PostId] FOREIGN KEY ([PostId]) REFERENCES [Posts] ([Id]),
    CONSTRAINT [FK_Likes_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION
);

CREATE INDEX [IX_Likes_UserId] ON [Likes] ([UserId]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241109203830_Added_Like_Entity', N'9.0.2');

CREATE TABLE [Comments] (
    [Id] int NOT NULL IDENTITY,
    [Content] nvarchar(max) NOT NULL,
    [DateCreated] datetime2 NOT NULL,
    [DateUpdated] datetime2 NOT NULL,
    [PostId] int NOT NULL,
    [UserId] int NOT NULL,
    CONSTRAINT [PK_Comments] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Comments_Posts_PostId] FOREIGN KEY ([PostId]) REFERENCES [Posts] ([Id]),
    CONSTRAINT [FK_Comments_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION
);

CREATE INDEX [IX_Comments_PostId] ON [Comments] ([PostId]);

CREATE INDEX [IX_Comments_UserId] ON [Comments] ([UserId]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241110153932_Added_Post_Comments', N'9.0.2');

CREATE TABLE [Favorites] (
    [PostId] int NOT NULL,
    [UserId] int NOT NULL,
    [Id] int NOT NULL,
    [DateCreated] datetime2 NOT NULL,
    CONSTRAINT [PK_Favorites] PRIMARY KEY ([PostId], [UserId]),
    CONSTRAINT [FK_Favorites_Posts_PostId] FOREIGN KEY ([PostId]) REFERENCES [Posts] ([Id]),
    CONSTRAINT [FK_Favorites_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION
);

CREATE INDEX [IX_Favorites_UserId] ON [Favorites] ([UserId]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241110180056_Added_Post_Favorites', N'9.0.2');

ALTER TABLE [Posts] ADD [IsPrivate] bit NOT NULL DEFAULT CAST(0 AS bit);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241110184621_Added_Post_IsPrivateFlag', N'9.0.2');

CREATE TABLE [Reports] (
    [PostId] int NOT NULL,
    [UserId] int NOT NULL,
    [Id] int NOT NULL,
    [DateCreated] datetime2 NOT NULL,
    CONSTRAINT [PK_Reports] PRIMARY KEY ([PostId], [UserId]),
    CONSTRAINT [FK_Reports_Posts_PostId] FOREIGN KEY ([PostId]) REFERENCES [Posts] ([Id]),
    CONSTRAINT [FK_Reports_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION
);

CREATE INDEX [IX_Reports_UserId] ON [Reports] ([UserId]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241110194935_Added_Post_Reports', N'9.0.2');

ALTER TABLE [Users] ADD [IsDeleted] bit NOT NULL DEFAULT CAST(0 AS bit);

ALTER TABLE [Posts] ADD [IsDeleted] bit NOT NULL DEFAULT CAST(0 AS bit);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241111201654_Added_Post_And_User_IsDeleted', N'9.0.2');

CREATE TABLE [Stories] (
    [Id] int NOT NULL IDENTITY,
    [ImageUrl] nvarchar(max) NULL,
    [DateCreated] datetime2 NOT NULL,
    [IsDeleted] bit NOT NULL,
    [UserId] int NOT NULL,
    CONSTRAINT [PK_Stories] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Stories_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE
);

CREATE INDEX [IX_Stories_UserId] ON [Stories] ([UserId]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241112181531_Add_Stories', N'9.0.2');

CREATE TABLE [Hashtags] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NOT NULL,
    [Count] int NOT NULL,
    [DateCreated] datetime2 NOT NULL,
    [DateUpdated] datetime2 NOT NULL,
    CONSTRAINT [PK_Hashtags] PRIMARY KEY ([Id])
);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20241113203248_Added_Hashtags', N'9.0.2');

ALTER TABLE [Comments] DROP CONSTRAINT [FK_Comments_Users_UserId];

ALTER TABLE [Favorites] DROP CONSTRAINT [FK_Favorites_Users_UserId];

ALTER TABLE [Likes] DROP CONSTRAINT [FK_Likes_Users_UserId];

ALTER TABLE [Posts] DROP CONSTRAINT [FK_Posts_Users_UserId];

ALTER TABLE [Reports] DROP CONSTRAINT [FK_Reports_Users_UserId];

ALTER TABLE [Stories] DROP CONSTRAINT [FK_Stories_Users_UserId];

ALTER TABLE [Users] DROP CONSTRAINT [PK_Users];

EXEC sp_rename N'[Users]', N'AspNetUsers', 'OBJECT';

ALTER TABLE [AspNetUsers] ADD [AccessFailedCount] int NOT NULL DEFAULT 0;

ALTER TABLE [AspNetUsers] ADD [ConcurrencyStamp] nvarchar(max) NULL;

ALTER TABLE [AspNetUsers] ADD [Email] nvarchar(256) NULL;

ALTER TABLE [AspNetUsers] ADD [EmailConfirmed] bit NOT NULL DEFAULT CAST(0 AS bit);

ALTER TABLE [AspNetUsers] ADD [LockoutEnabled] bit NOT NULL DEFAULT CAST(0 AS bit);

ALTER TABLE [AspNetUsers] ADD [LockoutEnd] datetimeoffset NULL;

ALTER TABLE [AspNetUsers] ADD [NormalizedEmail] nvarchar(256) NULL;

ALTER TABLE [AspNetUsers] ADD [NormalizedUserName] nvarchar(256) NULL;

ALTER TABLE [AspNetUsers] ADD [PasswordHash] nvarchar(max) NULL;

ALTER TABLE [AspNetUsers] ADD [PhoneNumber] nvarchar(max) NULL;

ALTER TABLE [AspNetUsers] ADD [PhoneNumberConfirmed] bit NOT NULL DEFAULT CAST(0 AS bit);

ALTER TABLE [AspNetUsers] ADD [SecurityStamp] nvarchar(max) NULL;

ALTER TABLE [AspNetUsers] ADD [TwoFactorEnabled] bit NOT NULL DEFAULT CAST(0 AS bit);

ALTER TABLE [AspNetUsers] ADD [UserName] nvarchar(256) NULL;

ALTER TABLE [AspNetUsers] ADD CONSTRAINT [PK_AspNetUsers] PRIMARY KEY ([Id]);

CREATE TABLE [AspNetRoles] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(256) NULL,
    [NormalizedName] nvarchar(256) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoles] PRIMARY KEY ([Id])
);

CREATE TABLE [AspNetUserClaims] (
    [Id] int NOT NULL IDENTITY,
    [UserId] int NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserLogins] (
    [LoginProvider] nvarchar(450) NOT NULL,
    [ProviderKey] nvarchar(450) NOT NULL,
    [ProviderDisplayName] nvarchar(max) NULL,
    [UserId] int NOT NULL,
    CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
    CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserTokens] (
    [UserId] int NOT NULL,
    [LoginProvider] nvarchar(450) NOT NULL,
    [Name] nvarchar(450) NOT NULL,
    [Value] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
    CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetRoleClaims] (
    [Id] int NOT NULL IDENTITY,
    [RoleId] int NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserRoles] (
    [UserId] int NOT NULL,
    [RoleId] int NOT NULL,
    CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
    CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE INDEX [EmailIndex] ON [AspNetUsers] ([NormalizedEmail]);

CREATE UNIQUE INDEX [UserNameIndex] ON [AspNetUsers] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL;

CREATE INDEX [IX_AspNetRoleClaims_RoleId] ON [AspNetRoleClaims] ([RoleId]);

CREATE UNIQUE INDEX [RoleNameIndex] ON [AspNetRoles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL;

CREATE INDEX [IX_AspNetUserClaims_UserId] ON [AspNetUserClaims] ([UserId]);

CREATE INDEX [IX_AspNetUserLogins_UserId] ON [AspNetUserLogins] ([UserId]);

CREATE INDEX [IX_AspNetUserRoles_RoleId] ON [AspNetUserRoles] ([RoleId]);

ALTER TABLE [Comments] ADD CONSTRAINT [FK_Comments_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION;

ALTER TABLE [Favorites] ADD CONSTRAINT [FK_Favorites_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION;

ALTER TABLE [Likes] ADD CONSTRAINT [FK_Likes_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION;

ALTER TABLE [Posts] ADD CONSTRAINT [FK_Posts_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE;

ALTER TABLE [Reports] ADD CONSTRAINT [FK_Reports_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION;

ALTER TABLE [Stories] ADD CONSTRAINT [FK_Stories_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250112165439_Added_Identity_Tables', N'9.0.2');

ALTER TABLE [AspNetRoleClaims] DROP CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId];

ALTER TABLE [AspNetUserClaims] DROP CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId];

ALTER TABLE [AspNetUserLogins] DROP CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId];

ALTER TABLE [AspNetUserRoles] DROP CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId];

ALTER TABLE [AspNetUserRoles] DROP CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId];

ALTER TABLE [AspNetUserTokens] DROP CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId];

ALTER TABLE [Comments] DROP CONSTRAINT [FK_Comments_AspNetUsers_UserId];

ALTER TABLE [Favorites] DROP CONSTRAINT [FK_Favorites_AspNetUsers_UserId];

ALTER TABLE [Likes] DROP CONSTRAINT [FK_Likes_AspNetUsers_UserId];

ALTER TABLE [Posts] DROP CONSTRAINT [FK_Posts_AspNetUsers_UserId];

ALTER TABLE [Reports] DROP CONSTRAINT [FK_Reports_AspNetUsers_UserId];

ALTER TABLE [Stories] DROP CONSTRAINT [FK_Stories_AspNetUsers_UserId];

ALTER TABLE [AspNetUserTokens] DROP CONSTRAINT [PK_AspNetUserTokens];

ALTER TABLE [AspNetUsers] DROP CONSTRAINT [PK_AspNetUsers];

ALTER TABLE [AspNetUserRoles] DROP CONSTRAINT [PK_AspNetUserRoles];

ALTER TABLE [AspNetUserLogins] DROP CONSTRAINT [PK_AspNetUserLogins];

ALTER TABLE [AspNetUserClaims] DROP CONSTRAINT [PK_AspNetUserClaims];

ALTER TABLE [AspNetRoles] DROP CONSTRAINT [PK_AspNetRoles];

ALTER TABLE [AspNetRoleClaims] DROP CONSTRAINT [PK_AspNetRoleClaims];

EXEC sp_rename N'[AspNetUserTokens]', N'UserTokens', 'OBJECT';

EXEC sp_rename N'[AspNetUsers]', N'Users', 'OBJECT';

EXEC sp_rename N'[AspNetUserRoles]', N'UserRoles', 'OBJECT';

EXEC sp_rename N'[AspNetUserLogins]', N'UserLogins', 'OBJECT';

EXEC sp_rename N'[AspNetUserClaims]', N'UserClaims', 'OBJECT';

EXEC sp_rename N'[AspNetRoles]', N'Roles', 'OBJECT';

EXEC sp_rename N'[AspNetRoleClaims]', N'RoleClaims', 'OBJECT';

EXEC sp_rename N'[UserRoles].[IX_AspNetUserRoles_RoleId]', N'IX_UserRoles_RoleId', 'INDEX';

EXEC sp_rename N'[UserLogins].[IX_AspNetUserLogins_UserId]', N'IX_UserLogins_UserId', 'INDEX';

EXEC sp_rename N'[UserClaims].[IX_AspNetUserClaims_UserId]', N'IX_UserClaims_UserId', 'INDEX';

EXEC sp_rename N'[RoleClaims].[IX_AspNetRoleClaims_RoleId]', N'IX_RoleClaims_RoleId', 'INDEX';

ALTER TABLE [UserTokens] ADD CONSTRAINT [PK_UserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]);

ALTER TABLE [Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY ([Id]);

ALTER TABLE [UserRoles] ADD CONSTRAINT [PK_UserRoles] PRIMARY KEY ([UserId], [RoleId]);

ALTER TABLE [UserLogins] ADD CONSTRAINT [PK_UserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]);

ALTER TABLE [UserClaims] ADD CONSTRAINT [PK_UserClaims] PRIMARY KEY ([Id]);

ALTER TABLE [Roles] ADD CONSTRAINT [PK_Roles] PRIMARY KEY ([Id]);

ALTER TABLE [RoleClaims] ADD CONSTRAINT [PK_RoleClaims] PRIMARY KEY ([Id]);

ALTER TABLE [Comments] ADD CONSTRAINT [FK_Comments_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION;

ALTER TABLE [Favorites] ADD CONSTRAINT [FK_Favorites_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION;

ALTER TABLE [Likes] ADD CONSTRAINT [FK_Likes_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION;

ALTER TABLE [Posts] ADD CONSTRAINT [FK_Posts_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE;

ALTER TABLE [Reports] ADD CONSTRAINT [FK_Reports_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE NO ACTION;

ALTER TABLE [RoleClaims] ADD CONSTRAINT [FK_RoleClaims_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([Id]) ON DELETE CASCADE;

ALTER TABLE [Stories] ADD CONSTRAINT [FK_Stories_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE;

ALTER TABLE [UserClaims] ADD CONSTRAINT [FK_UserClaims_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE;

ALTER TABLE [UserLogins] ADD CONSTRAINT [FK_UserLogins_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE;

ALTER TABLE [UserRoles] ADD CONSTRAINT [FK_UserRoles_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([Id]) ON DELETE CASCADE;

ALTER TABLE [UserRoles] ADD CONSTRAINT [FK_UserRoles_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE;

ALTER TABLE [UserTokens] ADD CONSTRAINT [FK_UserTokens_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users] ([Id]) ON DELETE CASCADE;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250112171232_Updated_Identity_Tables_Names', N'9.0.2');

ALTER TABLE [Users] ADD [Bio] nvarchar(max) NULL;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250124202037_Added_User_Bio_Field', N'9.0.2');

COMMIT;
GO

